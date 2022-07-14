//
//  NSObject+DKSelector.h
//  DKDebugerExample
//
//  Created by admin on 2020/11/23.
//  参考：https://github.com/ibireme/YYKit/blob/master/YYKit/Base/Foundation/NSObject%2BYYAdd.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DKSelector)

- (id)dk_performSelectorWithArgsUseingSelectorName:(NSString *)selectorName, ...;

- (nullable id)dk_performSelectorWithArgs:(SEL)sel, ...;

- (void)dk_performSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ...;

- (nullable id)dk_performSelectorWithArgsOnMainThread:(SEL)sel waitUntilDone:(BOOL)wait, ...;

- (nullable id)dk_performSelectorWithArgs:(SEL)sel onThread:(NSThread *)thread waitUntilDone:(BOOL)wait, ...;

- (void)dk_performSelectorWithArgsInBackground:(SEL)sel, ...;

- (void)dk_performSelector:(SEL)sel afterDelay:(NSTimeInterval)delay;

// MARK: ------------------ NSInvocation NSMethodSignature ------------------

+ (id)dk_getReturnFromInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig;

+ (void)dk_setInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig andArgs:(va_list)args;

@end

NS_ASSUME_NONNULL_END
