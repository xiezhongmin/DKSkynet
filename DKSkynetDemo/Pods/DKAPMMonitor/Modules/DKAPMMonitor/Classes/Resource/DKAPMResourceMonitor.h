//
//  DKAPMResourceMonitor.h
//  DKAPMMonitor
//
//  Created by admin on 2022/6/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKAPMResourceMonitor : NSObject

+ (instancetype)shared;
- (void)startMonitoring:(void (^)(double cpuUsage, double memoryUsage))block;
- (void)startMonitoring:(NSTimeInterval)timeInterval
                  block:(void (^)(double cpuUsage, double memoryUsage))block;
- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
