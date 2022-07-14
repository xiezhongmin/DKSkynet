//
//  DKSkynetStorage.m
//  DKSkynet
//
//  Created by admin on 2022/6/30.
//

#import "DKSkynetStorage.h"
#import <DKKit/DKKitMacro.h>
#import <DKKit/NSDate+DKFormat.h>
#import <DKSkynet/DKSkynetUtility.h>

@interface DKSkynetStorage ()

@property (nonatomic, copy, readwrite) NSString *storeDirectory;
@property (nonatomic, readwrite) dispatch_queue_t storeQueue;

@end

@implementation DKSkynetStorage

+ (instancetype)shared
{
    static DKSkynetStorage *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.storeDirectory = [self currentStorePath];
        [self createStoreDirectoryIfNeed];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            @autoreleasepool {
                [self autoTrimStoreDirectoryOfFiles];
            }
        });
    }
    return self;
}

+ (void)setStoreDirectoryOption:(DKSkynetStoreDirectoryOption)option
{
    gDKSkynetStoreDirectoryOption = option;
}

- (void)createStoreDirectoryIfNeed
{
    NSError *error;
    NSString *dir = self.storeDirectory;
    // create directory if not exist
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]
        && ![[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error]) {
        DKLogWarn(@"[DKSyket] create directory %@ failed, %@ %@", dir, @(error.code), error.localizedDescription);
    }
}

- (NSArray <NSString *> *)getStoreDirectories
{
    NSArray<NSString *> *storeDirectories = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.rootStoreDirectory error:NULL];
    storeDirectories = [storeDirectories sortedArrayUsingComparator:^NSComparisonResult(NSString *_Nonnull obj1, NSString *_Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    return storeDirectories;
}

- (NSArray <NSString *> *)getStoreDirectoriesPaths
{
    NSArray<NSString *> *storeDirectories = [self getStoreDirectories];
    NSMutableArray <NSString *> *storeDirectoriesPaths = [[NSMutableArray alloc] initWithCapacity:storeDirectories.count];
    [storeDirectories enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length) {
            NSString *storeDirectoriesPath = [self.rootStoreDirectory stringByAppendingPathComponent:obj];
            if (storeDirectoriesPath) {
                [storeDirectoriesPaths addObject:storeDirectoriesPath];
            }
        }
    }];
    
    return storeDirectoriesPaths;
}

- (NSArray <NSString *> *)getStoreAllFilesPaths
{
    NSMutableArray <NSString *> *storeAllFilesPaths = [[NSMutableArray alloc] init];
    NSArray <NSString *> *storeDirectoriesPaths = [self getStoreDirectoriesPaths];
    [storeDirectoriesPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull path, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <NSString *> *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        [files enumerateObjectsUsingBlock:^(NSString * _Nonnull file, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *filePath = [path stringByAppendingPathComponent:file];
            if (filePath) {
                [storeAllFilesPaths addObject:filePath];
            }
        }];
    }];
    
    return storeAllFilesPaths;
}

- (double)getStoreAllFilesTotalSize
{
    __block double totalSize = 0;
    NSArray <NSString *> *storeAllFilesPaths = [self getStoreAllFilesPaths];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [storeAllFilesPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([fileManager fileExistsAtPath:filePath])
        {
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
            totalSize += (double)([fileAttributes fileSize]);
        }
    }];
    
    return totalSize / (1024.0 * 1024.0);
}

- (void)autoTrimStoreDirectoryOfFiles
{
    NSArray<NSString *> *storeDirectories = [self getStoreDirectories];
    [storeDirectories enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *createDate = [NSDate dk_dateWithString:obj format:self.dateFormatter];
        if (!createDate) {
            return;
        }
        
        if (createDate.timeIntervalSinceNow < -(kDKSynetStoreFileKeepActive * 24 * 60 * 60)) {
            [[NSFileManager defaultManager] removeItemAtPath:[self.rootStoreDirectory stringByAppendingPathComponent:obj] error:NULL];
        }
    }];
}

- (void)clearAllStoreDirectories:(void (^)(double totalClearedSize, NSError *error))complete
{
    dispatch_async(self.storeQueue, ^{
        NSError *error;
        NSArray<NSString *> *storeDirectories = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.rootStoreDirectory error:&error];
        if (error) {
            if (complete) {
                complete(0, error);
            }
            return;
        }
        
        __block double totalClearedSize = 0;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [storeDirectories enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error;
            NSString *path = [self.rootStoreDirectory stringByAppendingPathComponent:obj];
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            if (error) {
                DKLogError(@"[DKSkynet] path %@ clear error %@", path, error);
            }
            else {
                NSArray <NSString *> *files = [fileManager contentsOfDirectoryAtPath:path error:nil];
                [files enumerateObjectsUsingBlock:^(NSString * _Nonnull file, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *filePath = [path stringByAppendingPathComponent:file];
                    if ([fileManager fileExistsAtPath:filePath])
                    {
                        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:file error:nil];
                        totalClearedSize += (double)([fileAttributes fileSize]);
                    }
                }];
            }
        }];
        
        if (!totalClearedSize) {
            if (complete) {
                NSError *error = [NSError errorWithDomain:@"com.duke.skynet.storage" code:-1000 userInfo:@{ NSLocalizedDescriptionKey : @"clear failure" }];
                complete(0, error);
            }
        } else {
            if (complete) {
                complete(totalClearedSize, nil);
            }
        }
    });
}

#pragma mark - Getter -

- (dispatch_queue_t)storeQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attr;
        attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, 0);
        self->_storeQueue = dispatch_queue_create("com.duke.skynet.storage", attr);
    });
    return _storeQueue;
}

- (NSString *)currentStorePath
{
    static NSString *_currentStorePath = @"";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *root = [self rootStoreDirectory];
        NSString *formattedDateString = [self currentStorePathLastComponent];
        _currentStorePath = [root stringByAppendingPathComponent:formattedDateString];
    });
    return _currentStorePath;
}

- (NSString *)currentStorePathLastComponent
{
    NSTimeInterval appLaunchedTime = [DKSkynetUtility appLaunchedTime];
    NSDate *launchedDate = [NSDate dateWithTimeIntervalSince1970:appLaunchedTime];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self dateFormatter]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *formattedDateString = [dateFormatter stringFromDate:launchedDate];
    return formattedDateString;
}

- (NSString *)dateFormatter
{
    return @"yyyy-MM-dd";
}

- (NSString *)rootStoreDirectory
{
    if (gDKSkynetStoreDirectoryOption == DKSkynetStoreDirectoryOptionDocument) {
        return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kDKSynetRootStoreDirectory];
    } else if (gDKSkynetStoreDirectoryOption == DKSkynetStoreDirectoryOptionLibraryCaches) {
        return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kDKSynetRootStoreDirectory];;
    } else if (gDKSkynetStoreDirectoryOption == DKSkynetStoreDirectoryOptionTmp) {
        return [NSTemporaryDirectory() stringByAppendingPathComponent:kDKSynetRootStoreDirectory];
    } else {
        return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kDKSynetRootStoreDirectory];
    }
}

@end
