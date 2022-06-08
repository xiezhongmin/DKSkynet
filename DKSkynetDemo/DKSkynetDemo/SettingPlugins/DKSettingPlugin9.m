//
//  DKSettingPlugin9.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKSettingPlugin9.h"
#import <DKSkynetPlugin.h>

@implementation DKSettingPlugin9 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"setting9";
}

+ (NSString *)pluginName
{
    return @"全部设置9";
}

+ (NSString *)pluginImageName
{
    return @"DKSkynet.bundle/iconfont_setting";
}

- (void)pluginDidStart:(BOOL *)isHightLight
{
    NSLog(@"pluginDidStart9");
}

- (void)pluginDidStop
{
    
}

+ (NSString *)superPluginId
{
    return @"setting7";
}


@end
