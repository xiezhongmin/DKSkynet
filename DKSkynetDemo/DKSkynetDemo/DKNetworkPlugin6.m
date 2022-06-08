//
//  DKNetworkPlugin6.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKNetworkPlugin6.h"
#import <DKSkynetPlugin.h>

@implementation DKNetworkPlugin6 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"network6";
}

+ (NSString *)pluginName
{
    return @"网络相关6";
}

+ (NSString *)pluginImageName
{
    return @"https://i.loli.net/2019/07/01/5d19cf139e42226929.png";
}

+ (NSString *)superPluginId
{
    return @"network5";
}


@end
