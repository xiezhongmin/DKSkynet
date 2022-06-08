//
//  UITextField+Placeholder.h
//  yogo
//
//  Created by duke on 2020/5/15.
//  Copyright © 2020 LuBan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITextField (DKPlaceholder)

@property (nonatomic, strong, setter=dk_setPlaceholderColor:) UIColor *dk_placeholderColor;

@property (nonatomic, strong, setter=dk_setPlaceholderFont:) UIFont *dk_placeholderFont;

@end

