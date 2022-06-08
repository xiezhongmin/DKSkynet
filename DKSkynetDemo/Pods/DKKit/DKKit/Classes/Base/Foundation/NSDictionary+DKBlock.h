//
//  NSDictionary+DKBlock.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/26.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DKBlock)

/**
 *  遍历
 *  当Value遍历的时候，可以返回相应的key, value，添加到字典中返回
 *
 *  @param block 携带key, value的Block
 *
 *  @return NSArray
 */
- (NSArray *)dk_map:(id (^)(id key, id value))block;

/**
 *  过滤字典中数据
 *
 *  @param block  捕获到字典中的key, value给block，block内部将返回的数据进行判断，返回1则该object继续保持在字典
 *
 *  @return NSDictionary
 */
- (NSDictionary *)dk_filter:(BOOL (^)(id key, id value))block;

/**
 *  获取满足条件下的 first item
 *  当Value遍历的时候，可以返回相应的key, value，添加到字典中返回
 *
 *  @param block 携带key, value的Block
 *
 *  @return first item -> NSDictionary
 */
- (NSDictionary *)dk_first:(BOOL (^)(id key, id valu))block;

@end

