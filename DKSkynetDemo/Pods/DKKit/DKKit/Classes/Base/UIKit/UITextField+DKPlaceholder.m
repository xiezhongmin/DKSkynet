//
//  UITextField+Placeholder.m
//  yogo
//
//  Created by duke on 2020/5/15.
//  Copyright © 2020 LuBan. All rights reserved.
//

#import "UITextField+DKPlaceholder.h"

@implementation UITextField (DKPlaceholder)

@dynamic dk_placeholderColor, dk_placeholderFont;

- (void)dk_setPlaceholderColor:(UIColor *)placeholderColor
{
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)dk_setPlaceholderFont:(UIFont *)placeholderFont
{
    [self setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
}

@end
