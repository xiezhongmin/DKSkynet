//
//  DKURLSessionDelegateProxy.m
//  DKSkynet
//
//  Created by admin on 2022/6/15.
//

#import "DKURLSessionDelegateProxy.h"
#import "DKNetworkObserver.h"

@interface DKURLSessionDelegateProxy ()

@property (nonatomic, strong) id originDelegate;
@property (nonatomic, weak) DKNetworkObserver *observer;

@end

@implementation DKURLSessionDelegateProxy

- (instancetype)initWithOriginDelegate:(nullable id)originDelegate observer:(DKNetworkObserver *)observer;
{
    self = [super init];
    if (self) {
        self.originDelegate = originDelegate;
        self.observer = observer;
    }
    return self;
}

#pragma mark - forwarding -

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.originDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.originDelegate respondsToSelector:aSelector]) {
        return self.originDelegate;
    }
    
    return nil;
}

#pragma mark - NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate -

- (void)URLSession:(NSURLSession *)session
                          task:(NSURLSessionTask *)task
    willPerformHTTPRedirection:(NSHTTPURLResponse *)response
                    newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *_Nullable))completionHandler
{
    [self.observer URLSession:session task:task willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:)]) {
        [self.originDelegate URLSession:session task:task willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler];
    } else {
        if (completionHandler) {
            completionHandler(request);
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
     completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [self.observer URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        [self.originDelegate URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    } else {
        if (completionHandler) {
            completionHandler(NSURLSessionResponseAllow);
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.observer URLSession:session dataTask:dataTask didReceiveData:data delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
        [self.originDelegate URLSession:session dataTask:dataTask didReceiveData:data];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    [self.observer URLSession:session dataTask:dataTask didBecomeDownloadTask:downloadTask delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(URLSession:dataTask:didBecomeDownloadTask:)]) {
        [self.originDelegate URLSession:session dataTask:dataTask didBecomeDownloadTask:downloadTask];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [self.observer URLSession:session task:task didCompleteWithError:error delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        [self.originDelegate URLSession:session task:task didCompleteWithError:error];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
API_AVAILABLE(ios(10.0)) {
    [self.observer URLSession:session task:task didFinishCollectingMetrics:metrics delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(URLSession:task:didFinishCollectingMetrics:)]) {
        [self.originDelegate URLSession:session task:task didFinishCollectingMetrics:metrics];
    }
}

- (void)URLSession:(NSURLSession *)session
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
                 didWriteData:(int64_t)bytesWritten
            totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [self.observer URLSession:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
        [self.originDelegate URLSession:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfFile:location.relativePath];
    [self.observer URLSession:session task:downloadTask didFinishDownloadingToURL:location data:data delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(URLSession:downloadTask:didFinishDownloadingToURL:)]) {
        [self.originDelegate URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
    }
}

// MARK: - default imp -

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream * _Nullable))completionHandler
{
    if ([self.originDelegate respondsToSelector:@selector(URLSession:task:needNewBodyStream:)]) {
        [self.originDelegate URLSession:session task:task needNewBodyStream:completionHandler];
    } else {
        NSInputStream *inputStream = nil;
        if (completionHandler) {
            completionHandler(inputStream);
        }
    }
}

- (void)URLSession:(NSURLSession *)session
                   task:(NSURLSessionTask *)task
    didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
      completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    if ([self.originDelegate respondsToSelector:@selector(URLSession:task:didReceiveChallenge:completionHandler:)]) {
        [self.originDelegate URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
    } else {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __block NSURLCredential *credential = nil;
        if (completionHandler) {
            completionHandler(disposition, credential);
        }
    }
}

@end
