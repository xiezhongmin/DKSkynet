//
//  NSString+DKModel.m
//  DKDebugerExample
//
//  Created by admin on 2021/10/26.
//

#import "NSString+DKModel.h"
#import "DKKitMacro.h"

@implementation NSString (DKModel)

/**
 *  JSONString -> id
 *
 *  @return id
 */
- (id)dk_jsonValue
{
    NSError *error = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id result = nil;
    if ([data length] > 0) {
        result = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
    }
    else {
        result = nil;
    }
    
    if (error) {
        DKLog(@"JSON Parse Error-----%@", error);
    }
    
    return result;
}

@end
