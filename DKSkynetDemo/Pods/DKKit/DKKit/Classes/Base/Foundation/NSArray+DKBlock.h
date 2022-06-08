//
//  NSArray+DKBlock.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/26.
//

#import <Foundation/Foundation.h>

static NSInteger const kDKArrayErrorIndexValue = -1;

@interface NSArray (DKBlock)

/**
 *  遍历
 *  当Value遍历的时候，可以返回相应的obj，添加到数组中返回
 *
 *  @param block 携带Obj的Block
 *
 *  @return NSArray
 */
- (NSArray *)dk_map:(id (^)(id object))block;

/**
 *  过滤数组中数据
 *
 *  @param block  捕获到数组中的object给block，block内部将返回的数据进行判断，返回1则该object继续保持在数组
 *
 *  @return NSArray
 */
- (NSArray *)dk_filter:(BOOL (^)(id object))block;

/**
 *  循环遍历数组，accumulator为上次遍历的结果，第一次为nil
 *
 *  @param block 计算下次使用的accumlator
 *
 *  @return 返回block的最后一次计算结果
 */
- (id)dk_reduce:(id (^)(id accumulator, id object))block;

/**
 *  循环遍历数组，accumulator为上次遍历的结果，默认为initial
 *
 *  @param initial 第一次计算的初始值
 *  @param block   计算下次使用的accumlator
 *
 *  @return 返回block的最后一次计算结果
 */
- (id)dk_reduce:(id)initial withBlock:(id (^)(id accumulator, id object))block;

/**
 *  获取满足条件下的 first item
 *  当Value遍历的时候，可以返回相应的obj，添加到数组中返回
 *
 *  @param block 携带Obj的Block
 *
 *  @return first item
 */
- (id)dk_first:(BOOL (^)(id object))block;

/**
 *  获取满足条件下的 first index
 *  获取失败返回 -1, 成功返回 Array index
 *  当Value遍历的时候，可以返回相应的obj，添加到数组中返回
 *
 *  @param block 携带Obj的Block
 *
 *  @return first index
 */
- (NSInteger)dk_firstIndex:(BOOL (^)(id object))block;

/**
 *  获取满足条件下的 last item
 *  当Value遍历的时候，可以返回相应的obj，添加到数组中返回
 *
 *  @param block 携带Obj的Block
 *
 *  @return last item
 */
- (id)dk_last:(BOOL (^)(id object))block;

/**
 *  获取满足条件下的 last index
 *  获取失败返回 -1, 成功返回 Array index
 *  当Value遍历的时候，可以返回相应的obj，添加到数组中返回
 *
 *  @param block 携带Obj的Block
 *
 *  @return last index
 */
- (NSInteger)dk_lastIndex:(BOOL (^)(id object))block;

@end

