//
//  DKNetworkPlugin7.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKNetworkPlugin7.h"
#import <DKSkynetPlugin.h>

@implementation DKNetworkPlugin7 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"network7";
}

+ (NSString *)pluginName
{
    return @"网络相关7";
}

+ (NSString *)pluginImageName
{
    return @"https://i.loli.net/2019/07/01/5d19cf139e42226929.png";
}

- (void)pluginDidStart:(BOOL *)isHightLight
{
    NSLog(@"pluginDidStart7");
}

- (void)pluginDidStop
{
    
}

+ (NSString *)superPluginId
{
    return @"network6";
}


@end
