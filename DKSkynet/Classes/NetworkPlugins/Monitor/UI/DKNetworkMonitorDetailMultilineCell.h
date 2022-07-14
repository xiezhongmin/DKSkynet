//
//  DKNetworkMonitorDetailMultilineCell.h
//  DKSkynet
//
//  Created by admin on 2022/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kDKNetworkMonitorDetailMultilineCellIdentifier;

@interface DKNetworkMonitorDetailMultilineCell : UITableViewCell

+ (CGFloat)preferredHeightWithAttributedText:(NSAttributedString *)attributedText inTableViewWidth:(CGFloat)tableViewWidth style:(UITableViewStyle)style showsAccessory:(BOOL)showsAccessory;

@end

NS_ASSUME_NONNULL_END
