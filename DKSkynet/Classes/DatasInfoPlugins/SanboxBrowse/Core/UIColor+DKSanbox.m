//
//  UIColor+DKSanbox.m
//  DKSkynet
//
//  Created by admin on 2022/7/20.
//

#import "UIColor+DKSanbox.h"
#import <DKKit/UIColor+DKUtils.h>

@implementation UIColor (DKSanbox)

+ (UIColor *)dk_sanbox_black_1 // #333333
{
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor dk_colorWithHexString:@"#333333"];
            } else {
                return [UIColor dk_colorWithHexString:@"#DDDDDD"];
            }
        }];
    }
#endif
    return [UIColor dk_colorWithHexString:@"#333333"];
}

+ (UIColor *)dk_sanbox_black_2 // #333333
{
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor dk_colorWithHexString:@"#666666"];
            } else {
                return [UIColor dk_colorWithHexString:@"#AAAAAA"];
            }
        }];
    }
#endif
    return [UIColor dk_colorWithHexString:@"#666666"];
}

@end
