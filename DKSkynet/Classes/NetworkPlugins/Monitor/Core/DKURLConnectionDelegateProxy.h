//
//  DKURLConnectionDelegateProxy.h
//  DKSkynet
//
//  Created by admin on 2022/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DKNetworkObserver;

@interface DKURLConnectionDelegateProxy : NSObject <NSURLConnectionDelegate>

- (instancetype)initWithOriginDelegate:(nullable id)originDelegate observer:(DKNetworkObserver *)observer;

@end

NS_ASSUME_NONNULL_END
