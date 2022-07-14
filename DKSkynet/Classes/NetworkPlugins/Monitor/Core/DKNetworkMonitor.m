//
//  DKNetworkMonitor.m
//  DKSkynet
//
//  Created by admin on 2022/6/14.
//

#import "DKNetworkMonitor.h"
#import "DKNetworkRecorder.h"
#import "DKNetworkTransaction.h"
#import "DKNetworkObserver.h"

@interface DKNetworkMonitor () <DKNetworkRecorderDelegate>
@property (nonatomic, assign, readwrite) BOOL isMonitoring;
@end

@implementation DKNetworkMonitor

+ (instancetype)shared {
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (void)start
{
    [DKNetworkObserver setEnabled:YES];

    [[DKNetworkRecorder defaultRecorder] addDelegate:self];
}

- (void)stop
{
    [DKNetworkObserver setEnabled:NO];

    [[DKNetworkRecorder defaultRecorder] removeDelegate:self];
}

- (BOOL)isMonitoring
{
    return [DKNetworkObserver isEnabled];
}

#pragma mark - DKNetworkRecorderDelegate -

//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wunguarded-availability"
//
//- (void)recorderWantCacheTransactionAsUpdated:(DKNetworkTransaction *)transaction currentState:(DKNetworkTransactionState)state {
//    if (transaction.transactionState == DKNetworkTransactionStateFinished) {
//        if (transaction.useURLSessionTaskMetrics) {
//            // 过滤缓存情况
//            DKURLSessionTaskTransactionMetrics *metrics = [transaction.taskMetrics.transactionMetrics lastObject];
//            if (metrics.resourceFetchType == NSURLSessionTaskMetricsResourceFetchTypeLocalCache) {
//                return;
//            } else {
//                int64_t bytes = transaction.receivedDataLength;
//
//                // 现有 api 无法准确获取到开始下发的时间，只能采用估算方式
//                // (response.start - request.end) * 2 / 3 ~ response.end
//                if (metrics.responseEndDate && metrics.responseStartDate && metrics.responseStartDate && metrics.requestEndDate) {
//                    NSTimeInterval rspStart2RspEnd = [metrics.responseEndDate timeIntervalSinceDate:metrics.responseStartDate];
//                    NSTimeInterval reqEnd2RspStart = [metrics.responseStartDate timeIntervalSinceDate:metrics.requestEndDate];
//                    NSTimeInterval duration = reqEnd2RspStart * 2.f / 3.f + rspStart2RspEnd;
//                    [[MTHNetworkStat shared] addBandwidthWithBytes:bytes duration:duration * 1000];
//                }
//            }
//        }
//
//        // 非 URLSessionTaskMetrics 统计，统计误差较大，暂不计入
//    }
//}

//#pragma clang diagnostic pop

@end
