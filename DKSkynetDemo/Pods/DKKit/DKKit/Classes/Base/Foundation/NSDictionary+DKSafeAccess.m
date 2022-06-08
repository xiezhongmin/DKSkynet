//
//  NSDictionary+DKSafeAccess.m
//  DKDebugerExample
//
//  Created by admin on 2021/10/27.
//

#import "NSDictionary+DKSafeAccess.h"

@implementation NSDictionary (DKSafeAccess)

- (NSString *)dk_safeStringForKey:(id)key
{
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
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

- (NSNumber *)dk_safeNumberForKey:(id)key
{
    id value = [self objectForKey:key];
    
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

- (NSDecimalNumber *)dk_safeDecimalNumberForKey:(id)key
{
    id value = [self objectForKey:key];
    
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

- (NSArray *)dk_safeArrayForKey:(id)key
{
    id value = [self objectForKey:key];
    
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

- (NSDictionary *)dk_safeDictForKey:(id)key
{
    id value = [self objectForKey:key];
    
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


@implementation NSMutableDictionary (DKSafeAccess)

- (void)dk_setSafeValue:(id)value forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [self setValue:value forKey:key];
}

- (void)dk_setSafeObject:(id)object forKey:(id<NSCopying>)key
{
    if (!key) {
        return;
    }
    
    if (!object) {
        [self removeObjectForKey:key];
    } else {
        [self setObject:object forKey:key];
    }
}

@end
