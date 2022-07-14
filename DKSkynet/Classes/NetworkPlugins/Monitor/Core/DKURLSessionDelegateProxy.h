//
//  DKURLSessionDelegateProxy.h
//  DKSkynet
//
//  Created by admin on 2022/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DKNetworkObserver;

@interface DKURLSessionDelegateProxy : NSObject <NSURLSessionDelegate>

- (instancetype)initWithOriginDelegate:(nullable id)originDelegate observer:(DKNetworkObserver *)observer;

@end

NS_ASSUME_NONNULL_END
