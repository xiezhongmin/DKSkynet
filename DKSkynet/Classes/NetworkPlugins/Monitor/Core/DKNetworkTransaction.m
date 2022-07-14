//
//  DKNetworkTransaction.m
//  DKSkynet
//
//  Created by admin on 2022/6/17.
//

#import "DKNetworkTransaction.h"
#import <dlfcn.h>
#import "NSData+DKSkynetNetwork.h"
#import <DKKit/NSDate+DKFormat.h>
#import "DKNetworkTransactionConstant.h"

@interface DKNetworkTransaction ()

@property (nonatomic, copy, readwrite) NSData *cachedRequestBody;
@property (nonatomic, assign, readwrite) BOOL useURLSessionTaskMetrics;

@end

@implementation DKNetworkTransaction

- (instancetype)init
{
    self = [super init];
    if (self) {
       //
    }
    return self;
}

- (NSString *)description
{
    NSString *description = [super description];

    description = [description stringByAppendingFormat:@" id = %@;", self.requestId];
    description = [description stringByAppendingFormat:@" url = %@;", self.request.URL];
    description = [description stringByAppendingFormat:@" duration = %f;", self.duration];
    description = [description stringByAppendingFormat:@" receivedDataLength = %lld", self.receivedDataLength];

    return description;
}

#pragma mark - Transform -

