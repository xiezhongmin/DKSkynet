//
//  Envs.h
//  DKSkynet
//
//  Created by duke on 2024/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// - key
#define DK_ENV_PLUGINS_KEY                  (@"dk_env_plugins_key")

/// - 切换环境通知事件
/// vlaue: int - 当前环境的值
/// [[NSNotificationCenter defaultCenter] postNotificationName:kDKEnvSwitchNotification object:value];
static NSString *kDKEnvSwitchNotification = @"kDKEnvSwitchNotification";

@interface Envs : NSObject
+ (BOOL)isShow;
+ (void)showSwitchEnvs;
+ (void)dissmis;
+ (int)currentEnv;
@end

NS_ASSUME_NONNULL_END
