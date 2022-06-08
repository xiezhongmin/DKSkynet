//
//  NSAttributedString+YGLineSpacing.h
//  yogo
//
//  Created by admin on 2020/10/28.
//  Copyright © 2020 LuBan. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *       Example:
 *
 *       NSString *highlight = [NSString stringWithFormat:@"%02lds", (long)residue];
 *       NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"倒计时%@秒", highlight]];
 *       attributedString.dk_highlightText = highlight;
 *       attributedString.dk_highlightCocor = [UIColor redColor];
 *       attributedString.dk_highlightFont = [UIFont systemFontOfSize:20];
 *       self.textLabel.attributedText = attributedString.dk_context;
 */

@interface NSAttributedString (DKAttributed)

// 富文本
@property (nonatomic, strong, readonly) NSMutableAttributedString    *dk_context;

// 原始类型
@property (nonatomic, strong, setter=dk_setColor:) UIColor           *dk_color;
@property (nonatomic, strong, setter=dk_setFont:)  UIFont            *dk_font;

// 富文本参数
@property (nonatomic, assign, setter=dk_setLineSpacing:) CGFloat      dk_lineSpacing;
@property (nonatomic, assign, setter=dk_setHighlightRange:) NSRange   dk_highlightRange;
@property (nonatomic, copy,   setter=dk_setHighlightText:) NSString  *dk_highlightText;
@property (nonatomic, strong, setter=dk_setHighlightCocor:) UIColor  *dk_highlightCocor;
@property (nonatomic, strong, setter=dk_setHighlightFont:) UIFont    *dk_highlightFont;

@end

