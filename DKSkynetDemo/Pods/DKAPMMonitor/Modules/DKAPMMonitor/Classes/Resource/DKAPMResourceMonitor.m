//
//  DKAPMResourceMonitor.m
//  DKAPMMonitor
//
//  Created by admin on 2022/6/1.
//

#import "DKAPMResourceMonitor.h"
#import "DKAPMCPUUsage.h"
#import "DKAPMMemoryUsage.h"

@interface DKAPMResourceMonitor ()
@property (nonatomic) dispatch_source_t globalTimer;
@end

@implementation DKAPMResourceMonitor

+ (instancetype)shared
{
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

- (void)startMonitoring:(void (^)(double cpuUsage, double memoryUsage))block
{
    [self startMonitoring:1.f block:block];
}

- (void)startMonitoring:(NSTimeInterval)timeInterval block:(void (^)(double cpuUsage, double memoryUsage))block
{
    if (timeInterval < 0) {
        NSLog(@"[DKAPMMonitor] - ERROR: timeInterval < 0");
        return;
    }
    if (!block) {
        NSLog(@"[DKAPMMonitor] - ERROR: block is nil");
        return;
    }
    
    if (_globalTimer != NULL) { dispatch_source_cancel(_globalTimer); }
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_queue_t queue = dispatch_queue_create("monitor.resource.queue", attr);
    _globalTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_globalTimer, DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_globalTimer, ^{
        block(DKAPMCPUUsage.currentUsage, DKAPMMemoryUsage.currentUsage);
    });
    dispatch_resume(_globalTimer);
}

- (void)stopMonitoring
{
    if (_globalTimer != NULL) {
        dispatch_source_cancel(_globalTimer);
        _globalTimer = NULL;
    }
}

@end
