//
//  DKSettingPlugin8.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKSettingPlugin8.h"
#import <DKSkynetPlugin.h>

@implementation DKSettingPlugin8 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"setting8";
}

+ (NSString *)pluginName
{
    return @"全部设置8";
}

+ (NSString *)pluginImageName
{
    return @"DKSkynet.bundle/iconfont_setting";
}

- (void)pluginDidStart:(BOOL *)isHightLight
{
    NSLog(@"pluginDidStart8");
}

- (void)pluginDidStop
{
    
}

+ (NSString *)superPluginId
{
    return @"setting7";
}


@end
