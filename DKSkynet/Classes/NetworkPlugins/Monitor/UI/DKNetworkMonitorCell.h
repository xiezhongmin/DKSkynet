//
//  DKNetworkMonitorCell.h
//  DKSkynet
//
//  Created by admin on 2022/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kDKNetworkMonitorCellIdentifier;

@class DKNetworkTransaction;

@interface DKNetworkMonitorCell : UITableViewCell

@property (nonatomic, strong) DKNetworkTransaction *transaction;

+ (CGFloat)preferredCellHeight;

@end

NS_ASSUME_NONNULL_END
