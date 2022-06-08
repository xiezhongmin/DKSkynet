//
//  UIButton+DKExpandTouchArea.m
//  DKDebugerExample
//
//  Created by admin on 2021/10/29.
//

#import "UIButton+DKExpandTouchArea.h"
#import "NSObject+DKRuntime.h"

@implementation UIButton (DKExpandTouchArea)

+ (void)load
{
    [self dk_swizzleInstanceMethod:@selector(pointInside:withEvent:) with:@selector(dk_pointInside:withEvent:)];
}

- (CGSize)dk_expandTouchSize
{
    id value = [self dk_getAssociatedValueForKey:_cmd];
    if (value && [value isKindOfClass:[NSValue class]]) {
        return [(NSValue *)value CGSizeValue];
    } else {
        return CGSizeZero;
    }
}

- (void)setDk_expandTouchSize:(CGSize)dk_expandTouchSize
{
    if (!CGSizeEqualToSize(dk_expandTouchSize, CGSizeZero)) {
        [self dk_setAssociateValue:[NSValue valueWithCGSize:dk_expandTouchSize] withKey:@selector(dk_expandTouchSize)];
    }
}

- (BOOL)dk_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGSize dk_expandTouchSize = [self dk_expandTouchSize];
    if (CGSizeEqualToSize(dk_expandTouchSize, CGSizeZero)) {
        return [self dk_pointInside:point withEvent:event];
    } else {
        CGRect bounds = self.bounds;
        CGFloat widthDelta = MAX(dk_expandTouchSize.width - bounds.size.width, 0);
        CGFloat heightDelta = MAX(dk_expandTouchSize.height - bounds.size.height, 0);
        bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
        return CGRectContainsPoint(bounds, point);
    }
}

@end
