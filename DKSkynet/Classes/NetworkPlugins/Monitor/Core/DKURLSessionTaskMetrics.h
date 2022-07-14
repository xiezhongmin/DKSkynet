//
//  DKHURLSessionTaskMetrics.h
//  DKSkynet
//
//  Created by admin on 2022/6/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(10.0))
@interface DKURLSessionTaskTransactionMetrics : NSObject

@property (copy) NSURLRequest *request;
@property (nullable, copy) NSURLResponse *response;
@property (nullable, copy) NSDate *fetchStartDate;
@property (nullable, copy) NSDate *domainLookupStartDate;
@property (nullable, copy) NSDate *domainLookupEndDate;
@property (nullable, copy) NSDate *connectStartDate;
@property (nullable, copy) NSDate *secureConnectionStartDate;
@property (nullable, copy) NSDate *secureConnectionEndDate;
@property (nullable, copy) NSDate *connectEndDate;
@property (nullable, copy) NSDate *requestStartDate;
@property (nullable, copy) NSDate *requestEndDate;
@property (nullable, copy) NSDate *responseStartDate;
@property (nullable, copy) NSDate *responseEndDate;
@property (nullable, copy) NSString *networkProtocolName;
@property (assign, getter=isProxyConnection) BOOL proxyConnection;
@property (assign, getter=isReusedConnection) BOOL reusedConnection;
@property (assign) NSURLSessionTaskMetricsResourceFetchType resourceFetchType;

@end

API_AVAILABLE(ios(10.0))
@interface DKURLSessionTaskMetrics : NSObject

@property (copy) NSArray <DKURLSessionTaskTransactionMetrics *> *transactionMetrics;
@property (copy) NSDateInterval *taskInterval;
@property (assign) NSUInteger redirectCount;
@property (strong) NSURLSessionTaskMetrics *urlSessionTaskMetrics;

+ (DKURLSessionTaskMetrics *)metricsFromSystemMetrics:(NSURLSessionTaskMetrics *)urlSessionTaskMetrics;

@end

NS_ASSUME_NONNULL_END
