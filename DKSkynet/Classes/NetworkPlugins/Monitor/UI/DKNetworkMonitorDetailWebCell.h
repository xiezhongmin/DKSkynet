//
//  DKNetworkMonitorDetailWebCell.h
//  DKSkynet
//
//  Created by admin on 2022/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kDKNetworkMonitorDetailWebCellIdentifier;

@interface DKNetworkMonitorDetailWebCell : UITableViewCell

- (void)webViewLoadString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
