//
//  DKSkynetUtility.h
//  DKSkynet
//
//  Created by admin on 2022/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKSkynetUtility : NSObject

+ (NSString *)stringByEscapingHTMLEntitiesInString:(NSString *)originalString;

+ (BOOL)isValidJSONData:(NSData *)data;

+ (NSString *)prettyJSONStringFromData:(NSData *)data;

+ (NSTimeInterval)appLaunchedTime;

@end

NS_ASSUME_NONNULL_END
