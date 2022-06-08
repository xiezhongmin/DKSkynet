//
//  NSString+DKModel.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/26.
//

#import <Foundation/Foundation.h>

@interface NSString (DKModel)

/**
 *  JSONString -> id
 *
 *  @return id
 */
- (id)dk_jsonValue;

@end