+ (instancetype)transactionFromPropertyDictionary:(NSDictionary *)dictionary
{
    if (!dictionary || !dictionary.count) {
        return nil;
    }

    NSDictionary *requestDictionary = dictionary[kDKSkynetTransactionRequestKey];
    if (!requestDictionary) {
        return nil;
    }

    NSDictionary *responseDictionary = dictionary[kDKSkynetTransactionResponseKey];
    if (!responseDictionary) {
        return nil;
    }
    
    DKNetworkTransaction *transaction = [[DKNetworkTransaction alloc] init];
    transaction.requestId = dictionary[kDKSkynetTransactionRequestIdKey];
    transaction.requestMechanism = dictionary[kDKSkynetTransactionRequestMechanismKey];
    NSString *localizedErrorDescription = dictionary[kDKSkynetTransactionErrorKey];
    if (localizedErrorDescription.length) {
        transaction.error = [[NSError alloc] initWithDomain:NSNetServicesErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : localizedErrorDescription}];
    }
    
    transaction.startTime = [NSDate dk_dateWithString:dictionary[kDKSkynetTransactionStartTimeKey] format:self.dateFormatter];
    transaction.latency = [dictionary[kDKSkynetTransactionLatencyKey] doubleValue];
    transaction.duration = [dictionary[kDKSkynetTransactionDurationKey] doubleValue];
    transaction.transactionState = [dictionary[kDKSkynetTransactionStateKey] integerValue];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *url = [NSURL URLWithString:requestDictionary[kDKSkynetTransactionRequestURLKey] ?: @""];
    request.URL = url;
    request.timeoutInterval = [requestDictionary[kDKSkynetTransactionRequestTimeoutIntervalKey] doubleValue];
    request.HTTPMethod = requestDictionary[kDKSkynetTransactionRequestHTTPMethodKey] ?: @"GET";
    request.allHTTPHeaderFields = [requestDictionary[kDKSkynetTransactionRequestAllHTTPHeaderFieldsKey] copy];
    request.HTTPBody = [requestDictionary[kDKSkynetTransactionRequestHTTPBodyKey] dataUsingEncoding:NSUTF8StringEncoding];
    transaction.request = [request copy];
    transaction.requestLength = [dictionary[kDKSkynetTransactionRequestLengthKey] integerValue];
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                              statusCode:[responseDictionary[kDKSkynetTransactionResponseStatusCodeKey] integerValue]
                                                             HTTPVersion:nil
                                                            headerFields:responseDictionary[kDKSkynetTransactionResponseHeaderFieldsKey]];
    transaction.response = response;
    transaction.responseLength = [dictionary[kDKSkynetTransactionResponseLengthKey] integerValue];
    transaction.receivedDataLength = [responseDictionary[kDKSkynetTransactionResponseReceivedDataLengthKey] integerValue];
    transaction.responseBody = [responseDictionary[kDKSkynetTransactionResponseBodyKey] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *taskMetricsDictionary;
    if ((taskMetricsDictionary = dictionary[kDKSkynetTransactionMetricsTaskMetricsKey])) {
        if (@available(iOS 10.0, *)) {
            DKURLSessionTaskMetrics *taskMetrics = [[DKURLSessionTaskMetrics alloc] init];
            taskMetrics.redirectCount = ((NSNumber *)taskMetricsDictionary[kDKSkynetTransactionMetricsRedirectCountKey]).unsignedIntegerValue;

            NSDictionary *taskIntervalDictionary = taskMetricsDictionary[kDKSkynetTransactionMetricsTaskIntervalKey];
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[taskIntervalDictionary[kDKSkynetTransactionMetricsStartDateKey] doubleValue]];
            NSDateInterval *dateInterval = [[NSDateInterval alloc] initWithStartDate:startDate
                                                                            duration:[taskIntervalDictionary[kDKSkynetTransactionMetricsDurationKey] doubleValue]];
            taskMetrics.taskInterval = dateInterval;

            NSArray<NSDictionary *> *transactionMetricsDictionaryArray = taskMetricsDictionary[kDKSkynetTransactionMetricsTransactionMetricsKey];
            NSMutableArray <DKURLSessionTaskTransactionMetrics *> *transactionMetricsArray = [NSMutableArray arrayWithCapacity:transactionMetricsDictionaryArray.count];
            for (NSDictionary *transMetricsDictionary in transactionMetricsDictionaryArray) {
                DKURLSessionTaskTransactionMetrics *transMetrics = [[DKURLSessionTaskTransactionMetrics alloc] init];
                transMetrics.request = request;
                transMetrics.resourceFetchType = ((NSNumber *)transMetricsDictionary[kDKSkynetTransactionMetricsResourceFetchTypeKey]).integerValue;
                transMetrics.fetchStartDate = [NSDate dateWithTimeIntervalSince1970:[transMetricsDictionary[kDKSkynetTransactionMetricsFetchStartDateKey] doubleValue]];
                transMetrics.domainLookupStartDate = [NSDate dateWithTimeIntervalSince1970:[transMetricsDictionary[kDKSkynetTransactionMetricsDomainLookupStartDateKey] doubleValue]];
                transMetrics.domainLookupEndDate = [NSDate dateWithTimeIntervalSince1970:[transMetricsDictionary[kDKSkynetTransactionMetricsDomainLookupEndDateKey] doubleValue]];
                transMetrics.connectStartDate = [NSDate dateWithTimeIntervalSince1970:[transMetricsDictionary[kDKSkynetTransactionMetricsConnectStartDateKey] doubleValue]];
                transMetrics.connectEndDate = [NSDate dateWithTimeIntervalSince1970:[transMetricsDictionary[kDKSkynetTransactionMetricsConnectEndDateKey] doubleValue]];
                transMetrics.secureConnectionStartDate = [NSDate dateWithTimeIntervalSince1970:[transMetricsDictionary[kDKSkynetTransactionMetricsSecureConnectionStartDateKey] doubleValue]];
                transMetrics.secureConnectionEndDate = [NSDate dateWithTimeIntervalSince1970:[transMetricsDictionary[kDKSkynetTransactionMetricsSecureConnectionEndDateKey] doubleValue]];
                transMetrics.requestStartDate = [NSDate dateWithTimeIntervalSince1970:[transMetricsDictionary[kDKSkynetTransactionMetricsRequestStartDateKey] doubleValue]];
                transMetrics.requestEndDate = [NSDate dateWithTimeIntervalSince1970:[transMetricsDictionary[kDKSkynetTransactionMetricsRequestEndDateKey] doubleValue]];
                transMetrics.responseStartDate = [NSDate dateWithTimeIntervalSince1970:[transMetricsDictionary[kDKSkynetTransactionMetricsResponseStartDateKey] doubleValue]];
                transMetrics.responseEndDate = [NSDate dateWithTimeIntervalSince1970:[transMetricsDictionary[kDKSkynetTransactionMetricsResponseEndDateKey] doubleValue]];
                transMetrics.networkProtocolName = transMetricsDictionary[kDKSkynetTransactionMetricsProtocolKey];
                [transactionMetricsArray addObject:transMetrics];
            }

            if (transactionMetricsArray.count) {
                taskMetrics.transactionMetrics = transactionMetricsArray;
            }

            transaction.taskMetrics = taskMetrics;
        } else {
            // Fallback on earlier versions
        }
    }
    
    return transaction;
}

