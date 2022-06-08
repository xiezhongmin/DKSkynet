//
//  UIControl+DKThrottle.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (DKThrottle)

@property (nonatomic, assign) NSTimeInterval dk_clickInterval; // 点击的间隔

@end

NS_ASSUME_NONNULL_END
