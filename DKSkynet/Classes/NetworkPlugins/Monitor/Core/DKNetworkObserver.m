//
//  DKNetworkObserver.m
//  DKSkynet
//
//  Created by admin on 2022/6/14.
//

#import "DKNetworkObserver.h"
#import <DKKit/DKMethodsHooking.h>
#import "DKURLConnectionDelegateProxy.h"
#import "DKURLSessionDelegateProxy.h"
#import "DKNetworkRecorder.h"
#import <DKKit/DKKitMacro.h>

typedef void (^NSURLSessionAsyncCompletion)(id fileURLOrData, NSURLResponse *response, NSError *error);

@interface DKNetworkInternalRequestState : NSObject

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, strong) NSMutableData *dataAccumulator;

@end

@implementation DKNetworkInternalRequestState

@end


@interface DKNetworkObserver ()

@property (nonatomic, strong) NSMutableDictionary *requestStatesForRequestIds;
@property (nonatomic, strong) dispatch_queue_t queue;

@end


@implementation DKNetworkObserver

static BOOL _networkObserverEnabled = NO;

+ (instancetype)sharedObserver
{
    static id _sharedObserver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObserver = [[[self class] alloc] init];
    });
    return _sharedObserver;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestStatesForRequestIds = [[NSMutableDictionary alloc] init];
        self.queue = dispatch_queue_create("com.duke.skynet.network.observer", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (void)setEnabled:(BOOL)enabled
{
    _networkObserverEnabled = enabled;
    if (_networkObserverEnabled) {
        [self injectIntoAllNSURLConnectionDelegateClass];
    }
}

+ (BOOL)isEnabled
{
    return _networkObserverEnabled;
}

+ (NSString *)nextRequestId
{
    return [[NSUUID UUID] UUIDString];
}

#pragma mark - NSURLConnection & NSURLSession - Injection -

+ (void)injectIntoAllNSURLConnectionDelegateClass
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // NSURLConnection inject
        [self injectIntoNSURLConnectionCreator];
        [self injectIntoNSURLConnectionCancel];
        [self injectIntoNSURLConnectionAsynchronousClassMethod];
        [self injectIntoNSURLConnectionSynchronousClassMethod];
        
        // NSURLSession inject
        [self injectIntoNSURLSessionTaskCreator];
        [self injectIntoNSURLSessionTaskResume];
        [self injectIntoNSURLSessionAsyncDataAndDownloadTaskMethods];
        [self injectIntoNSURLSessionAsyncUploadTaskMethods];
    });
}

// MARK: - NSURLConnection Injection -