- (NSDictionary *)dictionaryFromAllProperty
{
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[kDKSkynetTransactionRequestIdKey] = self.requestId ?: @"";
    dict[kDKSkynetTransactionRequestMechanismKey] = self.requestMechanism ?: @"";
    dict[kDKSkynetTransactionErrorKey] = self.error ? [self.error localizedDescription] : @"";
    dict[kDKSkynetTransactionStartTimeKey] = [self.startTime dk_stringWithFormat:self.class.dateFormatter];
    dict[kDKSkynetTransactionLatencyKey] = @(self.latency);
    dict[kDKSkynetTransactionDurationKey] = @(self.duration);
    dict[kDKSkynetTransactionStateKey] = @(self.transactionState);
    
    NSMutableDictionary *request = @{}.mutableCopy;
    request[kDKSkynetTransactionRequestURLKey] = self.request.URL.absoluteString ?: @"";
    request[kDKSkynetTransactionRequestTimeoutIntervalKey] = @(self.request.timeoutInterval);
    request[kDKSkynetTransactionRequestHTTPMethodKey] = self.request.HTTPMethod ?: @"";
    NSMutableDictionary *allHTTPHeaderFields = @{}.mutableCopy;
    [self.request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
        allHTTPHeaderFields[key] = obj ?: @"";
    }];
    request[kDKSkynetTransactionRequestAllHTTPHeaderFieldsKey] = allHTTPHeaderFields.copy;
    request[kDKSkynetTransactionRequestHTTPBodyKey] = [[NSString alloc] initWithData:self.cachedRequestBody encoding:NSUTF8StringEncoding];
    dict[kDKSkynetTransactionRequestKey] = request.copy;
    dict[kDKSkynetTransactionRequestLengthKey] = @(self.requestLength);
    
    NSMutableDictionary *response = @{}.mutableCopy;
    NSHTTPURLResponse *httpResponse = self.response;
    response[kDKSkynetTransactionResponseStatusCodeKey] = @(httpResponse.statusCode);
    response[kDKSkynetTransactionResponseReceivedDataLengthKey] = @(self.receivedDataLength);
    NSMutableDictionary *headerFields = @{}.mutableCopy;
    [httpResponse.allHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
        headerFields[key] = obj ?: @"";
    }];
    response[kDKSkynetTransactionResponseHeaderFieldsKey] = headerFields.copy;
    response[kDKSkynetTransactionResponseBodyKey] = [[NSString alloc] initWithData:self.responseBody encoding:NSUTF8StringEncoding];
    dict[kDKSkynetTransactionResponseKey] = response.copy;
    dict[kDKSkynetTransactionResponseLengthKey] = @(self.responseLength);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
    if (self.taskMetrics) {
        NSMutableDictionary *taskMetrics = @{}.mutableCopy;
        taskMetrics[kDKSkynetTransactionMetricsRedirectCountKey] = @(self.taskMetrics.redirectCount);
        NSDictionary *taskInterval = @{
            kDKSkynetTransactionMetricsStartDateKey : @([self.taskMetrics.taskInterval.startDate timeIntervalSince1970]),
            kDKSkynetTransactionMetricsEndDateKey : @([self.taskMetrics.taskInterval.endDate timeIntervalSince1970]),
            kDKSkynetTransactionMetricsDurationKey : @(self.taskMetrics.taskInterval.duration),
        };
        taskMetrics[kDKSkynetTransactionMetricsTaskIntervalKey] = taskInterval.copy;

        NSMutableArray *transactionMetrics = @[].mutableCopy;
        for (DKURLSessionTaskTransactionMetrics *metrics in self.taskMetrics.transactionMetrics) {
            NSMutableDictionary *metricsDict = @{}.mutableCopy;
            metricsDict[kDKSkynetTransactionMetricsRequestURLKey] = (metrics.request.URL.absoluteString ?: self.request.URL.absoluteString) ?: @"";
            metricsDict[kDKSkynetTransactionMetricsResourceFetchTypeKey] = @(metrics.resourceFetchType);
            metricsDict[kDKSkynetTransactionMetricsFetchStartDateKey] = @([metrics.fetchStartDate timeIntervalSince1970]);
            metricsDict[kDKSkynetTransactionMetricsDomainLookupStartDateKey] = @([metrics.domainLookupStartDate timeIntervalSince1970]);
            metricsDict[kDKSkynetTransactionMetricsDomainLookupEndDateKey] = @([metrics.domainLookupEndDate timeIntervalSince1970]);
            metricsDict[kDKSkynetTransactionMetricsConnectStartDateKey] = @([metrics.connectStartDate timeIntervalSince1970]);
            metricsDict[kDKSkynetTransactionMetricsConnectEndDateKey] = @([metrics.connectEndDate timeIntervalSince1970]);
            metricsDict[kDKSkynetTransactionMetricsSecureConnectionStartDateKey] = @([metrics.secureConnectionStartDate timeIntervalSince1970]);
            metricsDict[kDKSkynetTransactionMetricsSecureConnectionEndDateKey] = @([metrics.secureConnectionEndDate timeIntervalSince1970]);
            metricsDict[kDKSkynetTransactionMetricsRequestStartDateKey] = @([metrics.requestStartDate timeIntervalSince1970]);
            metricsDict[kDKSkynetTransactionMetricsRequestEndDateKey] = @([metrics.requestEndDate timeIntervalSince1970]);
            metricsDict[kDKSkynetTransactionMetricsResponseStartDateKey] = @([metrics.responseStartDate timeIntervalSince1970]);
            metricsDict[kDKSkynetTransactionMetricsResponseEndDateKey] = @([metrics.responseEndDate timeIntervalSince1970]);
            metricsDict[kDKSkynetTransactionMetricsProtocolKey] = metrics.networkProtocolName ?: @"h1";
            [transactionMetrics addObject:metricsDict.copy];
        }
        taskMetrics[kDKSkynetTransactionMetricsTransactionMetricsKey] = transactionMetrics.copy;

        dict[kDKSkynetTransactionMetricsTaskMetricsKey] = taskMetrics.copy;
    }
