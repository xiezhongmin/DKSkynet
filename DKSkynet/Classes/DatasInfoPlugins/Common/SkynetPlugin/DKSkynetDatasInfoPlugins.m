//
//  DKSkynetDatasInfoPlugins.m
//  DKSkynet
//
//  Created by admin on 2022/7/15.
//

#import "DKSkynetDatasInfoPlugins.h"
#import <DKSkynetPlugin.h>

@implementation DKSkynetDatasInfoPlugins DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"datas-info";
}

+ (NSString *)pluginName
{
    return @"数据相关";
}

+ (NSString *)pluginImageName
{
    return @"https://i.loli.net/2019/07/01/5d19ceb93c44987655.png";
}

+ (BOOL)isTop
{
    return YES;
}

@end
