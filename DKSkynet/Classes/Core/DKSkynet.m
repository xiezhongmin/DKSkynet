//
//  DKSkynet.m
//  DKSkynet
//
//  Created by admin on 2022/5/26.
//

#import "DKSkynet.h"
#import "DKSkynetAssistiveTouch.h"
#import "DKSkynetModuleModel.h"
#import "DKSkynetPlugin.h"
#import "DKMonitor/DKAPMResourceMonitor.h"
#import "DKMonitor/DKAPMFPSMonitor.h"
#import "DKKit.h"

@interface DKSkynet ()

@end

@implementation DKSkynet

+ (instancetype)shared
{
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

-  (instancetype)init
{
    self = [super init];
    if (self) {
        [[DKSkynetAssistiveTouch shared] install];
    }
    return self;
}

+ (void)registerPlugin:(id <DKSkynetPlugin>)plugin
{
    if (!plugin) { return; }
    
    DKSkynetModuleModel *model = [[DKSkynetModuleModel alloc] init];
    // @required
    model.slf = plugin;
    model.pluginId = [plugin.class pluginId];
    model.pluginName = [plugin.class pluginName];
    model.pluginImageName = [plugin.class pluginImageName];
    if ([plugin respondsToSelector:@selector(pluginDidStart:)]) {
        model.didStart = (void (*)(id, SEL, BOOL *))[plugin.class dk_instanceImpFromSel:@selector(pluginDidStart:)];
    }
    if ([plugin respondsToSelector:@selector(pluginDidStop)]) {
        model.didStop = (void (*)(id, SEL))[plugin.class dk_instanceImpFromSel:@selector(pluginDidStop)];
    }
    
    // @optional
    if ([plugin.class respondsToSelector:@selector(isTop)]) {
        model.isTop = [plugin.class isTop];
    }
    if ([plugin.class respondsToSelector:@selector(superPluginId)]) {
        model.superPluginId = [plugin.class superPluginId];
    }
    if ([plugin.class respondsToSelector:@selector(pluginHighLightName)]) {
        model.pluginHighLightName = [plugin.class pluginHighLightName];
    }
    if ([plugin.class respondsToSelector:@selector(pluginHighLightImageName)]) {
        model.pluginHighLightImageName = [plugin.class pluginHighLightImageName];
    }
    if ([plugin.class respondsToSelector:@selector(prioprity)]) {
        model.prioprity = [plugin.class prioprity];
    }
    [[DKSkynetAssistiveTouch shared] registerPluginWithModel:model];
}

- (void)startServer
{
    [[DKSkynetAssistiveTouch shared] showTouch];
    
    [[DKAPMResourceMonitor shared] startMonitoring:^(double cpuUsage, double memoryUsage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[DKSkynetAssistiveTouch shared] displayCPUUsage:cpuUsage];
            [[DKSkynetAssistiveTouch shared] displayMemoryUsage:memoryUsage];
        });
    }];
    
    [[DKAPMFPSMonitor shared] startMonitoring:^(int fps) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[DKSkynetAssistiveTouch shared] displayFPS:fps];
        });
    }];
}

- (void)stopServer
{
    [[DKSkynetAssistiveTouch shared] dismissTouch];
    [[DKAPMResourceMonitor shared] stopMonitoring];
    [[DKAPMFPSMonitor shared] stopMonitoring];
    [[DKSkynetAssistiveTouch shared] stopAllPlugins];
}


@end
