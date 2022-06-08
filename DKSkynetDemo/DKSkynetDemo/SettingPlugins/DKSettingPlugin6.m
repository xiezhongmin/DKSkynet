//
//  DKSettingPlugin6.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKSettingPlugin6.h"
#import <DKSkynetPlugin.h>

@implementation DKSettingPlugin6 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"setting6";
}

+ (NSString *)pluginName
{
    return @"全部设置6";
}

+ (NSString *)pluginImageName
{
    return @"DKSkynet.bundle/iconfont_setting";
}

+ (NSString *)superPluginId
{
    return @"setting5";
}


@end
