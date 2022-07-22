//
//  DKSanboxDBCell.h
//  DKSkynet
//
//  Created by admin on 2022/7/22.
//

#import <UIKit/UIKit.h>
#import "DKSanboxDBRowView.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kDKSanboxDBCellIdentifier;

@interface DKSanboxDBCell : UITableViewCell

@property (nonatomic, weak) DKSanboxDBRowView *rowView;

- (void)renderCellWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
