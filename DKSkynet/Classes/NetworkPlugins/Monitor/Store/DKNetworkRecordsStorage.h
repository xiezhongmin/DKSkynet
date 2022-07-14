//
//  DKNetworkRecordsStore.h
//  DKSkynet
//
//  Created by admin on 2022/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DKNetworkTransaction;

@interface DKNetworkRecordsStorage : NSObject

+ (instancetype)shared;

- (void)storeNetworkTransaction:(DKNetworkTransaction *)transaction;

- (NSArray <DKNetworkTransaction *> *)readNetworkTransactions;

- (void)removeAllNetworkTransactions:(void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
