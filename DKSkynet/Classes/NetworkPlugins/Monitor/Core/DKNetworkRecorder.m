//
//  DKNetworkRecorder.m
//  DKSkynet
//
//  Created by admin on 2022/6/15.
//

#import "DKNetworkRecorder.h"
#import "DKNetworkMonitorMacro.h"
#import <DKKit/DKKitMacro.h>
#import "DKURLSessionTaskMetrics.h"
#import "DKNetworkRecordsStorage.h"

@interface DKNetworkRecorder ()

@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic, strong) NSHashTable <id <DKNetworkRecorderDelegate>> *delegates;
@property (nonatomic, strong) NSMutableDictionary <NSString *, DKNetworkTransaction *> *requestIdsToTransactions;

@end

@implementation DKNetworkRecorder

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestIdsToTransactions = [NSMutableDictionary dictionary];
        self.delegates = [NSHashTable weakObjectsHashTable];
        
        // Serial queue used because we use mutable objects that are not thread safe
        self.queue = dispatch_queue_create("com.duke.skynet.network.recorder", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (instancetype)defaultRecorder
{
    static id _defaultRecorder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultRecorder = [[self alloc] init];
    });
    return _defaultRecorder;
}

// MAKE: - delegate -

- (void)addDelegate:(id<DKNetworkRecorderDelegate>)delegate
{
    @synchronized (self.delegates) {
        [self.delegates addObject:delegate];
    }
}

- (void)removeDelegate:(id<DKNetworkRecorderDelegate>)delegate
{
    @synchronized (self.delegates) {
        [self.delegates removeObject:delegate];
    }
}

- (NSArray <id <DKNetworkRecorderDelegate>> *)allDelegates
{
    @synchronized (self.delegates) {
        return self.delegates.allObjects;
    }
}

#pragma mark - Network Events -

- (void)recordRequestWillBeSentWithRequestId:(NSString *)requestId request:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    for (NSString *host in self.hostBlacklist) {
        if ([request.URL.host hasSuffix:host]) {
            return;
        }
    }
    
    // Before async block to stay accurate
    NSDate *startDate = [NSDate date];
    
    if (redirectResponse) {
        [self recordResponseReceivedWithRequestId:requestId response:redirectResponse];
    }
    
    NSURLRequest *copyRequest = [request copy];
    dispatch_async(self.queue, ^{
        DKNetworkTransaction *transaction = self.requestIdsToTransactions[requestId];
        if (transaction) {
            return;
        }
   
        transaction = [[DKNetworkTransaction alloc] init];
        transaction.requestId = requestId;
        transaction.request = copyRequest;
        transaction.startTime = startDate;
        [self.requestIdsToTransactions setObject:transaction forKey:requestId];
        transaction.transactionState = DKNetworkTransactionStateAwaitingResponse;
        [self performDelegatesForNewTransaction:transaction];
    });
}

- (void)recordResponseReceivedWithRequestId:(NSString *)requestId response:(NSURLResponse *)response
{
    NSDate *responseDate = [NSDate date];
    NSURLResponse *copyResponse = [response copy];
    dispatch_async(self.queue, ^{
        DKNetworkTransaction *transaction = self.requestIdsToTransactions[requestId];
        if (!transaction) {
#if DKSkynetNetworkDebugEnabled
            DKLogWarn(@"[DKSkynet] record network transaction response received failed.");
#endif
            return;
        }
        
        transaction.response = (NSHTTPURLResponse *)copyResponse;
        transaction.transactionState = DKNetworkTransactionStateReceivingData;
        transaction.latency = -[transaction.startTime timeIntervalSinceDate:responseDate];
        [self performDelegatesForTransactionUpdated:transaction];
    });
}

- (void)recordDataReceivedWithRequestId:(NSString *)requestId dataLength:(int64_t)dataLength
{
    dispatch_async(self.queue, ^{
        DKNetworkTransaction *transaction = self.requestIdsToTransactions[requestId];
        if (!transaction) {
#if DKSkynetNetworkDebugEnabled
            DKLogWarn(@"[DKSkynet] record network transaction data received failed.");
#endif
            return;
        }
        
        transaction.receivedDataLength += dataLength;
        [self performDelegatesForTransactionUpdated:transaction];
    });
}

