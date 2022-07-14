//
//  DKNetworkMonitorViewModel.h
//  DKSkynet
//
//  Created by admin on 2022/7/6.
//

#import <Foundation/Foundation.h>
#import "DKNetworkTransaction.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKNetworkMonitorViewModel : NSObject

@property (nonatomic, assign) BOOL isPresentingSearch;
@property (nonatomic, copy, readonly) NSArray <DKNetworkTransaction *> *networkTransactions;
@property (nonatomic, copy, readonly) NSArray <DKNetworkTransaction *> *filteredNetworkTransactions;

- (void)loadTransactions;
- (void)incomeNewTransactions:(NSArray <DKNetworkTransaction *> *)transactionsNew;

- (void)removeAllTransactions;

// MARK: - search match
- (void)updateSearchResultsWithText:(NSString *)searchString completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
