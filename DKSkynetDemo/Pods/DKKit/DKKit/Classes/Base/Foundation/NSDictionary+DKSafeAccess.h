//
//  NSDictionary+DKSafeAccess.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/27.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DKSafeAccess)

- (NSString *)dk_safeStringForKey:(id)key;

- (NSNumber *)dk_safeNumberForKey:(id)key;

- (NSDecimalNumber *)dk_safeDecimalNumberForKey:(id)key;

- (NSArray *)dk_safeArrayForKey:(id)key;

- (NSDictionary *)dk_safeDictForKey:(id)key;

@end


@interface NSMutableDictionary (DKSafeAccess)

- (void)dk_setSafeValue:(id)value forKey:(NSString *)key;

- (void)dk_setSafeObject:(id)object forKey:(id<NSCopying>)key;

@end
