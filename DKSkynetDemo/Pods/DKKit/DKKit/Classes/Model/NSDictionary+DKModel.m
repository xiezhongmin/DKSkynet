//
//  NSDictionary+DKModel.m
//  DKDebugerExample
//
//  Created by admin on 2021/10/26.
//

#import "NSDictionary+DKModel.h"
#import "DKKitMacro.h"

@implementation NSDictionary (DKModel)

- (NSString *)dk_jsonString
{
    NSString *result = nil;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (error) {
        DKLog(@"JSON Parse Error-----%@", error);
    }
    
    if ([data length] > 0) {
        result = [[NSString alloc] initWithBytes:[data bytes]
                                          length:[data length]
                                        encoding:NSUTF8StringEncoding];
    }
    return result;
}

@end
