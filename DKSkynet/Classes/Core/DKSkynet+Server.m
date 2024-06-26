//
//  NSObject+DKSkynetServer.m
//  DKSkynet
//
//  Created by duke on 2024/6/26.
//

#import "DKSkynet.h"

@implementation DKSkynet (Server)

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserverForName:DK_SKYNET_OPEN  object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notification) {
        [[DKSkynet shared] startServer];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:DK_SKYNET_STOP  object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notification) {
        [[DKSkynet shared] stopServer];
    }];
}

@end
