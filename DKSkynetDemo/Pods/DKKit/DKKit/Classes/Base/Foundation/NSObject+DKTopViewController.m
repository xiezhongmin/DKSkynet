//
//  NSObject+Route.m
//  yogo
//
//  Created by admin on 2020/6/2.
//  Copyright © 2020 LuBan. All rights reserved.
//

#import "NSObject+DKTopViewController.h"

@implementation NSObject (DKTopViewController)

- (UIViewController *)dk_topViewController
{
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (viewController) {
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tbvc = (UITabBarController *)viewController;
            viewController = tbvc.selectedViewController;
            continue;
        }
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nvc = (UINavigationController *)viewController;
            viewController = nvc.topViewController;
            continue;
        }
        if (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
            continue;
        }
        if ([viewController isKindOfClass:[UISplitViewController class]] &&
            ((UISplitViewController  *)viewController).viewControllers.count > 0) {
            UISplitViewController *svc = (UISplitViewController  *)viewController;
            viewController = svc.viewControllers.lastObject;
            continue;
        }
        return viewController;
    }
    return viewController;
}

@end
