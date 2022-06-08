//
//  NSData+DKEncodeAndDecode.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (DKEncodeAndDecode)

/**
 Returns string decoded in UTF8.
 */
- (nullable NSString *)dk_utf8String;

/**
 Returns a uppercase NSString in HEX.
 */
- (nullable NSString *)dk_hexString;

/**
 Returns an NSData from hex string.
 
 @param hexString   The hex string which is case insensitive.
 
 @return a new NSData, or nil if an error occurs.
 */
+ (nullable NSData *)dk_dataWithHexString:(NSString *)hexString;

/**
 Returns an NSString for base64 encoded.
 */
- (nullable NSString *)dk_base64EncodedString;

/**
 Returns an NSData from base64 encoded string.
 
 @warning This method has been implemented in iOS7.
 
 @param base64EncodedString  The encoded string.
 */
+ (nullable NSData *)dk_dataWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 Returns an NSDictionary or NSArray for decoded self.
 Returns nil if an error occurs.
 */
- (nullable id)dk_jsonValueDecoded;

@end

NS_ASSUME_NONNULL_END
