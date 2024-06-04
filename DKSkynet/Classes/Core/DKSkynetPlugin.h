//
//  DKSkynetPlugin.h
//  DKSkynet
//
//  Created by admin on 2022/5/26.
//

#import <Foundation/Foundation.h>
#import "DKSkynet.h"

/// - Bundle Path
#define DK_SKYNET_BUNDLE_PATH \
[[NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"DKSkynet" ofType:@"bundle"]] bundlePath]\

/// - 自动注册
#define DK_SKYNET_DYNAMIC_REGISTER  \
+ (void)load { [DKSkynet registerPlugin: [[self alloc] init]]; }

@protocol DKSkynetPlugin <NSObject>

@required

/**
 Plugin Identity, should be different with other plugins.
 */
+ (NSString *)pluginId;

/**
 Plugin Name, Display plugin name on assistive button
 */
+ (NSString *)pluginName;

/**
 Plugin ImageName, Display plugin Icon on assistive button, Support local paths and URL
 */
+ (NSString *)pluginImageName; 

@optional

/**
 will triggered when the plugin did start.
 */
- (void)pluginDidStart:(BOOL *)isHightLight;

/**
 will Exit when the plugin did stop
 */
- (void)pluginDidStop;

- (void)pluginDidIndex:(NSInteger)index;

/**
 Whether it is a top-level plugin, default is NO
 */
+ (BOOL)isTop;

/**
 The plugin id of the super plugin, If not implemented or returns nil, it is a top-level plugin

 */
+ (NSString *)superPluginId;

/**
 Plugin HightLight Name, Display plugin HightLight name on assistive button
 */
+ (NSString *)pluginHighLightName;

/**
 Plugin HightLight ImageName, Display plugin HightLight Icon on assistive button, Support local paths and URL
 */
+ (NSString *)pluginHighLightImageName;

/**
 Plugin Prioprity, According to the priority, the order of the plug-ins in the same layer
 */
+ (NSInteger)prioprity;

@end
