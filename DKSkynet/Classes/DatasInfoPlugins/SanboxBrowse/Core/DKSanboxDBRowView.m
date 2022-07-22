//
//  DKSanboxDBRowView.m
//  DKSkynet
//
//  Created by admin on 2022/7/22.
//

#import "DKSanboxDBRowView.h"
#import <DKKit/DKKit.h>
#import "UIColor+DKSanbox.h"

@implementation DKSanboxDBRowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        NSString *content = self.dataArray[i];
        UILabel *label = [[UILabel alloc] init];
        UIColor *color = [UIColor dk_colorWithHexString:@"#dcdcdc"];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            color = [UIColor dk_sanbox_black_2];
            if (self.type == DKSanboxDBRowViewTypeOne) {
                color = [UIColor secondarySystemBackgroundColor];
            }
            if (self.type == DKSanboxDBRowViewTypeTwo) {
                color = [UIColor tertiarySystemBackgroundColor];
            }
        } else {
#endif
            if (self.type == DKSanboxDBRowViewTypeOne) {
                color = [UIColor dk_colorWithHexString:@"#e6e6e6"];
            }
            if (self.type == DKSanboxDBRowViewTypeTwo) {
                color = [UIColor dk_colorWithHexString:@"#ebebeb"];
            }
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        }
#endif
        label.backgroundColor = color;
        label.text = content;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = i;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)]];
        [self addSubview:label];
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:UILabel.class]) {
            CGFloat width = (self.bounds.size.width - (self.dataArray.count - 1)) / self.dataArray.count;
            subView.frame = CGRectMake(subView.tag * (width + 1), 0, width, self.bounds.size.height);
        }
    }
}

- (void)tapLabel:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    if ([self.delegate respondsToSelector:@selector(rowView:didLabelTaped:)]) {
        [self.delegate rowView:self didLabelTaped:label];
    }
}

@end
