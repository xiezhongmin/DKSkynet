//
//  NSObject+DKRuntime.m
//  DKDebugerExample
//
//  Created by admin on 2020/11/20.
//

#import "NSObject+DKRuntime.h"

@implementation NSObject (DKRuntime)

+ (IMP)dk_instanceImpFromSel:(SEL)aSel
{
    return class_getMethodImplementation(self, aSel);
}

+ (Method)dk_instanceMethodFromSel:(SEL)aSel
{
    return class_getInstanceMethod(self, aSel);
}

+ (Method)dk_classMethodFromSel:(SEL)aSel
{
    return class_getClassMethod(self, aSel);
}

+ (BOOL)dk_swizzleInstanceMethod:(SEL)origSel with:(SEL)newSel
{
    Method origMethod = [self dk_instanceMethodFromSel:origSel];
    Method newMethod = [self dk_instanceMethodFromSel:newSel];;
    if (!origMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

+ (BOOL)dk_swizzleClassMethod:(SEL)origSel with:(SEL)newSel
{
    Class class = object_getClass(self);
    return [class dk_swizzleInstanceMethod:origSel with:newSel];
}

#pragma mark - Associate value -

- (void)dk_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dk_setAssociateValue:(id)value withStringKey:(NSString *)key {
    [self dk_setAssociateValue:value withKey:(__bridge void *)(key)];
}

- (void)dk_setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)dk_setAssociateWeakValue:(id)value withStringKey:(NSString *)key {
    [self dk_setAssociateWeakValue:value withKey:(__bridge void *)key];
}

- (id)dk_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (id)dk_getAssociatedValueForStringKey:(NSString *)key {
    return [self dk_getAssociatedValueForKey:(__bridge void *)key];
}

- (void)dk_removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}


#pragma mark - Others -

+ (NSString *)dk_className {
    return NSStringFromClass(self);
}

- (NSString *)dk_className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

@end
