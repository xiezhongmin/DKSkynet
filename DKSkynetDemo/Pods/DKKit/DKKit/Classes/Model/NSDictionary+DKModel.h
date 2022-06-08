//
//  NSDictionary+DKModel.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/26.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DKModel)

/**
 *  Dictionary -> JSONString
 *
 *  @return JSONString
 */
- (NSString *)dk_jsonString;

@end