+ (void)injectIntoNSURLConnectionCreator
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DKNetworkObserver *observer = [self sharedObserver];
        Class metaClass = objc_getMetaClass(class_getName([NSURLConnection class]));
        SEL classSelector = @selector(connectionWithRequest:delegate:);
        SEL swizzledClassSelector = [DKMethodsHooking swizzledSelectorForSelector:classSelector];
        typedef NSURLConnection * (^NSURLConnectionWithRequestBlock)(Class, NSURLRequest *, id <NSURLConnectionDelegate>);
        NSURLConnectionWithRequestBlock connectionWithRequestBlock = ^NSURLConnection *(Class slf, NSURLRequest *request, id <NSURLConnectionDelegate> delegate) {
            DKURLConnectionDelegateProxy *replacedDelegate = [[DKURLConnectionDelegateProxy alloc] initWithOriginDelegate:delegate observer:observer];
            NSURLConnection *connection = ((id(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledClassSelector, request, replacedDelegate);
            return connection;
        };
        [DKMethodsHooking replaceImplementationOfKnownSelector:classSelector onClass:metaClass withBlock:connectionWithRequestBlock swizzledSelector:swizzledClassSelector];
        
        Class class = [NSURLConnection class];
        SEL initSelector = @selector(initWithRequest:delegate:);
        SEL swizzledInitSelector = [DKMethodsHooking swizzledSelectorForSelector:initSelector];
        typedef NSURLConnection * (^NSURLConnectionInitRequestBlock)(Class, NSURLRequest *, id <NSURLConnectionDelegate>);
        NSURLConnectionInitRequestBlock initRequestBlock = ^NSURLConnection *(Class slf, NSURLRequest *request, id <NSURLConnectionDelegate> delegate) {
            DKURLConnectionDelegateProxy *replacedDelegate = [[DKURLConnectionDelegateProxy alloc] initWithOriginDelegate:delegate observer:observer];
            NSURLConnection *connection = ((id(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledInitSelector, request, replacedDelegate);
            return connection;
        };
        [DKMethodsHooking replaceImplementationOfKnownSelector:initSelector onClass:class withBlock:initRequestBlock swizzledSelector:swizzledInitSelector];
        
        SEL initStartImmediatelySelector = @selector(initWithRequest:delegate:startImmediately:);
        SEL swizzledInitStartImmediatelySelector = [DKMethodsHooking swizzledSelectorForSelector:initStartImmediatelySelector];
        typedef NSURLConnection * (^NSURLConnectionInitStartImmediatelyBlock)(Class, NSURLRequest *, id <NSURLConnectionDelegate>, BOOL);
        NSURLConnectionInitStartImmediatelyBlock initStartImmediatelyBlock = ^NSURLConnection *(Class slf, NSURLRequest *request, id <NSURLConnectionDelegate> delegate, BOOL startImmediately) {
            DKURLConnectionDelegateProxy *replacedDelegate = [[DKURLConnectionDelegateProxy alloc] initWithOriginDelegate:delegate observer:observer];
            NSURLConnection *connection = ((id(*)(id, SEL, id, id, BOOL))objc_msgSend)(slf, swizzledInitStartImmediatelySelector, request, replacedDelegate, startImmediately);
            return connection;
        };
        [DKMethodsHooking replaceImplementationOfKnownSelector:initStartImmediatelySelector onClass:class withBlock:initStartImmediatelyBlock swizzledSelector:swizzledInitStartImmediatelySelector];
    });
}

+ (void)injectIntoNSURLConnectionCancel
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [NSURLConnection class];
        SEL selector = @selector(cancel);
        SEL swizzledSelector = [DKMethodsHooking swizzledSelectorForSelector:selector];;
        void (^swizzledBlock)(NSURLConnection *) = ^(NSURLConnection *slf) {
            [[DKNetworkObserver sharedObserver] connectionWillCancel:slf];
            ((void(*)(id, SEL))objc_msgSend)(slf, swizzledSelector);
        };
        
        [DKMethodsHooking replaceImplementationOfKnownSelector:selector onClass:class withBlock:swizzledBlock swizzledSelector:swizzledSelector];
    });
}

