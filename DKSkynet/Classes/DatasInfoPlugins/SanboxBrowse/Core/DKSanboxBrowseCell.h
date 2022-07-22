//
//  DKSanboxBrowseCell.h
//  DKSkynet
//
//  Created by admin on 2022/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kDKSanboxBrowseCellIdentifier;

@class DKSandboxBrowseModel;

@interface DKSanboxBrowseCell : UITableViewCell

- (void)renderUIWithData:(DKSandboxBrowseModel *)model;

+ (CGFloat)preferredCellHeight;

@end

NS_ASSUME_NONNULL_END
