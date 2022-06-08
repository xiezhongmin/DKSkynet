//
//  UIView+YGIBInspectable.h
//  yogo
//
//  Created by duke on 2020/5/13.
//  Copyright © 2020 LuBan. All rights reserved.
//

#import <UIKit/UIKit.h>


// http://nshipster.cn/ibinspectable-ibdesignable/
// Xcode6 新特性，使得下面的属性在 Interface Builder 中也可以展现
@interface UIView (DKIBInspectable)

// 圆角
@property (assign, nonatomic, setter=dk_setCornerRadius:)  CGFloat   dk_cornerRadius;
// 边框宽度
@property (assign, nonatomic, setter=dk_setBorderWidth:)   CGFloat   dk_borderWidth;
// 是否裁剪
@property (assign, nonatomic, setter=dk_setMasksToBounds:) BOOL      dk_masksToBounds;
// 边框颜色
@property (strong, nonatomic, setter=dk_setBorderColor:)   UIColor  *dk_borderColor;

// getter
@property (assign, nonatomic, getter=dk_cornerRadius)  IBInspectable  CGFloat   cornerRadius;
@property (assign, nonatomic, getter=dk_borderWidth)   IBInspectable  CGFloat   borderWidth;
@property (assign, nonatomic, getter=dk_masksToBounds) IBInspectable  BOOL      masksToBounds;
@property (strong, nonatomic, getter=dk_borderColor)   IBInspectable  UIColor  *borderColor;

// 添加圆角 指定位置圆角
- (void)dk_addCornerRadius:(CGFloat)radius
                   corners:(UIRectCorner)corners;

@end