+ (void)injectIntoNSURLConnectionAsynchronousClassMethod
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getMetaClass(class_getName([NSURLConnection class]));
        SEL selector = @selector(sendAsynchronousRequest:queue:completionHandler:);
        SEL swizzledSelector = [DKMethodsHooking swizzledSelectorForSelector:selector];
        
        typedef void (^NSURLConnectionAsyncCompletion)(NSURLResponse *, NSData *, NSError *);
        typedef void (^NSURLConnectionSendAsyncRequestBlock)(Class, NSURLRequest *, NSOperationQueue *, NSURLConnectionAsyncCompletion);
        NSURLConnectionSendAsyncRequestBlock swizzledBlock = ^(Class slf, NSURLRequest *request, NSOperationQueue *queue, NSURLConnectionAsyncCompletion completion) {
            if ([DKNetworkObserver isEnabled]) {
                NSString *requestId = [self nextRequestId];
                [[DKNetworkRecorder defaultRecorder] recordRequestWillBeSentWithRequestId:requestId request:request redirectResponse:nil];
                NSString *mechanism = [self mechanismFromClassMethod:selector onClass:class];
                [[DKNetworkRecorder defaultRecorder] recordMechanism:mechanism forRequestId:requestId];
                
                NSURLConnectionAsyncCompletion completionWrapper = ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    [[DKNetworkRecorder defaultRecorder] recordDataReceivedWithRequestId:requestId dataLength:[data length]];
                    
                    // Call through to the original completion handler
                    if (completion) {
                        completion(response, data, connectionError);
                    }
                    
                    if (connectionError) {
                        [[DKNetworkRecorder defaultRecorder] recordLoadingFailedWithRequestId:requestId error:connectionError];
                    } else {
                        [[DKNetworkRecorder defaultRecorder] recordLoadingFinishedWithRequestId:requestId responseBody:data];
                    }
                };
                
                ((void(*)(id, SEL, id, id, id)) objc_msgSend)(slf, swizzledSelector, request, queue, completionWrapper);
            } else {
                ((void(*)(id, SEL, id, id, id)) objc_msgSend)(slf, swizzledSelector, request, queue, completion);
            }
        };
        
        [DKMethodsHooking replaceImplementationOfKnownSelector:selector onClass:class withBlock:swizzledBlock swizzledSelector:swizzledSelector];
    });
}

+ (void)injectIntoNSURLConnectionSynchronousClassMethod
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getMetaClass(class_getName([NSURLConnection class]));
        SEL selector = @selector(sendSynchronousRequest:returningResponse:error:);
        SEL swizzledSelector = [DKMethodsHooking swizzledSelectorForSelector:selector];
        
        typedef NSData * (^NSURLConnectionSendSyncRequestBlock)(Class, NSURLRequest *, NSURLResponse **, NSError **);
        NSURLConnectionSendSyncRequestBlock swizzledBlock = ^NSData *(Class slf, NSURLRequest *request, NSURLResponse **response, NSError **error) {
            NSData *data = nil;
            if ([DKNetworkObserver isEnabled]) {
                NSString *requestId = [self nextRequestId];
                [[DKNetworkRecorder defaultRecorder] recordRequestWillBeSentWithRequestId:requestId request:request redirectResponse:nil];
                NSString *mechanism = [self mechanismFromClassMethod:selector onClass:class];
                [[DKNetworkRecorder defaultRecorder] recordMechanism:mechanism forRequestId:requestId];
                
                NSError *temporaryError = nil;
                NSURLResponse *temporaryResponse = nil;
                data = ((id(*)(id, SEL, id, NSURLResponse **, NSError **))objc_msgSend)(slf, swizzledSelector, request, &temporaryResponse, &temporaryError);
                [[DKNetworkRecorder defaultRecorder] recordResponseReceivedWithRequestId:requestId response:temporaryResponse];
                [[DKNetworkRecorder defaultRecorder] recordDataReceivedWithRequestId:requestId dataLength:[data length]];
                if (temporaryError) {
                    [[DKNetworkRecorder defaultRecorder] recordLoadingFailedWithRequestId:requestId error:temporaryError];
                } else {
                    [[DKNetworkRecorder defaultRecorder] recordLoadingFinishedWithRequestId:requestId responseBody:data];
                }
                if (error) {
                    *error = temporaryError;
                }
                if (response) {
                    *response = temporaryResponse;
                }
            } else {
                data = ((id(*)(id, SEL, id, NSURLResponse **, NSError **))objc_msgSend)(slf, swizzledSelector, request, response, error);
            }
            
            return data;
        };
        
        [DKMethodsHooking replaceImplementationOfKnownSelector:selector onClass:class withBlock:swizzledBlock swizzledSelector:swizzledSelector];
    });
}

// MARK: - NSURLSession Injection -

