//
//  DKSkynetNetworkMontitorPlugin.m
//  DKSkynet
//
//  Created by admin on 2022/7/5.
//

#import "DKSkynetNetworkMonitorPlugin.h"
#import "DKNetworkMonitorViewController.h"
#import <DKSkynetPlugin.h>
#import <DKSkynetAssistiveTouch.h>
#import <DKKit/DKKit.h>
#import "DKNetworkRecorder.h"
#import "DKNetworkMonitor.h"
#import "DKNetworkRecordsStorage.h"
#import <DKSkynet/DKSkynetStorage.h>

@interface DKSkynetNetworkMonitorPlugin () <DKNetworkRecorderDelegate>

@property (nonatomic, weak) DKNetworkMonitorViewController *viewController;

@end

@implementation DKSkynetNetworkMonitorPlugin DK_SKYNET_DYNAMIC_REGISTER

- (void)dealloc
{
    NSLog(@"DKSkynetNetworkMonitorPlugin - dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[DKNetworkRecorder defaultRecorder] addDelegate:self];
        [[DKNetworkMonitor shared] start];
    }
    return self;
}

#pragma mark - Plugin -

+ (NSString *)pluginId
{
    return @"network-monitor";
}

+ (NSString *)superPluginId
{
    return @"networks";
}

+ (NSString *)pluginName
{
    return @"网络监控";
}

+ (NSString *)pluginImageName
{
    return @"DKSkynet.bundle/skynet_net_monitor";
}

- (void)pluginDidStart:(BOOL *)isHightLight
{
    if (!_viewController) {
        DKNetworkMonitorViewController *viewController = [[DKNetworkMonitorViewController alloc] init];
        [[DKSkynetAssistiveTouch shared] presentViewController:viewController hasWrapNavigationController:YES animated:YES completion:nil];
        _viewController = viewController;
    } else {
        [_viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)pluginDidStop
{
    [[DKNetworkRecorder defaultRecorder] removeDelegate:self];
    [[DKNetworkMonitor shared] stop];
    if (_viewController) {
        [_viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - DKNetworkRecorderDelegate -

- (void)recorderNewTransaction:(DKNetworkTransaction *)transaction
{
    // do nothing
}

- (void)recorderTransactionUpdated:(DKNetworkTransaction *)transaction currentState:(DKNetworkTransactionState)state
{
    // 获取缓存的状态, 而不是最新的 transaction.transactionState 状态(在通知过程中可能已变更), 避免重入
    if (state != DKNetworkTransactionStateFailed && state != DKNetworkTransactionStateFinished)
        return;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [[DKNetworkRecordsStorage shared] storeNetworkTransaction:transaction];

        // simply limit the cache
//        static NSTimeInterval preTrimTime = 0;
//        static NSInteger i = 0;
//        NSTimeInterval currentTime = CFAbsoluteTimeGetCurrent();
//        if (i++ % 20 == 0 || currentTime - preTrimTime > 20) {
//            [DKNetworkRecordsStorage trimCurrentSessionLargeRecordsToCost:[MTHawkeyeUserDefaults shared].networkCacheLimitInMB];
//            preTrimTime = currentTime;
//        }
    });
}

@end
