//
//  DKSettingPlugin1.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKSettingPlugin1.h"
#import <DKSkynetPlugin.h>
#import <DKKit/DKKit.h>
#import "SettingViewController.h"
#import <XFAssistiveTouch.h>
#import <DKSkynetAssistiveTouch.h>

@interface DKSettingPlugin1 ()
@property (nonatomic, weak) SettingViewController *viewController;
@end

@implementation DKSettingPlugin1 DK_SKYNET_DYNAMIC_REGISTER

+ (NSString *)pluginId
{
    return @"setting";
}

+ (NSString *)pluginName
{
    return @"全部设置";
}

+ (NSString *)pluginImageName
{
    return @"DKSkynet.bundle/skynet_setting";
}

+ (BOOL)isTop
{
    return YES;
}

- (void)pluginDidStart:(BOOL *)isHightLight
{
    if (!_viewController) {
        SettingViewController *viewController = [[SettingViewController alloc] init];
        [[DKSkynetAssistiveTouch shared] presentViewController:viewController hasWrapNavigationController:YES animated:YES completion:nil];
        _viewController = viewController;
    } else {
        [_viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
