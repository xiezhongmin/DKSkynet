//
//  DKSettingPlugin2.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKSettingPlugin2.h"
#import <DKSkynetPlugin.h>

@implementation DKSettingPlugin2 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"setting2";
}

+ (NSString *)pluginName
{
    return @"全部设置2";
}

+ (NSString *)pluginImageName
{
    return @"DKSkynet.bundle/iconfont_setting";
}

+ (NSString *)superPluginId
{
    return @"setting";
}

@end