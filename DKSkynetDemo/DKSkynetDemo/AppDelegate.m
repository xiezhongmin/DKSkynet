//
//  AppDelegate.m
//  DKSkynetDemo
//
//  Created by admin on 2022/5/26.
//

#import "AppDelegate.h"
#import <DKSkynet.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[DKSkynet shared] startServer];

    return YES;
}

@end
