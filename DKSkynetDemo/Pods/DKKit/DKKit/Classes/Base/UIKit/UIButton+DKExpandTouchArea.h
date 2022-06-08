//
//  UIButton+DKExpandTouchArea.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/29.
//

#import <UIKit/UIKit.h>

#define DK_EXPAND_TOUCH_DEFALUT_SIZE  CGSizeMake(44, 44)

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (DKExpandTouchArea)
/**
 扩大点击区域
 
 Note: 会影响附近按钮的点击响应，使用请小心
 */
@property (nonatomic, assign) CGSize dk_expandTouchSize;

@end

NS_ASSUME_NONNULL_END
