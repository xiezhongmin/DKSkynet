//
//  NSObject+DKRuntime.h
//  DKDebugerExample
//
//  Created by admin on 2020/11/20.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (DKRuntime)

#pragma mark - Runtime 基本方法 -

/**
 *  获取类方法的 Method
 *
 *  @param aSel aSel
 *
 *  @return aSel 的 Method
 */
+ (Method)dk_classMethodFromSel:(SEL)aSel;

/**
 *  获取实例方法的 Method
 *
 *  @param aSel aSel
 *
 *  @return aSel 的 Method
 */
+ (Method)dk_instanceMethodFromSel:(SEL)aSel;

/**
 *  获取实例方法的 IMP
 *
 *  @param aSel aSel
 *
 *  @return aSel 的 IMP
 */
+ (IMP)dk_instanceImpFromSel:(SEL)aSel;


#pragma mark - Swizzle Method -
/**
 *  实例方法交换
 *
 *  @param origSel     oldMethod
 *  @param newSel      newMethod
 *
 *  @return 是否交换成功
 */
+ (BOOL)dk_swizzleInstanceMethod:(SEL)origSel with:(SEL)newSel;

/**
 *  类方法交换
 *
 *  @param origSel     oldMethod
 *  @param newSel      newMethod
 *
 *  @return 是否 交换成功
 */
+ (BOOL)dk_swizzleClassMethod:(SEL)origSel with:(SEL)newSel;


#pragma mark - Associate value -
/**
 *  设置强引用类型关联
 *
 *  @param value 值
 *  @param key   key
 */
- (void)dk_setAssociateValue:(id)value withKey:(void *)key;
- (void)dk_setAssociateValue:(id)value withStringKey:(NSString *)key;


/**
 *  设置弱引用类型的关联
 *
 *  @param value 值
 *  @param key   key
 */
- (void)dk_setAssociateWeakValue:(id)value withKey:(void *)key;
- (void)dk_setAssociateWeakValue:(id)value withStringKey:(NSString *)key;

/**
 *  通过key获取关联的对象内容
 *
 *  @param  key 存储时使用的key
 *
 *  @return self中关联到key的值
 */
- (id)dk_getAssociatedValueForKey:(void *)key;
- (id)dk_getAssociatedValueForStringKey:(NSString *)key;


/**
 *  移除所有self的关联内容
 */
- (void)dk_removeAssociatedValues;


#pragma mark - Others -

+ (NSString *)dk_className;

- (NSString *)dk_className;

@end