#pragma clang diagnostic pop
    
    return dict.copy;
}


#pragma mark - Getter/Setter -

+ (NSString *)dateFormatter
{
    return @"yyyy-MM-dd HH:mm:ss.SSS";
}

- (void)setTaskMetrics:(DKURLSessionTaskMetrics *)taskMetrics
{
    self.useURLSessionTaskMetrics = (taskMetrics != nil);
    _taskMetrics = taskMetrics;
}

- (NSDate *)startTime
{
    if (self.useURLSessionTaskMetrics) {
        if (@available(iOS 10.0, *)) {
            return self.taskMetrics.taskInterval.startDate ? self.taskMetrics.taskInterval.startDate : _startTime;
        } else {
            // Fallback on earlier versions
            return _startTime;
        }
    }
    
    return _startTime;
}

- (NSTimeInterval)latency
{
    if (self.useURLSessionTaskMetrics) {
        if (@available(iOS 10.0, *)) {
            DKURLSessionTaskTransactionMetrics *metrics = self.taskMetrics.transactionMetrics.lastObject;
            NSTimeInterval latency = [metrics.responseStartDate timeIntervalSinceDate:self.taskMetrics.taskInterval.startDate];
            return latency;
        } else {
            // Fallback on earlier versions
        }
    }
    return _latency;
}

- (NSTimeInterval)duration
{
    if (self.useURLSessionTaskMetrics) {
        if (@available(iOS 10.0, *)) {
            return self.taskMetrics.taskInterval.duration;
        } else {
            // Fallback on earlier versions
        }
    }
    
    return _duration;
}

- (DKNetworkResponseMIMEType)responseContentType
{
    NSString *mimeType = self.response.MIMEType;
    
    if (!mimeType) {
        _responseContentType = DKNetworkResponseMIMETypeNULL;
    } else if ([mimeType hasPrefix:@"application/json"]) {
        _responseContentType = DKNetworkResponseMIMETypeJSON;
    } else if ([mimeType hasPrefix:@"application/xml"]) {
        _responseContentType = DKNetworkResponseMIMETypeXML;
    } else if ([mimeType hasPrefix:@"text/"]) {
        _responseContentType = DKNetworkResponseMIMETypeText;
    } else if ([mimeType hasPrefix:@"text/html"]) {
        _responseContentType = DKNetworkResponseMIMETypeHTML;
    } else {
        _responseContentType = DKNetworkResponseMIMETypeOther;
    }

    return _responseContentType;
}


- (NSData *)cachedRequestBody
{
    if (!_cachedRequestBody) {
        if (self.request.HTTPBody != nil) {
            _cachedRequestBody = self.request.HTTPBody;
        } else if ([self.request.HTTPBodyStream conformsToProtocol:@protocol(NSCopying)]) {
            NSInputStream *bodyStream = [self.request.HTTPBodyStream copy];
            const NSUInteger bufferSize = 1024;
            uint8_t buffer[bufferSize];
            NSMutableData *data = [NSMutableData data];
            [bodyStream open];
            NSInteger readBytes = 0;
            do {
                readBytes = [bodyStream read:buffer maxLength:bufferSize];
                [data appendBytes:buffer length:readBytes];
            } while (readBytes > 0);
            [bodyStream close];
            _cachedRequestBody = data;
        }
    }
    return _cachedRequestBody;
}

