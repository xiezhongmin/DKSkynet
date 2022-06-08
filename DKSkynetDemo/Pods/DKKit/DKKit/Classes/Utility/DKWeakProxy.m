//
//  DKWeakProxy.m
//  DKKit
//
//  Created by admin on 2022/4/26.
//

#import "DKWeakProxy.h"

/*!
 *  @brief  弱引用代理转发异常处理类
 */
@interface _DKWeakProxyFailure : NSObject

@end

@implementation _DKWeakProxyFailure

+ (void)forwardFailure:(id)target selector:(SEL)aSelector
{
    if (!target) {
        @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithFormat: @"[%@] ERROR: @selector(%@) forward failure: target is nil", [self class], NSStringFromSelector(aSelector)] userInfo: nil];
    }
    else if (![target respondsToSelector:aSelector]) {
        @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithFormat: @"[%@] ERROR: @selector(%@) forward failure [%@ %@]: unrecognized selector sent to instance %p", [self class], NSStringFromClass([target class]), NSStringFromSelector(aSelector), NSStringFromSelector(aSelector), target] userInfo: nil];
    }
    else {
        @throw [NSException exceptionWithName: NSInvalidArgumentException reason: [NSString stringWithFormat: @"[%@] ERROR: @selector(%@) forward failure", [self class], NSStringFromSelector(aSelector)] userInfo: nil];
    }
}

@end


/*!
 *  @brief  弱引用代理对象
 */
@interface DKWeakProxy ()

@property (nonatomic, weak) id target;

@end

@implementation DKWeakProxy

#pragma mark - Public -

+ (instancetype)proxyWithTarget:(id)target
{
    return [[self alloc] initWithTarget:target];
}

- (instancetype)initWithTarget:(id)target
{
    self.target = target;
    return self;
}

#pragma mark - method transmit -

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL orginSel = anInvocation.selector;
    [anInvocation setTarget:_DKWeakProxyFailure.class];
    [anInvocation setSelector:@selector(forwardFailure:selector:)];
    [anInvocation setArgument:&_target atIndex:2];
    [anInvocation setArgument:&orginSel atIndex:3];
    [anInvocation invoke];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [_DKWeakProxyFailure methodSignatureForSelector:@selector(forwardFailure:selector:)];
}

#pragma mark - judge -

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [_target respondsToSelector:aSelector];
}

- (BOOL)isEqual:(id)object
{
    return [_target isEqual:object];
}

- (NSUInteger)hash
{
    return [_target hash];
}

- (Class)superclass
{
    return [_target superclass];
}

- (Class)class
{
    return [_target class];
}

- (BOOL)isKindOfClass:(Class)aClass
{
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass
{
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy
{
    return YES;
}

- (NSString *)description
{
    return [_target description];
}

- (NSString *)debugDescription
{
    return [_target debugDescription];
}

@end
