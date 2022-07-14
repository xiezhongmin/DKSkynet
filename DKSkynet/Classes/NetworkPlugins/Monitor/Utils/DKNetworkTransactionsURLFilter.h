//
//  DKNetworkTransactionsURLMatcher.h
//  DKSkynet
//
//  Created by admin on 2022/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DKNetworkTransaction;

@interface DKNetworkTransactionsURLFilter : NSObject

+ (BOOL)matchTransactionFilter:(DKNetworkTransaction *)transaction matchString:(NSString *)filter;

@end

NS_ASSUME_NONNULL_END
