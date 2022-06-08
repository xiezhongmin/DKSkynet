//
//  DKNetworkPlugin9.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKNetworkPlugin9.h"
#import <DKSkynetPlugin.h>

@implementation DKNetworkPlugin9 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"network9";
}

+ (NSString *)pluginName
{
    return @"网络相关9";
}

+ (NSString *)pluginImageName
{
    return @"https://i.loli.net/2019/07/01/5d19cf139e42226929.png";
}

static int count = 0;
- (void)pluginDidStart:(BOOL *)isHightLight
{
    *isHightLight = (count % 2 == 0);
    count++;
    NSLog(@"pluginDidStart9");
}

- (void)pluginDidStop
{
    
}

+ (NSString *)superPluginId
{
    return @"network6";
}

+ (NSString *)pluginHighLightName
{
    return @"网络相关9-已选定";
}

+ (NSString *)pluginHighLightImageName
{
    return @"DKSkynet.bundle/iconfont_userinfo";
}

@end
