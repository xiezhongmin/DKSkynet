//
//  DKSanboxDBCell.m
//  DKSkynet
//
//  Created by admin on 2022/7/22.
//

#import "DKSanboxDBCell.h"

NSString * const kDKSanboxDBCellIdentifier = @"DKSanboxDBCellIdentifier";
@interface DKSanboxDBCell ()

@end

@implementation DKSanboxDBCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        DKSanboxDBRowView *rowView = [[DKSanboxDBRowView alloc] init];
        [self.contentView addSubview:rowView];
        self.rowView = rowView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.rowView.frame = self.contentView.bounds;
}

- (void)renderCellWithArray:(NSArray *)array
{
    self.rowView.dataArray = array;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
