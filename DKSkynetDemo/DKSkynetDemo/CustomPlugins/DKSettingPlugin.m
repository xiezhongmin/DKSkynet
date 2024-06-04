//
//  DKSettingPlugin1.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/30.
//

#import "DKSettingPlugin.h"
#import <DKSkynetPlugin.h>
#import <DKKit/DKKit.h>
#import "SettingViewController.h"
#import <XFAssistiveTouch.h>
#import <DKSkynetAssistiveTouch.h>

@interface DKSettingPlugin () <DKSkynetPlugin>
@property (nonatomic, weak) SettingViewController *viewController;
@end

@implementation DKSettingPlugin DK_SKYNET_DYNAMIC_REGISTER

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
    return [NSString stringWithFormat:@"%@/skynet_setting", DK_SKYNET_BUNDLE_PATH];
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

- (void)pluginDidStop
{
    if (_viewController) {
        [_viewController dismissViewControllerAnimated:YES completion:nil];
    }
    NSLog(@"全部设置 - pluginDidStop");
}

@end
