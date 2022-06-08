//
//  DKNetworkPlugin1.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKNetworkPlugin1.h"
#import <DKSkynetPlugin.h>

@implementation DKNetworkPlugin1 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"network";
}

+ (NSString *)pluginName
{
    return @"网络相关";
}

+ (NSString *)pluginImageName
{
    return @"https://i.loli.net/2019/07/01/5d19cf139e42226929.png";
}

+ (BOOL)isTop
{
    return YES;
}


@end
