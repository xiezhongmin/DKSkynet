//
//  NSArray+DKSafeAccess.m
//  DKDebugerExample
//
//  Created by admin on 2021/10/27.
//

#import "NSArray+DKSafeAccess.h"

@implementation NSArray (DKSafeAccess)

- (id)dk_safeObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return self[index];
    } else {
        return nil;
    }
}

- (NSString *)dk_safeStringAtIndex:(NSUInteger)index
{
    id value = [self dk_safeObjectAtIndex:index];
    if (value == nil || value == [NSNull null] || [[value description] isEqualToString:@"<null>"])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}

- (NSNumber *)dk_safeNumberAtIndex:(NSUInteger)index
{
    id value = [self dk_safeObjectAtIndex:index];
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString *)value];
    }
    
    return nil;
}

- (NSDecimalNumber *)dk_safeDecimalNumberAtIndex:(NSUInteger)index
{
    id value = [self dk_safeObjectAtIndex:index];
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    
    return nil;
}

- (NSArray *)dk_safeArrayAtIndex:(NSUInteger)index
{
    id value = [self dk_safeObjectAtIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    
    return nil;
}

- (NSDictionary *)dk_safeDictAtIndex:(NSUInteger)index
{
    id value = [self dk_safeObjectAtIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    
    return nil;
}

@end


@implementation NSMutableArray (DKSafeAccess)

- (void)dk_addSafeObject:(id)o
{
    if (o != nil) {
        [self addObject:o];
    }
}

- (void)dk_removeSafeObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

- (void)dk_insertSafeObject:(id)object atIndex:(NSUInteger)index
{
    if (object) {
        if (self.count < index) {
            [self addObject:object];
        }
        else {
            [self insertObject:object atIndex:index];
        }
    }
}


@end
