//
//  UIControl+DKThrottle.m
//  DKDebugerExample
//
//  Created by admin on 2021/10/29.
//

#import "UIControl+DKThrottle.h"
#import "DKKitMacro.h"
#import <objc/runtime.h>

@interface UIControl ()

@property (nonatomic, assign) NSTimeInterval dk_clickLastTime;

@end


@implementation UIControl (DKThrottle)

+ (void)load
{
    if (DK_IOS9_OR_LATER) {
        Method before = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
        Method after  = class_getInstanceMethod(self, @selector(dk_sendAction:to:forEvent:));
        method_exchangeImplementations(before, after);
    }
}

- (void)dk_sendAction:(SEL)action
                   to:(id)target
             forEvent:(UIEvent *)event
{
    if (self.dk_clickInterval <= 0) {
        [self dk_sendAction:action to:target forEvent:event];
        return;
    }
    
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    BOOL shouldSendAction = now - self.dk_clickLastTime > self.dk_clickInterval;
    self.dk_clickLastTime = now;
    if (!shouldSendAction) {
        return;
    }
    [self dk_sendAction:action to:target forEvent:event];
}

- (NSTimeInterval)dk_clickInterval
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setDk_clickInterval:(NSTimeInterval)dk_clickInterval
{
    objc_setAssociatedObject(self, @selector(dk_clickInterval), @(dk_clickInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (NSTimeInterval)dk_clickLastTime
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setDk_clickLastTime:(NSTimeInterval)dk_clickLastTime
{
    objc_setAssociatedObject(self, @selector(dk_clickLastTime), @(dk_clickLastTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
