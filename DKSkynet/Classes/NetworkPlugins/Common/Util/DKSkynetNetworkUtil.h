//
//  DKSkynetNetworkUtil.h
//  DKSkynet
//
//  Created by admin on 2022/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKSkynetNetworkUtil : NSObject

+ (NSString *)statusCodeStringFromURLResponse:(NSURLResponse *)response;
+ (NSString *)stringFromRequestDuration:(NSTimeInterval)duration;
+ (NSData *)inflatedDataFromCompressedData:(NSData *)compressedData;

@end

NS_ASSUME_NONNULL_END
