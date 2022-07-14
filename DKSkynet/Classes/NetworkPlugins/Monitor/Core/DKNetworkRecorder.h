//
//  DKNetworkRecorder.h
//  DKSkynet
//
//  Created by admin on 2022/6/15.
//

#import <Foundation/Foundation.h>
#import "DKNetworkTransaction.h"

@protocol DKNetworkRecorderDelegate <NSObject>

@optional
- (void)recorderTransactionUpdated:(DKNetworkTransaction *)transaction currentState:(DKNetworkTransactionState)state;
- (void)recorderNewTransaction:(DKNetworkTransaction *)transaction;

@end

@interface DKNetworkRecorder : NSObject

@property (nonatomic, strong) NSMutableArray <NSString *> *hostBlacklist;

/// In general, it only makes sense to have one recorder for the entire application.
+ (instancetype)defaultRecorder;

// MARK: - delegate
- (void)addDelegate:(id <DKNetworkRecorderDelegate>)delegate;
- (void)removeDelegate:(id <DKNetworkRecorderDelegate>)delegate;
- (NSArray <id <DKNetworkRecorderDelegate>> *)allDelegates;

/// Call when app is about to send HTTP request.
- (void)recordRequestWillBeSentWithRequestId:(NSString *)requestId
                                     request:(NSURLRequest *)request
                            redirectResponse:(NSURLResponse *)redirectResponse;

/// Call when HTTP response is available.
- (void)recordResponseReceivedWithRequestId:(NSString *)requestId response:(NSURLResponse *)response;

/// Call when data chunk is received over the network.
- (void)recordDataReceivedWithRequestId:(NSString *)requestId dataLength:(int64_t)dataLength;

/// Call when HTTP request has finished loading.
- (void)recordLoadingFinishedWithRequestId:(NSString *)requestId responseBody:(NSData *)responseBody;

/// Call when HTTP request has failed to load.
- (void)recordLoadingFailedWithRequestId:(NSString *)requestId error:(NSError *)error;

/// NSURLSessionTaskMetrics 相关:
/// 封装会话任务度量的对象
/// 每个 NSURLSessionTaskMetrics 对象都包含 taskInterval 和 redirectCount, 以及在任务执行期间执行的每个请求和响应事务的指标
- (void)recordMetricsWithRequestId:(NSString *)requestId metrics:(NSURLSessionTaskMetrics *)metrics NS_AVAILABLE_IOS(10_0);

/// Call to set the request mechanism anytime after recordRequestWillBeSent... has been called.
/// This string can be set to anything useful about the API used to make the request.
- (void)recordMechanism:(NSString *)mechanism forRequestId:(NSString *)requestId;

@end

