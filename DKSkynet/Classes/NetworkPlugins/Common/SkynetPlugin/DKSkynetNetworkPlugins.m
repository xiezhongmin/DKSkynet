//
//  DKSkynetNetworkPlugins.m
//  DKSkynet
//
//  Created by admin on 2022/7/5.
//

#import "DKSkynetNetworkPlugins.h"
#import <DKSkynet/DKSkynetPlugin.h>

@interface DKSkynetNetworkPlugins ()<DKSkynetPlugin>

@end

@implementation DKSkynetNetworkPlugins DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"networks";
}

+ (NSString *)pluginName
{
    return @"网络相关";
}

+ (NSString *)pluginImageName
{
    return [NSString stringWithFormat: @"%@/skynet_net", DK_SKYNET_BUNDLE_PATH];
}

+ (BOOL)isTop
{
    return YES;
}

@end
