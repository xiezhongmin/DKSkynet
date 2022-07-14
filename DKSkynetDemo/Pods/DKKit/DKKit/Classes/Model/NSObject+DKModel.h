//
//  NSObject+DKModel.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DKModel)

/**
 *  JSONString -> NSDictionary
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)dk_dictWithJson:(NSString *)json;

/**
 *  NSDictionary -> JSONString
 *
 *  @return JSONString
 */
+ (NSString *)dk_jsonWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
