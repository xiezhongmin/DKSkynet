//
//  DKNetworkMonitorViewModel.m
//  DKSkynet
//
//  Created by admin on 2022/7/6.
//

#import "DKNetworkMonitorViewModel.h"
#import "DKNetworkRecordsStorage.h"
#import "DKNetworkTransactionsURLFilter.h"
#import <DKKit/DKStringUtils.h>

@interface DKNetworkMonitorViewModel ()

@property (nonatomic, copy, readwrite) NSArray <DKNetworkTransaction *> *networkTransactions;
@property (nonatomic, copy, readwrite) NSArray <DKNetworkTransaction *> *filteredNetworkTransactions;
@property (nonatomic, copy) NSString *currentSearchText;
@property (atomic, assign) NSInteger filterSentinel;

@end

@implementation DKNetworkMonitorViewModel

- (void)loadTransactions
{
    NSArray <DKNetworkTransaction *> *trans = [[DKNetworkRecordsStorage shared] readNetworkTransactions];
    [self setNetworkTransactions:trans];
}

- (void)incomeNewTransactions:(NSArray <DKNetworkTransaction *> *)transactionsNew
{
    NSMutableArray *transactions = [transactionsNew mutableCopy];
    [transactions addObjectsFromArray:self.networkTransactions];
    self.networkTransactions = [transactions copy];
}

- (void)removeAllTransactions
{
    self.networkTransactions = @[];
    self.filteredNetworkTransactions = @[];
}

// MARK: - search match
- (void)updateSearchResultsWithText:(NSString *)searchString completion:(void (^)(void))completion
{
    [self filterTaskStarted];

    self.currentSearchText = searchString;
    
    if ([DKStringUtils dk_isEmpty:searchString]) {
        self.filteredNetworkTransactions = self.networkTransactions.mutableCopy;
        if (completion) {
            completion();
        }
        [self filterTaskEnded];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self shouldCancelFilterTask]) {
            return;
        }
        
        NSMutableArray *filteredNetworkTransactions = @[].mutableCopy;
        __block BOOL taskCanceled = NO;
        [self.networkTransactions enumerateObjectsUsingBlock:^(DKNetworkTransaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self shouldCancelFilterTask]) {
                *stop = YES;
                taskCanceled = YES;
                return;
            }
            
            if ([DKNetworkTransactionsURLFilter matchTransactionFilter:obj matchString:searchString]) {
                [filteredNetworkTransactions addObject:obj];
            }
        }];
        
        if (taskCanceled) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self shouldCancelFilterTask]) {
                return;
            }
            
            if ([self.currentSearchText isEqualToString:searchString]) {
                self.filteredNetworkTransactions = filteredNetworkTransactions;
                if (completion) {
                    completion();
                }
            }
            
            [self filterTaskEnded];
        });
    });
}

#pragma mark -  Filter Task -

- (void)filterTaskStarted
{
    _filterSentinel += 1;
}

- (void)filterTaskEnded
{
    _filterSentinel -= 1;
}

- (BOOL)shouldCancelFilterTask
{
    if (_filterSentinel > 1) {
        _filterSentinel -= 1;
        return YES;
    }
    return NO;
}

@end
