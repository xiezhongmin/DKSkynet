//
//  NSDictionary+DKBlock.m
//  DKDebugerExample
//
//  Created by admin on 2021/10/26.
//

#import "NSDictionary+DKBlock.h"

@implementation NSDictionary (DKBlock)

/**
 *  遍历
 *  当Value遍历的时候，可以返回相应的key, value，添加到数组中返回
 *
 *  @param block 携带key, value的Block
 *
 *  @return NSArray
 */
- (NSArray *)dk_map:(id (^)(id key, id value))block
{
    if (!block) return nil;

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.allKeys.count];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id object = block(key, obj);
        if (object) {
            [array addObject:object];
        }
    }];
    
    return array;
}

/**
 *  过滤字典中数据
 *
 *  @param block  捕获到字典中的key, value给block，block内部将返回的数据进行判断，返回1则该object继续保持在数组
 *
 *  @return NSDictionary
 */
- (NSDictionary *)dk_filter:(BOOL (^)(id key, id value))block
{
    if (!block) return nil;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key, obj)) {
            dict[key] = obj;
        }
    }];
    
    return dict;
}

/**
 *  获取满足条件下的 first item
 *  当Value遍历的时候，可以返回相应的key, value，添加到字典中返回
 *
 *  @param block 携带key, value的Block
 *
 *  @return first item -> NSDictionary
 */
- (NSDictionary *)dk_first:(BOOL (^)(id key, id valu))block
{
    if (!block) return nil;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];

    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key, obj)) {
            dict[key] = obj;
            *stop = YES;
        }
    }];

    return dict.count ? dict : nil;
}

@end
