//
//  NSArray+DKSafeAccess.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/27.
//

#import <UIKit/UIkit.h>

@interface NSArray (DKSafeAccess)

- (id)dk_safeObjectAtIndex:(NSUInteger)index;

- (NSString *)dk_safeStringAtIndex:(NSUInteger)index;

- (NSNumber *)dk_safeNumberAtIndex:(NSUInteger)index;

- (NSDecimalNumber *)dk_safeDecimalNumberAtIndex:(NSUInteger)index;

- (NSArray *)dk_safeArrayAtIndex:(NSUInteger)index;

- (NSDictionary *)dk_safeDictAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (DKSafeAccess)

- (void)dk_addSafeObject:(id)o;

- (void)dk_insertSafeObject:(id)object atIndex:(NSUInteger)index;

- (void)dk_removeSafeObjectAtIndex:(NSUInteger)index;

@end