+ (void)injectIntoNSURLSessionTaskCreator
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DKNetworkObserver *observer = [DKNetworkObserver sharedObserver];
        Class class = objc_getMetaClass(class_getName([NSURLSession class]));
        SEL selector = @selector(sessionWithConfiguration:delegate:delegateQueue:);
        SEL swizzledSelector = [DKMethodsHooking swizzledSelectorForSelector:selector];
        
        typedef NSURLSession * (^NSURLSessionCreatorBlock)(Class, NSURLSessionConfiguration *, id <NSURLSessionDelegate>, NSOperationQueue *);
        NSURLSessionCreatorBlock swizzledBlock = ^NSURLSession *(Class slf, NSURLSessionConfiguration *configuration, id <NSURLSessionDelegate> delegate, NSOperationQueue *queue) {
            DKURLSessionDelegateProxy *replacedDelegate = [[DKURLSessionDelegateProxy alloc] initWithOriginDelegate:delegate observer:observer];
            NSURLSession *session = ((id(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, configuration, replacedDelegate, queue);
            return session;
        };
        
        [DKMethodsHooking replaceImplementationOfKnownSelector:selector onClass:class withBlock:swizzledBlock swizzledSelector:swizzledSelector];
    });
}

+ (void)injectIntoNSURLSessionTaskResume
{
    /* Reference AFNetworking for NSURLSessionTask swizzle resume
     The current solution:
     1) Grab an instance of `__NSCFLocalDataTask` by asking an instance of `NSURLSession` for a data task.
     2) Grab a pointer to the original implementation of `resume`
     3) Check to see if the current class has an implementation of resume. If so, continue to step 4.
     4) Grab the super class of the current class.
     5) Grab a pointer for the current class to the current implementation of `resume`.
     6) Grab a pointer for the super class to the current implementation of `resume`.
     7) If the current class implementation of `resume` is not equal to the super class implementation of `resume` AND the current implementation of `resume` is not equal to the original implementation of `af_resume`, THEN swizzle the methods
     8) Set the current class to the super class, and repeat steps 3-8
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (NSClassFromString(@"NSURLSessionTask")) {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
            NSURLSessionDataTask *localDataTask = [session dataTaskWithURL:nil];
#pragma clang diagnostic pop
            Class currentClass = [localDataTask class];
            
            SEL selector = @selector(resume);
            SEL swizzledSelector = [DKMethodsHooking swizzledSelectorForSelector:selector];
            void (^swizzledResumeBlock)(NSURLSessionTask *) = ^(NSURLSessionTask *slf) {
                [[DKNetworkObserver sharedObserver] URLSessionTaskWillResume:slf];
                ((void(*)(id, SEL))objc_msgSend)(slf, swizzledSelector);
            };
            IMP swizzledResumeBlockIMP = imp_implementationWithBlock(swizzledResumeBlock);
            
            while (class_getInstanceMethod(currentClass, selector)) {
                Class superClass = [currentClass superclass];
                IMP classResumeIMP = method_getImplementation(class_getInstanceMethod(currentClass, selector));
                IMP superclassResumeIMP = method_getImplementation(class_getInstanceMethod(superClass, selector));
                
                if (classResumeIMP != superclassResumeIMP && swizzledResumeBlockIMP != classResumeIMP) {
                    Method originResume = class_getInstanceMethod(currentClass, selector);
                    if (class_addMethod(currentClass, swizzledSelector, swizzledResumeBlockIMP, method_getTypeEncoding(originResume))) {
                        Method newResume = class_getInstanceMethod(currentClass, swizzledSelector);
                        method_exchangeImplementations(originResume, newResume);
                    } else {
                        DKLogWarn(@"Failed addMethod %@ to %@ ",NSStringFromSelector(swizzledSelector), NSStringFromClass(currentClass));
                    }
                }
                currentClass = [currentClass superclass];
            }
            
            [localDataTask cancel];
            [session finishTasksAndInvalidate];
        }
    });
}

+ (void)injectIntoNSURLSessionAsyncDataAndDownloadTaskMethods
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [NSURLSession class];
        
        // The method signatures here are close enough that
        // we can use the same logic to inject into all of them.
        const SEL selectors[] = {
            @selector(dataTaskWithRequest:completionHandler:),
            @selector(dataTaskWithURL:completionHandler:),
            @selector(downloadTaskWithRequest:completionHandler:),
            @selector(downloadTaskWithResumeData:completionHandler:),
            @selector(downloadTaskWithURL:completionHandler:)
        };
        
        const int numSelectors = sizeof(selectors) / sizeof(SEL);
        for (int selectorIndex = 0; selectorIndex < numSelectors; selectorIndex++) {
            SEL selector = selectors[selectorIndex];
            SEL swizzledSelector = [DKMethodsHooking swizzledSelectorForSelector:selector];
            
            if ([DKMethodsHooking instanceRespondsButDoesNotImplementSelector:selector onClass:class]) {
                // iOS 7 does not implement these methods on NSURLSession. We actually want to
                // swizzle __NSCFURLSession, which we can get from the class of the shared session
                class = [[NSURLSession sharedSession] class];
            }
            
            typedef NSURLSessionTask * (^NSURLSessionNewTaskBlock)(Class, id, NSURLSessionAsyncCompletion);
            NSURLSessionNewTaskBlock swizzledBlock = ^NSURLSessionTask *(Class slf, id argument, NSURLSessionAsyncCompletion completion) {
                NSURLSessionTask *task = nil;
                // If completion block was not provided sender expect to receive delegated methods or does not
                // interested in callback at all. In this case we should just call original method implementation
                // with nil completion block.
                if ([DKNetworkObserver isEnabled] && completion) {
                    NSString *requestId = [self nextRequestId];
                    NSString *mechanism = [self mechanismFromClassMethod:selector onClass:class];
                    NSURLSessionAsyncCompletion completionWrapper = [self asyncCompletionWrapperForRequestId:requestId mechanism:mechanism completion:^(id fileURLOrData, NSURLResponse *response, NSError *error) {
                        // 此处预留...
                        //
                        completion(fileURLOrData, response, error);
                    }];
                    task = ((id(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, argument, completionWrapper);
                    [self setRequestId:requestId forConnectionOrTask:task];
                } else {
                    task = ((id(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, argument, completion);
                }
                
                return task;
            };
            
            [DKMethodsHooking replaceImplementationOfKnownSelector:selector onClass:class withBlock:swizzledBlock swizzledSelector:swizzledSelector];
        }
        
    });
}

+ (void)injectIntoNSURLSessionAsyncUploadTaskMethods
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [NSURLSession class];
        
        // The method signatures here are close enough that we can use the same logic to inject into both of them.
        // Note that they have 3 arguments, so we can't easily combine with the data and download method above.
        const SEL selectors[] = {
            @selector(uploadTaskWithRequest:fromData:completionHandler:),
            @selector(uploadTaskWithRequest:fromFile:completionHandler:)
        };
        
        const int numSelectors = sizeof(selectors) / sizeof(SEL);
        for (int selectorIndex = 0; selectorIndex < numSelectors; selectorIndex++) {
            SEL selector = selectors[selectorIndex];
            SEL swizzledSelector = [DKMethodsHooking swizzledSelectorForSelector:selector];
            
            if ([DKMethodsHooking instanceRespondsButDoesNotImplementSelector:selector onClass:class]) {
                // iOS 7 does not implement these methods on NSURLSession. We actually want to
                // swizzle __NSCFURLSession, which we can get from the class of the shared session
                class = [[NSURLSession sharedSession] class];
            }
            
            typedef NSURLSessionUploadTask * (^NSURLSessionUploadTaskBlock)(Class, NSURLRequest *, id, NSURLSessionAsyncCompletion);
            NSURLSessionUploadTaskBlock swizzledBlock = ^NSURLSessionUploadTask *(Class slf, NSURLRequest *request, id argument, NSURLSessionAsyncCompletion completion) {
                NSURLSessionUploadTask *task = nil;
                if ([DKNetworkObserver isEnabled]) {
                    NSString *requestId = [self nextRequestId];
                    NSString *mechanism = [self mechanismFromClassMethod:selector onClass:class];
                    NSURLSessionAsyncCompletion completionWrapper = [self asyncCompletionWrapperForRequestId:requestId mechanism:mechanism completion:^(id fileURLOrData, NSURLResponse *response, NSError *error) {
                        // 此处预留
                        //
                        completion(fileURLOrData, response, error);
                    }];
                    task = ((id(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, request, argument, completionWrapper);
                    [self setRequestId:requestId forConnectionOrTask:task];
                } else {
                    task = ((id(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, request, argument, completion);
                }
                return task;
            };
            [DKMethodsHooking replaceImplementationOfKnownSelector:selector onClass:class withBlock:swizzledBlock swizzledSelector:swizzledSelector];
        }
    });
}

#pragma mark - private methods -

- (void)performBlock:(dispatch_block_t)block
{
    if ([[self class] isEnabled]) {
        dispatch_async(_queue, block);
    }
}

- (DKNetworkInternalRequestState *)requestStateForRequestId:(NSString *)requestId
{
    DKNetworkInternalRequestState *requestState = self.requestStatesForRequestIds[requestId];
    if (!requestState) {
        requestState = [[DKNetworkInternalRequestState alloc] init];
        [self.requestStatesForRequestIds setObject:requestState forKey:requestId];
    }
    return requestState;
}

+ (NSString *)requestIdForConnectionOrTask:(id)connectionOrTask
{
    NSString *requestId = objc_getAssociatedObject(connectionOrTask, _cmd);
    if (!requestId) {
        requestId = [self nextRequestId];
        [self setRequestId:requestId forConnectionOrTask:connectionOrTask];
    }
    return requestId;
}

+ (void)setRequestId:(NSString *)requestId forConnectionOrTask:(id)connectionOrTask
{
    objc_setAssociatedObject(connectionOrTask, @selector(requestIdForConnectionOrTask:), requestId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)removeRequestStateForRequestId:(NSString *)requestId
{
    [self.requestStatesForRequestIds removeObjectForKey:requestId];
}

+ (NSString *)mechanismFromClassMethod:(SEL)selector onClass:(Class)aClass
{
    return [NSString stringWithFormat:@"+[%@ %@]", NSStringFromClass(aClass), NSStringFromSelector(selector)];
}

+ (NSURLSessionAsyncCompletion)asyncCompletionWrapperForRequestId:(NSString *)requestId mechanism:(NSString *)mechanism completion:(NSURLSessionAsyncCompletion)completion
{
    NSURLSessionAsyncCompletion completionWrapper = ^(id fileURLOrData, NSURLResponse *response, NSError *error) {
        [[DKNetworkRecorder defaultRecorder] recordMechanism:mechanism forRequestId:requestId];
        [[DKNetworkRecorder defaultRecorder] recordResponseReceivedWithRequestId:requestId response:response];
        
        NSData *data = nil;
        if ([fileURLOrData isKindOfClass:[NSURL class]]) {
            data = [NSData dataWithContentsOfURL:fileURLOrData];;
        } else if ([fileURLOrData isKindOfClass:[NSData class]]) {
            data = fileURLOrData;
        }
        
        [[DKNetworkRecorder defaultRecorder] recordDataReceivedWithRequestId:requestId dataLength:[data length]];;
        
        // Call through to the original completion handler
        if (completion) {
            completion(fileURLOrData, response, error);
        }
        
        if (error) {
            [[DKNetworkRecorder defaultRecorder] recordLoadingFailedWithRequestId:requestId error:error];
        } else {
            [[DKNetworkRecorder defaultRecorder] recordLoadingFinishedWithRequestId:requestId responseBody:data];
        }
    };
    
    return completionWrapper;
}

#pragma mark - NSURLConnectionDKHelpers -

- (void)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response delegate:(id <NSURLConnectionDelegate>)delegate
{
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:connection];
        DKNetworkInternalRequestState *requestState = [self requestStateForRequestId:requestId];
        requestState.request = request;
        
        [[DKNetworkRecorder defaultRecorder] recordRequestWillBeSentWithRequestId:requestId request:request redirectResponse:response];
        NSString *mechanism = [NSString stringWithFormat:@"NSURLConnection (delegate: %@)", [delegate class]];
        [[DKNetworkRecorder defaultRecorder] recordMechanism:mechanism forRequestId:requestId];
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response delegate:(id <NSURLConnectionDelegate>)delegate
{
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:connection];
        DKNetworkInternalRequestState *requestState = [self requestStateForRequestId:requestId];
        
        NSMutableData *dataAccumulator = nil;
        if (response.expectedContentLength < 0) {
            dataAccumulator = [[NSMutableData alloc] init];
        } else {
            dataAccumulator = [[NSMutableData alloc] initWithCapacity:response.expectedContentLength];
        }
        requestState.dataAccumulator = dataAccumulator;
        [[DKNetworkRecorder defaultRecorder] recordResponseReceivedWithRequestId:requestId response:response];
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data delegate:(id <NSURLConnectionDelegate>)delegate
{
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:connection];
        DKNetworkInternalRequestState *requestState = [self requestStateForRequestId:requestId];
        [requestState.dataAccumulator appendData:data];
        
        [[DKNetworkRecorder defaultRecorder] recordDataReceivedWithRequestId:requestId dataLength:data.length];
    }];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection delegate:(id <NSURLConnectionDelegate>)delegate
{
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:connection];
        DKNetworkInternalRequestState *requestState = [self requestStateForRequestId:requestId];
        [[DKNetworkRecorder defaultRecorder] recordLoadingFinishedWithRequestId:requestId responseBody:requestState.dataAccumulator];
        [self removeRequestStateForRequestId:requestId];
    }];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error delegate:(id<NSURLConnectionDelegate>)delegate
{
    
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:connection];
        DKNetworkInternalRequestState *requestState = [self requestStateForRequestId:requestId];
        // Cancellations can occur prior to the willSendRequest:... NSURLConnection delegate call.
        // These are pretty common and clutter up the logs. Only record the failure if the recorder already knows about the request through willSendRequest:...
        if (requestState.request) {
            [[DKNetworkRecorder defaultRecorder] recordLoadingFailedWithRequestId:requestId error:error];
        }
        
        [self removeRequestStateForRequestId:requestId];
    }];
}

- (void)connectionWillCancel:(NSURLConnection *)connection
{
    [self performBlock:^{
        // Mimic the behavior of NSURLSession which is to create an error on cancellation.
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"cancelled"};
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];
        [self connection:connection didFailWithError:error delegate:nil];
    }];
}

#pragma mark - NSURLSessionTaskDKHelpers -

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler delegate:(id <NSURLSessionDelegate>)delegate
{
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:task];
        [[DKNetworkRecorder defaultRecorder] recordRequestWillBeSentWithRequestId:requestId request:request redirectResponse:response];
    }];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler delegate:(id <NSURLSessionDelegate>)delegate
{
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:dataTask];
        DKNetworkInternalRequestState *requestState = [self requestStateForRequestId:requestId];
        
        NSMutableData *dataAccumulator = nil;
        if (response.expectedContentLength < 0) {
            dataAccumulator = [[NSMutableData alloc] init];
        } else {
            dataAccumulator = [[NSMutableData alloc] initWithCapacity:response.expectedContentLength];
        }
        requestState.dataAccumulator = dataAccumulator;
        
        NSString *mechanism = [NSString stringWithFormat:@"NSURLSessionDataTask (delegate: %@)", [delegate class]];
        [[DKNetworkRecorder defaultRecorder] recordMechanism:mechanism forRequestId:requestId];
        
        [[DKNetworkRecorder defaultRecorder] recordResponseReceivedWithRequestId:requestId response:response];
    }];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data delegate:(id <NSURLSessionDelegate>)delegate
{
    // Just to be safe since we're doing this async
    data = [data copy];
    
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:dataTask];
        DKNetworkInternalRequestState *requestState = [self requestStateForRequestId:requestId];
        [requestState.dataAccumulator appendData:data];
        [[DKNetworkRecorder defaultRecorder] recordDataReceivedWithRequestId:requestId dataLength:data.length];
    }];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask delegate:(id <NSURLSessionDelegate>)delegate
{
    [self performBlock:^{
        // By setting the request ID of the download task to match the data task,
        // it can pick up where the data task left off.
        NSString *requestId = [[self class] requestIdForConnectionOrTask:dataTask];
        [[self class] setRequestId:requestId forConnectionOrTask:dataTask];
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error delegate:(id <NSURLSessionDelegate>)delegate
{
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:task];
        if (error) {
            [[DKNetworkRecorder defaultRecorder] recordLoadingFailedWithRequestId:requestId error:error];
        } else {
            DKNetworkInternalRequestState *requestState = [self requestStateForRequestId:requestId];
            [[DKNetworkRecorder defaultRecorder] recordLoadingFinishedWithRequestId:requestId responseBody:requestState.dataAccumulator];
        }
        [self removeRequestStateForRequestId:requestId];
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics delegate:(id <NSURLSessionDelegate>)delegate
NS_AVAILABLE_IOS(10_0) {
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:task];
        [[DKNetworkRecorder defaultRecorder] recordMetricsWithRequestId:requestId metrics:metrics];
    }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite delegate:(id <NSURLSessionDelegate>)delegate
{
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:downloadTask];
        DKNetworkInternalRequestState *requestState = [self requestStateForRequestId:requestId];
        if (!requestState.dataAccumulator) {
            NSUInteger unsignedBytesExpectedToWrite = totalBytesExpectedToWrite > 0 ? (NSUInteger)totalBytesExpectedToWrite : 0;
            requestState.dataAccumulator = [[NSMutableData alloc] initWithCapacity:unsignedBytesExpectedToWrite];
            [[DKNetworkRecorder defaultRecorder] recordResponseReceivedWithRequestId:requestId response:downloadTask.response];
            NSString *mechanism = [NSString stringWithFormat:@"NSURLSessionDownloadTask (delegate: %@)", [delegate class]];
            [[DKNetworkRecorder defaultRecorder] recordMechanism:mechanism forRequestId:requestId];
        }
        
        [[DKNetworkRecorder defaultRecorder] recordDataReceivedWithRequestId:requestId dataLength:bytesWritten];
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location data:(NSData *)data delegate:(id <NSURLSessionDelegate>)delegate
{
    data = [data copy];
    
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:downloadTask];
        DKNetworkInternalRequestState *requestState = [self requestStateForRequestId:requestId];
        [requestState.dataAccumulator appendData:data];
    }];
}

- (void)URLSessionTaskWillResume:(NSURLSessionTask *)task
{
    // Since resume can be called multiple times on the same task, only treat the first resume as
    // the equivalent to connection:willSendRequest:...
    [self performBlock:^{
        NSString *requestId = [[self class] requestIdForConnectionOrTask:task];
        DKNetworkInternalRequestState *requsetState = [self requestStateForRequestId:requestId];
        if (!requsetState.request) {
            requsetState.request = task.currentRequest;
            [[DKNetworkRecorder defaultRecorder] recordRequestWillBeSentWithRequestId:requestId request:task.currentRequest redirectResponse:nil];
        }
    }];
}

@end
