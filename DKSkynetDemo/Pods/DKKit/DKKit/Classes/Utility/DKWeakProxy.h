//
//  DKWeakProxy.h
//  DKKit
//
//  Created by admin on 2022/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 *  @brief  弱引用代理对象
 */
@interface DKWeakProxy : NSProxy

+ (instancetype)proxyWithTarget:(id)target;

- (instancetype)initWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
