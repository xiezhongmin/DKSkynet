//
//  DKSettingPlugin5.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKSettingPlugin5.h"
#import <DKSkynetPlugin.h>

@implementation DKSettingPlugin5 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"setting5";
}

+ (NSString *)pluginName
{
    return @"全部设置5";
}

+ (NSString *)pluginImageName
{
    return @"DKSkynet.bundle/iconfont_setting";
}

+ (NSString *)superPluginId
{
    return @"setting4";
}


@end
