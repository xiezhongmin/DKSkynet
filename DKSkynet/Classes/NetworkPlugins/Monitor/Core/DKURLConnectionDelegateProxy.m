//
//  DKURLConnectionDelegateProxy.m
//  DKSkynet
//
//  Created by admin on 2022/6/14.
//

#import "DKURLConnectionDelegateProxy.h"
#import "DKNetworkObserver.h"

@interface DKURLConnectionDelegateProxy ()

@property (nonatomic, weak) id originDelegate;
@property (nonatomic, weak) DKNetworkObserver *observer;

@end

@implementation DKURLConnectionDelegateProxy

- (instancetype)initWithOriginDelegate:(nullable id)originDelegate observer:(DKNetworkObserver *)observer
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

#pragma mark - NSURLConnectionDelegate, NSURLConnectionDataDelegate -

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.observer connectionDidFinishLoading:connection delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        [self.originDelegate connectionDidFinishLoading:connection];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    [self.observer connection:connection willSendRequest:request redirectResponse:response delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(connection:willSendRequest:redirectResponse:)]) {
        NSURLRequest *result = [self.originDelegate connection:connection willSendRequest:request redirectResponse:response];
        return result;
    }
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.observer connection:connection didReceiveResponse:response delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [self.originDelegate connection:connection didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.observer connection:connection didReceiveData:data delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [self.originDelegate connection:connection didReceiveData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(nonnull NSError *)error
{
    [self.observer connection:connection didFailWithError:error delegate:self.originDelegate];
    
    if ([self.originDelegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        [self.originDelegate connection:connection didFailWithError:error];
    }
}

@end
