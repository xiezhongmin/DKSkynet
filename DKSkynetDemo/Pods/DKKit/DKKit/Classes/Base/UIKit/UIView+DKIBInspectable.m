//
//  UIView+YGIBInspectable.m
//  yogo
//
//  Created by duke on 2020/5/13.
//  Copyright © 2020 LuBan. All rights reserved.
//

#import "UIView+DKIBInspectable.h"

@implementation UIView (DKIBInspectable)

- (void)dk_setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)dk_cornerRadius {
    return self.layer.cornerRadius;
}

- (void)dk_setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)dk_borderWidth {
    return self.layer.borderWidth;
}

- (void)dk_setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)dk_borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
- (void)dk_setMasksToBounds:(BOOL)bounds {
    self.layer.masksToBounds = bounds;
}

- (BOOL)dk_masksToBounds {
    return self.layer.masksToBounds;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.dk_cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.dk_borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.dk_borderColor = borderColor;
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
    self.dk_masksToBounds = masksToBounds;
}

// 添加圆角 指定位置圆角
- (void)dk_addCornerRadius:(CGFloat)radius
                   corners:(UIRectCorner)corners
{
    UIBezierPath *maskPath = [UIBezierPath  bezierPathWithRoundedRect:self.bounds
                                                    byRoundingCorners:corners
                                                          cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = self.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}

@end
