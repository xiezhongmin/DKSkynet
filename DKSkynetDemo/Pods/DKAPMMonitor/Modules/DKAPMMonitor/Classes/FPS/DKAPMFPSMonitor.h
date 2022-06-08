//
//  DKAPMFPSMonitor.h
//  DKAPMMonitor
//
//  Created by admin on 2022/6/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKAPMFPSMonitor : NSObject

+ (instancetype)shared;
- (void)startMonitoring:(void (^)(int fps))block;
- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
