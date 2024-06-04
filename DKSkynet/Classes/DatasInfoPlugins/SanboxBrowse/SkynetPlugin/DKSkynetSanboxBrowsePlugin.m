//
//  DKSanboxBrowsePlugin.m
//  DKSkynet
//
//  Created by admin on 2022/7/15.
//

#import "DKSkynetSanboxBrowsePlugin.h"
#import <DKSkynetPlugin.h>
#import <DKSkynetAssistiveTouch.h>
#import "DKSanboxBrowseViewController.h"
#import <DKKit/DKKit.h>

@interface DKSkynetSanboxBrowsePlugin ()<DKSkynetPlugin>

@property (nonatomic, weak) DKSanboxBrowseViewController *viewController;

@end

@implementation DKSkynetSanboxBrowsePlugin DK_SKYNET_DYNAMIC_REGISTER

- (void)dealloc
{
    DKLogInfo(@"DKSkynetSanboxBrowsePlugin - dealloc");
}

+ (NSString *)pluginId
{
    return @"sanbox-browse";
}

+ (NSString *)superPluginId
{
    return @"datas-info";
}

+ (NSString *)pluginName
{
    return @"沙盒浏览";
}

+ (NSString *)pluginImageName
{
    return @"https://i.loli.net/2019/07/02/5d1ac692a3a4c58277.png";
}

- (void)pluginDidStart:(BOOL *)isHightLight
{
    if (!_viewController) {
        DKSanboxBrowseViewController *viewController = [[DKSanboxBrowseViewController alloc] init];
        [[DKSkynetAssistiveTouch shared] presentViewController:viewController hasWrapNavigationController:YES animated:YES completion:nil];
        _viewController = viewController;
    } else {
        [_viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)pluginDidStop
{
    if (_viewController) {
        [_viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
