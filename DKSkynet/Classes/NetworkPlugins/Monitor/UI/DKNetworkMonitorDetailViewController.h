//
//  DKNetworkMonitorDetailViewController.h
//  DKSkynet
//
//  Created by admin on 2022/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DKNetworkTransaction;

@interface DKNetworkMonitorDetailViewController : UITableViewController

@property (nonatomic, strong) DKNetworkTransaction *transaction;

@end

NS_ASSUME_NONNULL_END
