//
//  DKSettingPlugin3.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKSettingPlugin3.h"
#import <DKSkynetPlugin.h>

@implementation DKSettingPlugin3 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"setting3";
}

+ (NSString *)pluginName
{
    return @"全部设置3";
}

+ (NSString *)pluginImageName
{
    return @"DKSkynet.bundle/iconfont_setting";
}

+ (NSString *)superPluginId
{
    return @"setting2";
}

@end
