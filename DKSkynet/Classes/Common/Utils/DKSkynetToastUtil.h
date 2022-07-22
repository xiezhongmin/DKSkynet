//
//  DKSkynetToastUtil.h
//  DKSkynet
//
//  Created by admin on 2022/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DKSkynetToastUtil : NSObject

+ (void)showToast:(NSString *)text inView:(UIView *)superView;
+ (void)showToastBlack:(NSString *)text inView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
