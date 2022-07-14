//
//  NSObject+DKModel.m
//  DKDebugerExample
//
//  Created by admin on 2021/10/26.
//

#import "NSObject+DKModel.h"
#import "DKKitMacro.h"

@implementation NSObject (DKModel)

+ (NSDictionary *)dk_dictWithJson:(NSString *)json
{
    if ([json isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)json;
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    if (error) {
        DKLogError(@"JSON to Dict Error-----%@", error);
    }
    return resultDic;
}

+ (NSString *)dk_jsonWithDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSString class]]) {
        return (NSString *)dict;
    }
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (error) {
        DKLogError(@"JSON Parse Error-----%@", error);
    }
    return json;
}

@end
