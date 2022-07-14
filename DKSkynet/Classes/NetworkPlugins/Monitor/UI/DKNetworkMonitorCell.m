//
//  DKNetworkMonitorCell.m
//  DKSkynet
//
//  Created by admin on 2022/7/6.
//

#import "DKNetworkMonitorCell.h"
#import "DKNetworkTransaction.h"
#import <DKKit/DKKit.h>
#import <DKSkynet/DKSkynetNetworkUtil.h>

NSString * const kDKNetworkMonitorCellIdentifier = @"DKNetworkMonitorCellIdentifier";

@interface DKNetworkMonitorCell ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *pathLabel;
@property (nonatomic, weak) UILabel *detailLabel;

@end

@implementation DKNetworkMonitorCell

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
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *pathLabel = [[UILabel alloc] init];
    pathLabel.font = [UIFont systemFontOfSize:12];
    pathLabel.textColor = [UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f];
    [self.contentView addSubview:pathLabel];
    self.pathLabel = pathLabel;
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:detailLabel];
    self.detailLabel = detailLabel;
}

- (void)setTransaction:(DKNetworkTransaction *)transaction
{
    if (_transaction != transaction) {
        _transaction = transaction;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect safeArea = self.bounds;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3
    if (@available(iOS 11, *)) {
        safeArea = UIEdgeInsetsInsetRect(self.bounds, self.safeAreaInsets);
    }
#endif
    CGFloat maxX = CGRectGetMaxX(safeArea);
    
    const CGFloat left = 10.f;
    const CGFloat top = 10.f;
    const CGFloat availableTextWidth = CGRectGetWidth(self.contentView.frame) - (maxX - CGRectGetMaxX(self.contentView.frame));
    const CGFloat height = 14.f;
    const CGFloat secondHeight = 12.f;
    const CGFloat lineSpacing = 8.f;
    
    self.nameLabel.text = [self nameLabelText];
    self.nameLabel.frame = CGRectMake(left, top, availableTextWidth, height);
    self.nameLabel.width = availableTextWidth;
    
    CGFloat posY = top + height + lineSpacing;
    self.pathLabel.text = [self pathLabelText];
    self.pathLabel.frame = CGRectMake(left, posY, availableTextWidth, secondHeight);
    
    posY += secondHeight + lineSpacing;
    self.detailLabel.attributedText = [self detailLabelAttributedText];
    self.detailLabel.frame = CGRectMake(left, posY, availableTextWidth, secondHeight);
}

- (NSString *)nameLabelText
{
    NSURL *url = self.transaction.request.URL;
    NSString *name = [NSString stringWithFormat:@"%@", [url lastPathComponent]];
    if ([name length] == 0) {
        name = @"/";
    }
    NSString *query = [url query];
    if (query) {
        name = [name stringByAppendingFormat:@"?%@", query];
    }
    return name;
}

- (NSString *)pathLabelText
{
    NSURL *url = self.transaction.request.URL;
    NSMutableArray *mutablePathComponents = [[url pathComponents] mutableCopy];
    if ([mutablePathComponents count] > 0) {
        [mutablePathComponents removeLastObject];
    }
    NSString *path = [url host];
    for (NSString *pathComponent in mutablePathComponents) {
        path = [path stringByAppendingPathComponent:pathComponent];
    }
    return path;
}

- (NSAttributedString *)detailLabelAttributedText
{
    NSMutableAttributedString *detail = [[NSMutableAttributedString alloc] init];
    UIFont *font = [UIFont systemFontOfSize:12.f];
    
    NSAttributedString *responseStatusCode;
    UIColor *statusCodeColor = [UIColor colorWithRed:0.11 green:0.76 blue:0.13 alpha:1];
    if (self.transaction.error) {
        statusCodeColor = [UIColor colorWithRed:0.96 green:0.15 blue:0.11 alpha:1];
    }
    
    if (self.transaction.transactionState == DKNetworkTransactionStateFinished || self.transaction.transactionState == DKNetworkTransactionStateFailed) {
        NSString *statusCodeString = [DKSkynetNetworkUtil statusCodeStringFromURLResponse:self.transaction.response];
        if (statusCodeString) {
            responseStatusCode = [[NSAttributedString alloc] initWithString:statusCodeString attributes:@{
                NSFontAttributeName : font,
                NSForegroundColorAttributeName : statusCodeColor
            }];
        }
    } else {
        UIColor *stateColor = [UIColor colorWithWhite:0.0667 alpha:1];
        NSString *state = [DKNetworkTransaction readableStringFromTransactionState:self.transaction.transactionState];
        if (state) {
            responseStatusCode = [[NSAttributedString alloc] initWithString:state attributes:@{
                NSFontAttributeName : font,
                NSForegroundColorAttributeName : stateColor
            }];
        }
    }
    
    NSString *httpMethod = self.transaction.request.HTTPMethod;
    NSAttributedString *requestDetail = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  %@(%@)", httpMethod ?: @"", [self.transaction.startTime dk_beforeCurrentTimeNow], [self.transaction.startTime dk_stringWithFormat:self.dataFormatter]] attributes:@{
        NSFontAttributeName : font,
        NSForegroundColorAttributeName : [UIColor colorWithWhite:0.0667 alpha:1]
    }];
    
    [detail appendAttributedString:responseStatusCode];
    [detail appendAttributedString:requestDetail];
    
    return detail;
}

- (NSString *)dataFormatter
{
    return @"yyyy-MM-dd HH:mm:ss";
}

+ (CGFloat)preferredCellHeight {
    return 76.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
