//
//  DKSkynetEnvPlugins.m
//  AFNetworking
//
//  Created by duke on 2024/6/3.
//

#import "DKSkynetLookinPlugins.h"
#import <DKSkynetPlugin.h>

/// - Lookin - 2D
@interface DKSkynetLookin2DPlugins: NSObject<DKSkynetPlugin>

@end

@implementation DKSkynetLookin2DPlugins DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"lookin-2d";
}

+ (NSString *)superPluginId
{
    return @"ui";
}

+ (NSString *)pluginName
{
    return @"Lookin2D模式";
}

+ (NSString *)pluginImageName
{
    return @"https://i.loli.net/2019/07/02/5d1ac692a3a4c58277.png";
}

- (void)pluginDidStart:(BOOL *)isHightLight
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
}

- (void)pluginDidStop
{
    
}

@end

/// - Lookin - 3D
@interface DKSkynetLookin3DPlugins: NSObject<DKSkynetPlugin>

@end

@implementation DKSkynetLookin3DPlugins DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"lookin-3d";
}

+ (NSString *)superPluginId
{
    return @"ui";
}

+ (NSString *)pluginName
{
    return @"Lookin3D模式";
}

+ (NSString *)pluginImageName
{
    return @"https://i.loli.net/2019/07/02/5d1ac692a3a4c58277.png";
}

- (void)pluginDidStart:(BOOL *)isHightLight
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
}

- (void)pluginDidStop
{
    
}

@end

/// - Lookin - 导出文档
@interface DKSkynetLookinExportPlugins: NSObject<DKSkynetPlugin>

@end

@implementation DKSkynetLookinExportPlugins DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"lookin-export";
}

+ (NSString *)superPluginId
{
    return @"ui";
}

+ (NSString *)pluginName
{
    return @"Lookin3D导出文档";
}

+ (NSString *)pluginImageName
{
    return @"https://i.loli.net/2019/07/02/5d1ac692a3a4c58277.png";
}

- (void)pluginDidStart:(BOOL *)isHightLight
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
}

- (void)pluginDidStop
{
    
}

@end
