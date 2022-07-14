//
//  DKNetworkMonitor.h
//  DKSkynet
//
//  Created by admin on 2022/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKNetworkMonitor : NSObject
@property (nonatomic, assign, readonly) BOOL isMonitoring;

+ (instancetype)shared;
- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
