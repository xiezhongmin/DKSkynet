//
//  DKAssistiveTouchItemView.m
//  DKSkynet
//
//  Created by admin on 2022/5/26.
//

#import "DKSkynetItemView.h"
#import "DKKit.h"
#import "UIImageView+WebCache.h"

@interface DKSkynetItemView ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation DKSkynetItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    CGFloat margin = 15;
    CGFloat width = self.width - 2 * margin;
    CGFloat height = (self.height - 3 * margin) / 5 * 4;
    UIImageView *imageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(margin, margin, width, height);
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"DKSkynet" ofType:@"bundle"]];
        NSString *bundlePath = [bundle bundlePath];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/iconfont_star", bundlePath]];
        imageView;
    });
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        CGFloat height = (self.height - 2 * margin) / 5;
        CGFloat top = self.height - height - margin;
        label.frame = CGRectMake(margin, top, width, height);
        label.textColor = [UIColor whiteColor];
        label.text = @"插件名称";
        label.adjustsFontSizeToFitWidth = true;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label;
    });
    
    self.imageView = imageView;
    self.titleLabel = titleLabel;
}

#pragma mark - API -

- (void)dealWithModuleSelected:(BOOL)isSeleted
{
    if (isSeleted) {
        self.titleLabel.textColor = DK_COLOR_HEX(0x1296db);
    } else {
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)configWithModel:(DKSkynetModuleModel *)model
{
    model.itemView = self;
    [self dealWithModuleSelected:model.isOn];
    
    if (model.isOn) {
        self.titleLabel.text = model.pluginHighLightName ? model.pluginHighLightName : model.pluginName;
        [self setImage:model.pluginHighLightImageName ? model.pluginHighLightImageName : model.pluginImageName];
    } else {
        if (model.pluginImageName) {
            [self setImage:model.pluginImageName];
        } else {
            NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"DKSkynet" ofType:@"bundle"]];
            NSString *bundlePath = [bundle bundlePath];
            self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/iconfont_star", bundlePath]];
        }
        if (model.pluginName) {
            self.titleLabel.text = model.pluginName;
        } else {
            self.titleLabel.text = @"插件";
        }
    }
}

- (void)setImage:(NSString *)aStr {
    
    if ([aStr.lowercaseString hasPrefix:@"http://"]
        || [aStr.lowercaseString hasPrefix:@"https://"]) {
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"DKSkynet" ofType:@"bundle"]];
        NSString *bundlePath = [bundle bundlePath];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:aStr] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@/iconfont_star", bundlePath]]];
    }else {
        self.imageView.image = [UIImage imageNamed:aStr];
    }
}

#pragma mark - Getter -



@end
