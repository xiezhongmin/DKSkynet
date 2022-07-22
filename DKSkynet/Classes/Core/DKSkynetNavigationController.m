//
//  DKATNavigationController.m
//  DKSkynet
//
//  Created by admin on 2022/5/26.
//

#import "DKSkynetNavigationController.h"
#import "XFAssistiveTouch.h"
#import "DKSkynetAssistiveTouch.h"
#import <DKKit.h>

@interface DKSkynetNavigationController ()

@end

@implementation DKSkynetNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// MARK: - Overwrite super -

- (void)timerFired {
    [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
        [self setValue:@([XFATLayoutAttributes inactiveAlpha]) forKey:@"contentAlpha"];
    }];
    [super dk_performSelectorWithArgsUseingSelectorName:@"stopTimer"];
    
    [self indent];
}

- (void)setContentAlpha:(CGFloat)contentAlpha {
    if (!self.isShow) {
        [self setValue:@(contentAlpha) forKeyPath:@"_contentAlpha"];
        [self setValue:@(contentAlpha) forKeyPath:@"_contentView.alpha"];
    }
}

- (CGPoint)makePointValid:(CGPoint)point {
    CGRect screen = [UIScreen mainScreen].bounds;
    if (point.x < [XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2) {
        point.x = [XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2;
    }
    if (point.x > CGRectGetWidth(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin]) {
        point.x = CGRectGetWidth(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin];
    }
    if (point.y < [XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2 + (DK_ISIPHONE_X ? DK_TOP_SAFE_AREA_HEIGHT  + 9 : 0)) {
        point.y = [XFATLayoutAttributes margin] + [XFATLayoutAttributes itemImageWidth] / 2 + (DK_ISIPHONE_X ? DK_TOP_SAFE_AREA_HEIGHT + 9 : 0);
    }
    if (point.y > CGRectGetHeight(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin] - DK_BOTTOM_SAFE_AREA_HEIGHT) {
        point.y = CGRectGetHeight(screen) - [XFATLayoutAttributes itemImageWidth] / 2 - [XFATLayoutAttributes margin] - DK_BOTTOM_SAFE_AREA_HEIGHT;
    }
    return point;
}

//- (void)shrink {
//    if (!self.isShow) {
//        return;
//    }
//    __block NSMutableArray <XFATViewController *> *viewControllers = [self valueForKeyPath:@"viewControllers"];
//    CGPoint contentPoint = [[self valueForKeyPath:@"contentPoint"] CGPointValue];
//    
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    [self dk_performSelectorWithArgs:@selector(beginTimer)];
//    [self dk_performSelectorWithArgs:@selector(setShow:), NO];
//#pragma clang diagnostic pop
//    
//    for (XFATItemView *item in viewControllers.lastObject.items) {
//        [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
//            item.center = contentPoint;
//            item.alpha = 0;
//        }];
//    }
//    [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
//        viewControllers.lastObject.backItem.center = contentPoint;
//        viewControllers.lastObject.backItem.alpha = 0;
//    }];
//    
//    [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
//        UIView *contentView = [self valueForKeyPath:@"contentView"];
//        UIView *effectView = [self valueForKeyPath:@"effectView"];
//        XFATItemView *contentItem = [self valueForKeyPath:@"contentItem"];
//        contentView.frame = CGRectMake(0, 0, [XFATLayoutAttributes itemImageWidth], [XFATLayoutAttributes itemImageWidth]);
//        contentView.center = contentPoint;
//        effectView.frame = contentView.bounds;
//        contentItem.alpha = 1;
//        contentItem.center = contentPoint;
//    } completion:^(BOOL finished) {
//        for (XFATViewController *viewController in self.viewControllers) {
//            [viewController.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
//            [viewController.backItem removeFromSuperview];
//        }
//        viewControllers = [NSMutableArray arrayWithObject:viewControllers.firstObject];
//    }];
//}


// MARK: - API -

- (void)indent{
    if (!self.autoIndent) {
        return;
    }
    CGRect windowRect = [[[XFAssistiveTouch sharedInstance] assistiveWindow] frame];
    BOOL isLeft = windowRect.origin.x < 5;
    BOOL isRight = windowRect.origin.x + windowRect.size.width > DK_SCREEN_WIDTH - 5 ;
    BOOL isTop = windowRect.origin.y < 5;
    BOOL isBottom = windowRect.origin.y + windowRect.size.height > DK_SCREEN_HEIGHT - 5;
    
    if (isLeft) {
        windowRect.origin.x = - windowRect.size.width / 2;
    }
    
    if (isRight) {
        windowRect.origin.x = DK_SCREEN_WIDTH - windowRect.size.width / 2;
    }
    
    if (isTop) {
        windowRect.origin.y = - windowRect.size.width / 2;
    }
    
    if (isBottom) {
        windowRect.origin.y = DK_SCREEN_HEIGHT - windowRect.size.width / 2;
    }
    
    [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
        [[[XFAssistiveTouch sharedInstance] assistiveWindow] setFrame:windowRect];
    }];
}

- (void)showWithAnimation:(BOOL)anmiated {
    if (anmiated) {
        [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
            [[[XFAssistiveTouch sharedInstance] assistiveWindow] setHidden:false];
        }];
    }else{
        [[[XFAssistiveTouch sharedInstance] assistiveWindow] setHidden:false];
    }
}

- (void)dismissWithAnimation:(BOOL)anmiated {
    if (anmiated) {
        [UIView animateWithDuration:[XFATLayoutAttributes animationDuration] animations:^{
            [[[XFAssistiveTouch sharedInstance] assistiveWindow] setHidden:true];
        }];
    }else{
        [[[XFAssistiveTouch sharedInstance] assistiveWindow] setHidden:true];
    }
}

- (BOOL)windowIsHidden {
    return [[[XFAssistiveTouch sharedInstance] assistiveWindow] isHidden];
}

- (void)spread {
    [super spread];
    [DKSkynetAssistiveTouch.shared refreshAllModuleState];
}

@end
