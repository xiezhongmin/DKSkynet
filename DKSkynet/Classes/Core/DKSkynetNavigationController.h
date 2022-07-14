//
//  DKATNavigationController.h
//  DKSkynet
//
//  Created by admin on 2022/5/26.
//

#import "XFATNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKSkynetNavigationController : XFATNavigationController

/**
 是否自动Window内缩，默认否
 */
@property (nonatomic) BOOL autoIndent;

/**
 使得Window内缩
 */
- (void)indent;

/**
 消失
 */
- (void)dismissWithAnimation:(BOOL)anmiated;

/**
 显示
 */
- (void)showWithAnimation:(BOOL)anmiated;

- (BOOL)windowIsHidden;

@end

NS_ASSUME_NONNULL_END
