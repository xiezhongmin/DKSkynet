//
//  AppDelegate.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/26.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /// 无侵入方案
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dk_skynet_open" object:nil];

    return YES;
}

@end
