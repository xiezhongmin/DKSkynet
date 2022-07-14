//
//  DKHURLSessionTaskMetrics.m
//  DKSkynet
//
//  Created by admin on 2022/6/20.
//

#import "DKURLSessionTaskMetrics.h"

@implementation DKURLSessionTaskTransactionMetrics

@end

@implementation DKURLSessionTaskMetrics

+ (DKURLSessionTaskMetrics *)metricsFromSystemMetrics:(NSURLSessionTaskMetrics *)urlSessionTaskMetrics {
    DKURLSessionTaskMetrics *metrics = [[DKURLSessionTaskMetrics alloc] init];
    metrics.urlSessionTaskMetrics = urlSessionTaskMetrics;
    metrics.redirectCount = urlSessionTaskMetrics.redirectCount;
    metrics.taskInterval = urlSessionTaskMetrics.taskInterval;

    NSMutableArray *arry = [NSMutableArray arrayWithCapacity:urlSessionTaskMetrics.transactionMetrics.count];
    for (NSURLSessionTaskTransactionMetrics *transcationMetric in urlSessionTaskMetrics.transactionMetrics) {
        DKURLSessionTaskTransactionMetrics *dkTranscationMetric = [[DKURLSessionTaskTransactionMetrics alloc] init];
        dkTranscationMetric.response = transcationMetric.response;
        dkTranscationMetric.fetchStartDate = transcationMetric.fetchStartDate;
        dkTranscationMetric.domainLookupStartDate = transcationMetric.domainLookupStartDate;
        dkTranscationMetric.domainLookupEndDate = transcationMetric.domainLookupEndDate;
        dkTranscationMetric.connectStartDate = transcationMetric.connectStartDate;
        dkTranscationMetric.connectEndDate = transcationMetric.connectEndDate;
        dkTranscationMetric.secureConnectionStartDate = transcationMetric.secureConnectionStartDate;
        dkTranscationMetric.secureConnectionEndDate = transcationMetric.secureConnectionEndDate;
        dkTranscationMetric.requestStartDate = transcationMetric.requestStartDate;
        dkTranscationMetric.requestEndDate = transcationMetric.requestEndDate;
        dkTranscationMetric.responseStartDate = transcationMetric.responseStartDate;
        dkTranscationMetric.responseEndDate = transcationMetric.responseEndDate;
        dkTranscationMetric.networkProtocolName = transcationMetric.networkProtocolName;
        dkTranscationMetric.proxyConnection = transcationMetric.isProxyConnection;
        dkTranscationMetric.reusedConnection = transcationMetric.isReusedConnection;
        dkTranscationMetric.resourceFetchType = transcationMetric.resourceFetchType;
        [arry addObject:dkTranscationMetric];
    }
    metrics.transactionMetrics = arry;
    return metrics;
}

@end
