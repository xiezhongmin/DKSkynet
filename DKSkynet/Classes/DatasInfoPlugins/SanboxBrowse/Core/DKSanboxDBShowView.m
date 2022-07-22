//
//  DKSanboxDBShowView.m
//  DKSkynet
//
//  Created by admin on 2022/7/22.
//

#import "DKSanboxDBShowView.h"
#import "UIColor+DKSanbox.h"
#import <DKKit/UIView+DKUtils.h>

@interface DKSanboxDBShowView ()

@property (nonatomic, weak) UITextView *displayTextView;

@end

@implementation DKSanboxDBShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    UITextView *displayTextView = [[UITextView alloc] init];
    displayTextView.font = [UIFont systemFontOfSize:16.0];
    displayTextView.editable = NO;
    displayTextView.textAlignment = NSTextAlignmentCenter;
    displayTextView.backgroundColor = [UIColor dk_sanbox_black_2];
    displayTextView.minimumZoomScale = 0.8;
    displayTextView.maximumZoomScale = 1.5;
    displayTextView.bouncesZoom = YES;
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        displayTextView.textColor = [UIColor labelColor];
    }
#endif
    [self addSubview:displayTextView];
    _displayTextView = displayTextView;
}

- (void)showText:(NSString *)text
{
    _displayTextView.frame = CGRectMake(self.width/2 - 150/2, self.height/2 - 100/2, 150, 100);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.displayTextView.frame = CGRectMake(self.width/2 - 300/2, self.height/2 - 200/2, 300, 200);
    } completion:^(BOOL finished) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.displayTextView.text = text;
    }];
}

@end
