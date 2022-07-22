//
//  DKSanboxBrowseCell.m
//  DKSkynet
//
//  Created by admin on 2022/7/15.
//

#import "DKSanboxBrowseCell.h"
#import "DKSandboxBrowseModel.h"
#import <DKKit/DKKit.h>
#import "UIColor+DKSanbox.h"
#import "DKSanboxUtils.h"
#import "UIImage+DKSanbox.h"

NSString * const kDKSanboxBrowseCellIdentifier = @"DKSanboxBrowseCellIdentifier";

@interface DKSanboxBrowseCell ()

@property (nonatomic, weak) UIImageView *fileTypeIcon;
@property (nonatomic, weak) UILabel *fileTitleLabel;
@property (nonatomic, weak) UILabel *fileSizeLabel;

@end

@implementation DKSanboxBrowseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UIImageView *fileTypeIcon = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        imageView;
    });
    
    UILabel *fileTitleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:DK_SCALE_SIZE_FROM375_IF_LANDSCAPE(16)];
        label.textColor = [UIColor dk_sanbox_black_1];
        [self.contentView addSubview:label];
        label;
    });
    
    UILabel *fileSizeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:DK_SCALE_SIZE_FROM375_IF_LANDSCAPE(16)];
        label.textColor = [UIColor dk_sanbox_black_2];
        [self.contentView addSubview:label];
        label;
    });
    
    self.fileTypeIcon = fileTypeIcon;
    self.fileTitleLabel = fileTitleLabel;
    self.fileSizeLabel = fileSizeLabel;
}

- (void)renderUIWithData:(DKSandboxBrowseModel *)model
{
    NSString *iconName = nil;
    if (model.type == DKSandboxBrowseFileTypeDirectory) {
        iconName = @"dk_sanbox_dir";
    } else {
        iconName = @"dk_sanbox_file_2";
    }
  
    self.fileTypeIcon.image = [UIImage dk_xcassetImageNamed:iconName];
    [self.fileTypeIcon sizeToFit];
    self.fileTypeIcon.frame = CGRectMake(DK_SCALE_SIZE_FROM375_IF_LANDSCAPE(16), [[self class] preferredCellHeight]/2 - self.fileTypeIcon.height/2, self.fileTypeIcon.width, self.fileTypeIcon.height);
    
    self.fileTitleLabel.text = model.name;
    self.fileTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.fileTitleLabel sizeToFit];
    self.fileTitleLabel.frame = CGRectMake(self.fileTypeIcon.right + DK_SCALE_SIZE_FROM375_IF_LANDSCAPE(16), [[self class] preferredCellHeight]/2 - self.fileTitleLabel.height/2, DK_SCREEN_WIDTH - 150, self.fileTitleLabel.height);
    
    DKSanboxUtils *utils = [[DKSanboxUtils alloc] init];
    [utils getFileSizeWithPath:model.path];
    NSInteger fileSize = utils.fileSize;
    // 将文件夹大小转换为 M/KB/B
    NSString *fileSizeStr = nil;
    if (fileSize > 1024 * 1024){
        fileSizeStr = [NSString stringWithFormat:@"%.2fM", fileSize / 1024.00f /1024.00f];
        
    } else if (fileSize > 1024){
        fileSizeStr = [NSString stringWithFormat:@"%.2fKB", fileSize / 1024.00f ];
        
    } else {
        fileSizeStr = [NSString stringWithFormat:@"%.2fB", fileSize / 1.00f];
    }
    
    self.fileSizeLabel.text = fileSizeStr;
    [self.fileSizeLabel sizeToFit];
    self.fileSizeLabel.frame = CGRectMake(DK_SCREEN_WIDTH - 15 - self.fileSizeLabel.width, [[self class] preferredCellHeight]/2 - self.fileSizeLabel.height/2, self.fileSizeLabel.width, self.fileSizeLabel.height);
}

+ (CGFloat)preferredCellHeight
{
    return 48.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