- (void)recordLoadingFinishedWithRequestId:(NSString *)requestId responseBody:(NSData *)responseBody
{
    NSDate *finishedDate = [NSDate date];
    NSData *copyResponseBody = [responseBody copy];
    dispatch_async(self.queue, ^{
        DKNetworkTransaction *transaction = self.requestIdsToTransactions[requestId];
        if (!transaction) {
#if DKSkynetNetworkDebugEnabled
            DKLogWarn(@"[DKSkynet] record network transaction loading finished failed, transaction released: %@.", requestId);
#endif
            return;
        }
        
        transaction.duration = -[transaction.startTime timeIntervalSinceDate:finishedDate];
        if (transaction.responseContentType != DKNetworkResponseMIMETypeOther && [copyResponseBody length] > 0) {
            transaction.responseBody = copyResponseBody;
        } else {
            // 这里防止 response 为其他类型的时候, 流量没有统计
            transaction.responseBody = copyResponseBody;
            [transaction requestLength];
            transaction.responseBody = nil;
        }
        
        transaction.transactionState = DKNetworkTransactionStateFinished;
        [self performDelegatesForTransactionUpdated:transaction];
        [self.requestIdsToTransactions removeObjectForKey:requestId];
    });
}

- (void)recordLoadingFailedWithRequestId:(NSString *)requestId error:(NSError *)error
{
    dispatch_async(self.queue, ^{
        DKNetworkTransaction *transaction = self.requestIdsToTransactions[requestId];
        if (!transaction) {
#if DKSkynetNetworkDebugEnabled
            DKLogWarn(@"[DKSkynet] record network transaction loading failure failed.");
#endif
            return;
        }
        
        transaction.duration = -[transaction.startTime timeIntervalSinceNow];
        transaction.error = error;
        transaction.transactionState = DKNetworkTransactionStateFailed;
        [self performDelegatesForTransactionUpdated:transaction];
        [self.requestIdsToTransactions removeObjectForKey:requestId];
    });
}

- (void)recordMetricsWithRequestId:(NSString *)requestId metrics:(NSURLSessionTaskMetrics *)metrics
{
    dispatch_async(self.queue, ^{
        DKNetworkTransaction *transaction = self.requestIdsToTransactions[requestId];
        if (!transaction) {
#if DKSkynetNetworkDebugEnabled
            DKLogWarn(@"[DKSkynet] record network transaction metrics failed.");
#endif
            return;
        }
        
        transaction.taskMetrics = [DKURLSessionTaskMetrics metricsFromSystemMetrics:metrics];
        [self performDelegatesForTransactionUpdated:transaction];
    });
}

- (void)recordMechanism:(NSString *)mechanism forRequestId:(NSString *)requestId
{
    dispatch_async(self.queue, ^{
        DKNetworkTransaction *transaction = self.requestIdsToTransactions[requestId];
        if (!transaction) {
#if DKSkynetNetworkDebugEnabled
            DKLogWarn(@"[DKSkynet] record network transaction mechanism failed.");
#endif
            return;
        }
        
        transaction.requestMechanism = mechanism;
        [self performDelegatesForTransactionUpdated:transaction];
    });
}


#pragma marl - perform delegate -

- (void)performDelegatesForNewTransaction:(DKNetworkTransaction *)transaction
{
    @synchronized (self.delegates) {
        for (id <DKNetworkRecorderDelegate> delegate in self.delegates) {
            if ([delegate respondsToSelector:@selector(recorderNewTransaction:)]) {
                [delegate recorderNewTransaction:transaction];
            }
        }
    }
}

- (void)performDelegatesForTransactionUpdated:(DKNetworkTransaction *)transaction
{
    // 记录此时的 state, 防止异步发送后，transaction.state 已经被改变
    DKNetworkTransactionState state = transaction.transactionState;
    @synchronized (self.delegates) {
        for (id <DKNetworkRecorderDelegate> delegate in self.delegates) {
            if ([delegate respondsToSelector:@selector(recorderTransactionUpdated:currentState:)]) {
                [delegate recorderTransactionUpdated:transaction currentState:state];
            }
        }
    }
}

@end
