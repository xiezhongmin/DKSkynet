//
//  DKSkynetAssistiveTouch.h
//  DKSkynet
//
//  Created by admin on 2022/5/27.
//

#import <Foundation/Foundation.h>
#import "DKSkynetModuleModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface DKSkynetAssistiveTouch : NSObject

@property (nonatomic, strong, readonly) NSMutableArray <DKSkynetModuleModel *>*plugins;

+ (instancetype)shared;

- (void)install;

- (void)registerPluginWithModel:(DKSkynetModuleModel *)model;

- (void)stopPluginWithModel:(DKSkynetModuleModel *)model;

- (void)stopAllPlugins;

- (void)showTouch;

- (void)dismissTouch;

- (void)refreshAllModuleState;

- (void)presentViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^ __nullable)(void))completion;

- (void)presentViewController:(UIViewController *)viewController
  hasWrapNavigationController:(BOOL)hasWrapNavigationController
                     animated:(BOOL)animated
                   completion:(void (^ __nullable)(void))completion;

// MARK: display -

- (void)displayCPUUsage:(double)usage;

- (void)displayMemoryUsage:(double)usage;

- (void)displayFPS:(int)fps;

@end

NS_ASSUME_NONNULL_END
