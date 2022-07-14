//
//  DKNetworkTransactionsURLMatcher.m
//  DKSkynet
//
//  Created by admin on 2022/7/8.
//

#import "DKNetworkTransactionsURLFilter.h"
#import <DKKit/DKStringUtils.h>
#import "DKNetworkTransaction.h"

@implementation DKNetworkTransactionsURLFilter

+ (BOOL)matchTransactionFilter:(DKNetworkTransaction *)transaction matchString:(NSString *)filter
{
    if (!transaction || ![transaction isKindOfClass:DKNetworkTransaction.class]) {
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"request.URL.absoluteString CONTAINS %@", filter];
    
    return [predicate evaluateWithObject:transaction];
}

@end
