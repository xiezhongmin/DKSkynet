//
//  DKAPMFPSMonitor.m
//  DKAPMMonitor
//
//  Created by admin on 2022/6/1.
//

#import "DKAPMFPSMonitor.h"
#import <DKKit/DKWeakProxy.h>

@interface DKAPMFPSMonitor ()
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, copy) void (^displayLinkBlock)(int fps);
@end

@implementation DKAPMFPSMonitor

+ (instancetype)shared
{
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (void)startMonitoring:(void (^)(int fps))block
{
    if (!block) {
        NSLog(@"[DKAPMMonitor] - ERROR: block is nil");
        return;
    }
    
    if (_displayLink) { [_displayLink invalidate]; }
    _displayLinkBlock = block;
    _displayLink = [CADisplayLink displayLinkWithTarget:[DKWeakProxy proxyWithTarget:self] selector:@selector(monitor:)];
    [_displayLink addToRunLoop: [NSRunLoop mainRunLoop] forMode: NSRunLoopCommonModes];
    _lastTime = _displayLink.timestamp;
    if (@available(iOS 10.0, *)) {
        _displayLink.preferredFramesPerSecond = 60;
    } else {
        // Fallback on earlier versions
        _displayLink.frameInterval = 1;
    }
}

- (void)stopMonitoring
{
    [_displayLink invalidate];
    _displayLink = nil;
    _displayLinkBlock = nil;
}


#pragma mark - displayLink -

- (void)monitor: (CADisplayLink *)link {
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) { return; }
    _lastTime = link.timestamp;
    
    double fps = _count / delta;
    _count = 0;
    if (_displayLinkBlock) {
        _displayLinkBlock((int)round(fps));
    }
}

@end
