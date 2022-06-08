//
//  DKSettingPlugin4.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKSettingPlugin4.h"
#import <DKSkynetPlugin.h>

@implementation DKSettingPlugin4 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"setting4";
}

+ (NSString *)pluginName
{
    return @"全部设置4";
}

+ (NSString *)pluginImageName
{
    return @"DKSkynet.bundle/iconfont_setting";
}

+ (NSString *)superPluginId
{
    return @"setting3";
}


@end
