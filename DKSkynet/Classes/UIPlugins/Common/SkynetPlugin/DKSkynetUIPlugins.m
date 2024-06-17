//
//  DKSkynetNetworkPlugins.m
//  DKSkynet
//
//  Created by admin on 2022/7/5.
//

#import "DKSkynetUIPlugins.h"
#import <DKSkynetPlugin.h>

@interface DKSkynetUIPlugins ()<DKSkynetPlugin>

@end

@implementation DKSkynetUIPlugins DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"ui";
}

+ (NSString *)pluginName
{
    return @"UI相关";
}

+ (NSString *)pluginImageName
{
    return @"https://i.loli.net/2019/07/01/5d19cf482c7d312514.png";
}

+ (BOOL)isTop
{
    return YES;
}

@end
