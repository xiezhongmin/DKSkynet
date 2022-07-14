//
//  DKSkynetNetworkPlugins.m
//  DKSkynet
//
//  Created by admin on 2022/7/5.
//

#import "DKSkynetNetworkPlugins.h"
#import <DKSkynetPlugin.h>

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
    return @"DKSkynet.bundle/skynet_net";
}

+ (BOOL)isTop
{
    return YES;
}

@end
