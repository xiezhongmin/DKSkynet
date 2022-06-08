//
//  NSString+DKEncodeAndDecode.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DKEncodeAndDecode)

/**
 Returns an NSString for base64 encoded.
 */
- (nullable NSString *)dk_base64EncodedString;

/**
 Returns an NSString from base64 encoded string.
 @param base64EncodedString The encoded string.
 */
+ (nullable NSString *)dk_stringWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 URL encode a string in utf-8.
 @return the encoded string.
 */
- (NSString *)dk_stringByURLEncode;

/**
 URL decode a string in utf-8.
 @return the decoded string.
 */
- (NSString *)dk_stringByURLDecode;

/**
 Escape common HTML to Entity.
 Example: "a < b" will be escape to "a&lt;b".
 */
- (NSString *)dk_stringByEscapingHTML;

@end

NS_ASSUME_NONNULL_END
