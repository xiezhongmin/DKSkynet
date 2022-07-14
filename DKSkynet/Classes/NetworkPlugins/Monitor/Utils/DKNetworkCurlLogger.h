//
//  DKNetworkCurlLogger.h
//  DKSkynet
//
//  Created by admin on 2022/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKNetworkCurlLogger : NSObject

/**
 * Generates a cURL command equivalent to the given request.
 *
 * @param request The request to be translated
 */
+ (NSString *)curlCommandString:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
