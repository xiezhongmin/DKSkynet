//
//  DKNetworkTransactionConstant.h
//  DKSkynet
//
//  Created by admin on 2022/7/13.
//
#import <Foundation/Foundation.h>

// general key
static NSString const * kDKSkynetTransactionRequestKey = @"request";
static NSString const * kDKSkynetTransactionResponseKey = @"response";
static NSString const * kDKSkynetTransactionRequestIdKey = @"requestId";
static NSString const * kDKSkynetTransactionRequestMechanismKey = @"requestMechanism";
static NSString const * kDKSkynetTransactionDurationKey = @"duration";
static NSString const * kDKSkynetTransactionErrorKey = @"error";
static NSString const * kDKSkynetTransactionStartTimeKey = @"startTime";
static NSString const * kDKSkynetTransactionLatencyKey = @"latency";
static NSString const * kDKSkynetTransactionStateKey = @"state";
// request key
static NSString const * kDKSkynetTransactionRequestURLKey = @"url";
static NSString const * kDKSkynetTransactionRequestTimeoutIntervalKey = @"timeoutInterval";
static NSString const * kDKSkynetTransactionRequestHTTPMethodKey = @"HTTPMethod";
static NSString const * kDKSkynetTransactionRequestAllHTTPHeaderFieldsKey = @"allHTTPHeaderFields";
static NSString const * kDKSkynetTransactionRequestHTTPBodyKey = @"HTTPBody";
static NSString const * kDKSkynetTransactionRequestLengthKey = @"requestLength";
// response key
static NSString const * kDKSkynetTransactionResponseStatusCodeKey = @"statusCode";
static NSString const * kDKSkynetTransactionResponseHeaderFieldsKey = @"headerFields";
static NSString const * kDKSkynetTransactionResponseLengthKey = @"responseLength";
static NSString const * kDKSkynetTransactionResponseReceivedDataLengthKey = @"receivedDataLength";
static NSString const * kDKSkynetTransactionResponseBodyKey = @"responseBody";
// metrics key
static NSString const * kDKSkynetTransactionMetricsTaskMetricsKey = @"taskMetrics";
static NSString const * kDKSkynetTransactionMetricsRedirectCountKey = @"redirectCount";
static NSString const * kDKSkynetTransactionMetricsTaskIntervalKey = @"taskInterval";
static NSString const * kDKSkynetTransactionMetricsRequestURLKey = @"requestURL";
static NSString const * kDKSkynetTransactionMetricsStartDateKey = @"startDate";
static NSString const * kDKSkynetTransactionMetricsEndDateKey = @"endDate";
static NSString const * kDKSkynetTransactionMetricsDurationKey = @"duration";
static NSString const * kDKSkynetTransactionMetricsTransactionMetricsKey = @"transactionMetrics";
static NSString const * kDKSkynetTransactionMetricsResourceFetchTypeKey = @"resourceFetchType";
static NSString const * kDKSkynetTransactionMetricsFetchStartDateKey = @"fetchStartDate";
static NSString const * kDKSkynetTransactionMetricsDomainLookupStartDateKey = @"domainLookupStartDate";
static NSString const * kDKSkynetTransactionMetricsDomainLookupEndDateKey = @"domainLookupEndDate";
static NSString const * kDKSkynetTransactionMetricsConnectStartDateKey = @"connectStartDate";
static NSString const * kDKSkynetTransactionMetricsConnectEndDateKey = @"connectEndDate";
static NSString const * kDKSkynetTransactionMetricsSecureConnectionStartDateKey = @"secureConnectionStartDate";
static NSString const * kDKSkynetTransactionMetricsSecureConnectionEndDateKey = @"secureConnectionEndDate";
static NSString const * kDKSkynetTransactionMetricsRequestStartDateKey = @"requestStartDate";
static NSString const * kDKSkynetTransactionMetricsRequestEndDateKey = @"requestEndDate";
static NSString const * kDKSkynetTransactionMetricsResponseStartDateKey = @"responseStartDate";
static NSString const * kDKSkynetTransactionMetricsResponseEndDateKey = @"responseEndDate";
static NSString const * kDKSkynetTransactionMetricsProtocolKey = @"protocol";
