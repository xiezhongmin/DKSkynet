//
//  DKSettingPlugin1.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKSettingPlugin1.h"
#import <DKSkynetPlugin.h>

@implementation DKSettingPlugin1 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"setting";
}

+ (NSString *)pluginName
{
    return @"全部设置";
}

+ (NSString *)pluginImageName
{
    return @"DKSkynet.bundle/iconfont_setting";
}

+ (BOOL)isTop
{
    return YES;
}

@end
