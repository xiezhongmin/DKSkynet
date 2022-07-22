//
//  DKSkynetToastUtil.m
//  DKSkynet
//
//  Created by admin on 2022/7/22.
//

#import "DKSkynetToastUtil.h"
#import <DKKit/DKKitMacro.h>
#import <DKKit/UIView+DKUtils.h>

@implementation DKSkynetToastUtil

+ (void)showToast:(NSString *)text inView:(UIView *)superView
{
    if (superView == nil) {
        return;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:DK_SCALE_SIZE_FROM375_IF_LANDSCAPE(14)];
    label.text = text;
    [label sizeToFit];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        label.textColor = [UIColor labelColor];
    } else {
#endif
        label.textColor = [UIColor blackColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    }
#endif
    label.frame = CGRectMake(superView.width/2 - label.width/2, superView.height/2 - label.height/2, label.width, label.height);
    [superView addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}

+ (void)showToastBlack:(NSString *)text inView:(UIView *)superView
{
    if (!superView) {
        return;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:DK_SCALE_SIZE_FROM375_IF_LANDSCAPE(14)];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = DK_SCALE_SIZE_FROM375_IF_LANDSCAPE(4);
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(superView.width - 50, CGFLOAT_MAX)];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.68];
    CGFloat padding = DK_SCALE_SIZE_FROM375_IF_LANDSCAPE(6);
    label.frame = CGRectMake(superView.width/2 - size.width/2 - padding, superView.height/2 - size.height/2 - padding, size.width + padding * 2, size.height + padding * 2);
    label.layer.cornerRadius = DK_SCALE_SIZE_FROM375_IF_LANDSCAPE(5);
    [label.layer setMasksToBounds:YES];
    label.textColor = [UIColor whiteColor];
    [superView addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}

@end
