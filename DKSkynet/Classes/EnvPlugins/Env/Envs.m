//
//  Envs.m
//  DKSkynet
//
//  Created by duke on 2024/6/3.
//

#import "Envs.h"
#import "DKKit/DKKitMacro.h"
#import <DKSkynetAssistiveTouch.h>

@implementation Envs

static UIAlertController *_alert = nil;

+ (BOOL)isShow {
    return _alert != nil;
}

+ (void)showSwitchEnvs {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"环境切换" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    NSDictionary *envPlist = [self envPlistDict];
    
    @weakify(self)
    [envPlist enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *value, BOOL * _Nonnull stop) {
        @strongify(self)
        BOOL isSelected = value.intValue == [self currentEnv];
        [alert addAction:[UIAlertAction actionWithTitle:key style: isSelected ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [[NSNotificationCenter defaultCenter] postNotificationName:kDKEnvSwitchNotification object:value];
            [self saveCrruntEnv:value.intValue];
            exit(0);
        }]];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [[DKSkynetAssistiveTouch shared] presentViewController:alert hasWrapNavigationController:NO animated:YES completion:^{
        _alert = nil;
    }];
    
    _alert = alert;
}

+ (void)dissmis {
    [_alert dismissViewControllerAnimated:true completion:nil];
    _alert = nil;
}

+ (int)currentEnv {
    NSNumber *currentEnv = [[NSUserDefaults standardUserDefaults] objectForKey:DK_ENV_PLUGINS_KEY];
    return currentEnv.intValue;
}

/// - private

+ (NSDictionary *)envPlistDict {
    static NSDictionary *envPlist = nil;
    if (envPlist == nil) {
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"Envs" ofType:@"bundle"]];
        NSString *bundlePath = [bundle bundlePath];
        NSBundle *envBundle = [NSBundle bundleWithPath:bundlePath];
        NSString *filePath = [envBundle pathForResource:@"Envs" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        envPlist = dict;
    }
    return envPlist;
}

+ (void)saveCrruntEnv:(int)crruntEnv {
    [[NSUserDefaults standardUserDefaults] setValue:@(crruntEnv) forKey:DK_ENV_PLUGINS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
