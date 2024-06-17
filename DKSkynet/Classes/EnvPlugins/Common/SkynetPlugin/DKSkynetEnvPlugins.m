//
//  DKSkynetEnvPlugins.m
//  AFNetworking
//
//  Created by duke on 2024/6/3.
//

#import "DKSkynetEnvPlugins.h"
#import <DKSkynetPlugin.h>
#import "Envs.h"

@interface DKSkynetEnvPlugins ()<DKSkynetPlugin>
@end

@implementation DKSkynetEnvPlugins DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId { 
    return @"evn";
}

+ (NSString *)pluginImageName { 
    return @"https://i.loli.net/2019/07/01/5d19ceb94f01a84638.png";
}

+ (NSString *)pluginName { 
    return @"环境切换";
}

+ (BOOL)isTop
{
    return YES;
}

- (void)pluginDidStart:(BOOL *)isHightLight
{
    [Envs showSwitchEnvs];
}

- (void)pluginDidStop
{
    [Envs dissmis];
    NSLog(@"环境切换 - pluginDidStop");
}

@end
