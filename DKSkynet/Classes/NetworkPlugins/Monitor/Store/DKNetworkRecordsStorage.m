//
//  DKNetworkRecordsStore.m
//  DKSkynet
//
//  Created by admin on 2022/6/29.
//

#import "DKNetworkRecordsStorage.h"
#import "MTAppenderFile.h"
#import <DKSkynet/DKSkynetStorage.h>
#import <DKSkynet/DKSkynetStorage+MMAP.h>
#import "DKNetworkTransaction.h"
#import <DKKit/DKKitMacro.h>
#import <DKSkynet/DKSkynetUtility.h>

static NSString * const kDKSkynetHugeNetworkRecordFlag = @"skynet_network_huge";
static NSString * const kDKSkynetNetworkRecordFileName = @"network_transaction";
static NSString * const kDKSkynetNetworkRecordHugeFileName = @"network_transaction_huge";

@interface DKNetworkRecordsStorage ()

@property (nonatomic, strong) MTAppenderFile *networkRecordsFile;

@end

@implementation DKNetworkRecordsStorage

+ (instancetype)shared
{
    static DKNetworkRecordsStorage *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (void)storeNetworkTransaction:(DKNetworkTransaction *)transaction
{
    NSDictionary *dict = [transaction dictionaryFromAllProperty];
    if ([dict count] == 0 || ![NSJSONSerialization isValidJSONObject:dict]) {
        return;
    }

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict.copy options:0 error:&error];
    if (!jsonData) {
        DKLogError(@"store network transactions failed: %@", error.localizedDescription);
        return;
    }
    
    NSString *value = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!value) {
        DKLogError(@"store network transactions failed: value is nil");
        return;
    }
    
    if (jsonData.length < 16 * 1024) {
        dispatch_async([DKSkynetStorage shared].storeQueue, ^(void) {
            [self.networkRecordsFile appendText:value];
        });
    } else {
        dispatch_async([DKSkynetStorage shared].storeQueue, ^(void) {
            [self appendNetworkRecordsWithText:value];
        });
    }
}

- (void)appendNetworkRecordsWithText:(NSString *)text
{
    @autoreleasepool {
        NSString *path = [NSString stringWithFormat:@"%@/%@", [DKSkynetStorage shared].storeDirectory, kDKSkynetNetworkRecordHugeFileName];
        NSString *appendStr = [text stringByAppendingString:kDKSkynetHugeNetworkRecordFlag];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [appendStr writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
            return;
        }
        
        NSData *data = [appendStr dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:data];
            [fileHandle closeFile];
        }
    }
}

- (NSArray <DKNetworkTransaction *> *)readNetworkTransactions
{
    __block NSMutableString *fileContent = [NSMutableString string];
    DKSkynetStorage *storage = [DKSkynetStorage shared];
    dispatch_sync(storage.storeQueue, ^{
        for (NSString *directorie in [storage getStoreDirectoriesPaths]) {
            NSString *content = [storage loadMmapContentFromDirectory:directorie fileName:kDKSkynetNetworkRecordFileName];
            if (content && content.length) {
                [fileContent appendString:content];
            }
        }
    });
    
    NSMutableArray <DKNetworkTransaction *> *transactions = [NSMutableArray array];
    NSMutableSet *transactionSet = [NSMutableSet set];
    [fileContent enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        NSData *data = [line dataUsingEncoding:NSUTF8StringEncoding];
        if (!data)
            return;
        
        NSDictionary *transactionDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (!transactionDict || !transactionDict.count) {
            return;
        }
        
        DKNetworkTransaction *transaction = [DKNetworkTransaction transactionFromPropertyDictionary:transactionDict];
        if (transaction && ![transactionSet containsObject:transaction.requestId]) {
            [transactions addObject:transaction];
            [transactionSet addObject:transaction.requestId];
        }
    }];
    
    // 这里是对大于 16kb 的请求数据的处理
    NSArray *hugeTransactions = [self hugeNetworkRecords];
    for (NSString *transactionStr in hugeTransactions) {
        NSData *data = [transactionStr dataUsingEncoding:NSUTF8StringEncoding];
        if (!data)
            continue;
        
        NSDictionary *transactionDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (!transactionDict || !transactionDict.count) {
            continue;
        }
        
        DKNetworkTransaction *transaction = [DKNetworkTransaction transactionFromPropertyDictionary:transactionDict];
        if (transaction && ![transactionSet containsObject:transaction.requestId]){
            [transactions addObject:transaction];
            [transactionSet addObject:transaction.requestId];
        }
    }
    
    if (!transactions.count) {
        return nil;
    }

    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(startTime)) ascending:NO];
    transactions = [[transactions sortedArrayUsingDescriptors:@[ descriptor ]] copy];

    return transactions;
}

- (void)removeAllNetworkTransactions:(void (^)(void))complete;

{
    dispatch_async([DKSkynetStorage shared].storeQueue, ^{
        [self.networkRecordsFile close];
        self.networkRecordsFile = nil;
        
        NSArray <NSString *> *files = [[DKSkynetStorage shared] getStoreAllFilesPaths];
        [files enumerateObjectsUsingBlock:^(NSString * _Nonnull path, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([path.lastPathComponent isEqualToString:[kDKSkynetNetworkRecordFileName stringByAppendingPathExtension:kMmapPathExtension]]
                || [path.lastPathComponent isEqualToString:[kDKSkynetNetworkRecordFileName stringByAppendingPathExtension:kFilePathExtension]] ||
                [path.lastPathComponent isEqualToString:kDKSkynetNetworkRecordHugeFileName]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{

            if (complete) {
                complete();
            }
        });
    });
}

#pragma mark - Getter -

- (NSArray *)hugeNetworkRecords
{
    __block NSArray *records = nil;
    DKSkynetStorage *stroage = [DKSkynetStorage shared];
    dispatch_sync(stroage.storeQueue, ^{
        NSString *path = [NSString stringWithFormat:@"%@/%@", stroage.storeDirectory, kDKSkynetNetworkRecordHugeFileName];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
        if (fileHandle) {
            NSString *recordStr = [[NSString alloc] initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
            records = [recordStr componentsSeparatedByString:kDKSkynetHugeNetworkRecordFlag];
        }
    });
    return records;
}

- (MTAppenderFile *)networkRecordsFile
{
    if (_networkRecordsFile == nil) {
        MTAppenderFile *file = [[MTAppenderFile alloc] initWithFileDir:[DKSkynetStorage shared].storeDirectory name:kDKSkynetNetworkRecordFileName];
        [file open];
        [file appendText:@"key,value"];
        _networkRecordsFile = file;
    }
    return _networkRecordsFile;
}

@end
