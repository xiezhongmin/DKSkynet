//
//  DKSkynet.h
//  DKSkynet
//
//  Created by admin on 2022/5/26.
//

#import <Foundation/Foundation.h>

/// ** 无侵入服务 **
/// - 开启服务
/// [[NSNotificationCenter defaultCenter] postNotificationName:@"dk_skynet_open" object:nil];
/// - 关闭服务
/// [[NSNotificationCenter defaultCenter] postNotificationName:@"dk_skynet_stop" object:nil];

// 开启服务
#define DK_SKYNET_OPEN              (@"dk_skynet_open")
// 关闭服务
#define DK_SKYNET_STOP              (@"dk_skynet_stop")

NS_ASSUME_NONNULL_BEGIN

@protocol DKSkynetPlugin;

@interface DKSkynet : NSObject

+ (instancetype)shared;

+ (void)registerPlugin:(id <DKSkynetPlugin>)plugin;

- (void)startServer;

- (void)stopServer;


@end

NS_ASSUME_NONNULL_END
