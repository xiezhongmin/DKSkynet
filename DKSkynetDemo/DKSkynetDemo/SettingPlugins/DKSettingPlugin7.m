//
//  DKSettingPlugin7.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKSettingPlugin7.h"
#import <DKSkynetPlugin.h>

@implementation DKSettingPlugin7 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"setting7";
}

+ (NSString *)pluginName
{
    return @"全部设置7";
}

+ (NSString *)pluginImageName
{
    return @"DKSkynet.bundle/iconfont_setting";
}

+ (NSString *)superPluginId
{
    return @"setting6";
}


@end