- (NSInteger)requestLength
{
    if (!_requestLength) {
        NSString *lineStr = [NSString stringWithFormat:@"%@ %@ %@\r\n", self.request.HTTPMethod, self.request.URL.path, @"HTTP/1.1"];
        NSData *lineData = [lineStr dataUsingEncoding:NSUTF8StringEncoding];

        NSMutableString *headerStr = [[NSMutableString alloc] init];
        [self.request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
            [headerStr appendString:[NSString stringWithFormat:@"%@:%@\n", key, obj]];
        }];
        NSData *headersData = [headerStr dataUsingEncoding:NSUTF8StringEncoding];

        NSData *bodyData = self.request.HTTPBody;

        _requestLength = lineData.length + headersData.length + bodyData.length;
    }
    
    return _requestLength;
}

typedef CFHTTPMessageRef (*DKURLResponseGetHTTPResponse)(CFURLRef response);

- (NSInteger)responseLength
{
    if (!_responseLength) {
        NSString *funName = @"CFURLResponseGetHTTPResponse";
        DKURLResponseGetHTTPResponse originURLResponseGetHTTPResponse = dlsym(RTLD_DEFAULT, [funName UTF8String]);

        NSString *statusLine = @"";
        SEL theSelector = NSSelectorFromString(@"_CFURLResponse");
        if ([self.response respondsToSelector:theSelector] && NULL != originURLResponseGetHTTPResponse) {
            // 获取 NSURLResponse 的 _CFURLResponse
            CFTypeRef cfResponse = CFBridgingRetain(((id(*)(id, SEL))[self.response methodForSelector:theSelector])(self.response, theSelector));
            if (NULL != cfResponse) {
                // 将 CFURLResponseRef 转化为 CFHTTPMessageRef
                CFHTTPMessageRef messageRef = originURLResponseGetHTTPResponse(cfResponse);
                if (NULL != messageRef) {
                    statusLine = (__bridge_transfer NSString *)CFHTTPMessageCopyResponseStatusLine(messageRef);
                    CFRelease(cfResponse);
                } else {
                    CFRelease(cfResponse);
                }
            }
        }

        // status-line 计算的补充
        NSMutableString *lineStr = @"".mutableCopy;
        [lineStr appendString:statusLine];
        NSArray *statusLineArr = [statusLine componentsSeparatedByString:@" "];
        if (statusLineArr.count == 2 && ![statusLine hasSuffix:@" "]) {
            [lineStr appendString:@" "];
        }
        if (![lineStr hasSuffix:@"\r\n"]) {
            [lineStr appendString:@"\r\n"];
        }
        NSData *lineData = [lineStr dataUsingEncoding:NSUTF8StringEncoding];

        NSHTTPURLResponse *httpResponse = self.response;
        NSString *headerStr = @"";
        for (NSString *key in httpResponse.allHeaderFields.allKeys) {
            headerStr = [headerStr stringByAppendingString:key];
            headerStr = [headerStr stringByAppendingString:@": "];
            if ([httpResponse.allHeaderFields objectForKey:key]) {
                headerStr = [headerStr stringByAppendingString:httpResponse.allHeaderFields[key]];
            }
            headerStr = [headerStr stringByAppendingString:@"\r\n"];
        }
        headerStr = [headerStr stringByAppendingString:@"\r\n"];
        NSData *headerData = [headerStr dataUsingEncoding:NSUTF8StringEncoding];

        NSData *responseData;
        if ([[httpResponse.allHeaderFields objectForKey:@"Content-Encoding"] isEqualToString:@"gzip"]) {
            responseData = [self.responseBody dk_gzippedData];
        } else {
            responseData = self.responseBody;
        }
        _responseLength = lineData.length + headerData.length + responseData.length;
    }
    
    return _responseLength;
}

+ (NSString *)readableStringFromTransactionState:(DKNetworkTransactionState)state
{
    NSString *readableString = nil;
    switch (state) {
        case DKNetworkTransactionStateUnstarted:
            readableString = @"Unstarted";
            break;

        case DKNetworkTransactionStateAwaitingResponse:
            readableString = @"Awaiting Response";
            break;

        case DKNetworkTransactionStateReceivingData:
            readableString = @"Receiving Data";
            break;

        case DKNetworkTransactionStateFinished:
            readableString = @"Finished";
            break;

        case DKNetworkTransactionStateFailed:
            readableString = @"Failed";
            break;
    }
    return readableString;
}

@end
