//
//  NSAttributedString+DKLineSpacing.m
//  yogo
//
//  Created by admin on 2020/10/28.
//  Copyright © 2020 LuBan. All rights reserved.
//

#import "NSAttributedString+DKAttributed.h"
#import <CoreText/CoreText.h>
#import "DKKitMacro.h"
@import ObjectiveC.runtime;

@implementation NSAttributedString (DKAttributed)

@dynamic dk_lineSpacing, dk_color, dk_font;

- (void)dk_setLineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing; // 字体的行间距
    
    [self.dk_context addAttributes:@{ NSParagraphStyleAttributeName : paragraphStyle }
                          range:NSMakeRange(0, self.string.length)];
}

- (void)dk_setHighlightRange:(NSRange)highlightRange
{
    NSValue *rangeValue = [NSValue valueWithRange:highlightRange];
    objc_setAssociatedObject(self, @selector(dk_highlightRange), rangeValue, OBJC_ASSOCIATION_RETAIN);
    
    NSRange range = highlightRange;
    UIFont *attFont = self.dk_highlightFont ?: self.dk_font;
    UIColor *attColor = self.dk_highlightCocor ?: self.dk_color;
    
    if (attFont && range.length != 0) {
        [self.dk_context addAttributes:@{
            NSFontAttributeName : attFont
        } range:range];
    }
    
    if (attColor && range.length != 0) {
        [self.dk_context addAttributes:@{
            NSForegroundColorAttributeName : attColor
        } range:range];
    }
}

- (void)dk_setHighlightText:(NSString *)highlightText
{
    objc_setAssociatedObject(self, @selector(dk_highlightText), highlightText, OBJC_ASSOCIATION_RETAIN);
    
    NSRange range = [self.string rangeOfString:highlightText];
    UIFont *attFont = self.dk_highlightFont ?: self.dk_font;
    UIColor *attColor = self.dk_highlightCocor ?: self.dk_color;
    
    if (attFont && range.length != 0) {
        [self.dk_context addAttributes:@{
            NSFontAttributeName : attFont
        } range:range];
    }
    
    if (attColor && range.length != 0) {
        [self.dk_context addAttributes:@{
            NSForegroundColorAttributeName : attColor
        } range:range];
    }
}

- (void)dk_setHighlightCocor:(UIColor *)highlightCocor
{
    objc_setAssociatedObject(self, @selector(dk_highlightFont), highlightCocor, OBJC_ASSOCIATION_RETAIN);

    if (self.dk_highlightText == nil && self.dk_highlightRange.length == 0) {
        DKLogError(@"highlightText = nil or highlightRange.length = 0!");
        return;
    }
    
    NSRange range = NSMakeRange(0, 0);
    if (self.dk_highlightText) {
        range = [self.string rangeOfString:self.dk_highlightText];
    } else if (self.dk_highlightRange.length != 0) {
        range = self.dk_highlightRange;
    }
    
    UIColor *attColor = highlightCocor ?: self.dk_color;
    
    if (attColor && range.length != 0) {
        [self.dk_context addAttributes:@{
            NSForegroundColorAttributeName : attColor
        } range:range];
    }
}

- (void)dk_setHighlightFont:(UIFont *)highlightFont
{
    objc_setAssociatedObject(self, @selector(dk_highlightFont), highlightFont, OBJC_ASSOCIATION_RETAIN);
    
    if (self.dk_highlightText == nil && self.dk_highlightRange.length == 0) {
        DKLogError(@"highlightText = nil or highlightRange.length = 0!");
        return;
    }
    
    NSRange range = NSMakeRange(0, 0);
    if (self.dk_highlightText) {
        range = [self.string rangeOfString:self.dk_highlightText];
    } else if (self.dk_highlightRange.length != 0) {
        range = self.dk_highlightRange;
    }
    
    UIFont *attFont = highlightFont ?: self.dk_font;
    
    if (attFont && range.length != 0) {
        [self.dk_context addAttributes:@{
            NSFontAttributeName : attFont
        } range:range];
    }
}

- (void)dk_setFont:(UIFont *)font
{
    [self.dk_context addAttributes:@{
        NSFontAttributeName : font,
    } range:NSMakeRange(0, self.string.length)];
}

- (void)dk_setColor:(UIColor *)color
{
    [self.dk_context addAttributes:@{
        NSForegroundColorAttributeName : color,
    } range:NSMakeRange(0, self.string.length)];
}

- (UIFont *)dk_font
{
    if (self.length == 0) { return nil; }
    UIFont *font = [self attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    return font;
}

- (UIColor *)dk_color
{
    if (self.length == 0) { return nil; }
    UIColor *color = [self attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self attribute:(NSString *)kCTForegroundColorAttributeName atIndex:0 effectiveRange:NULL]);
        color = [UIColor colorWithCGColor:ref];
    }
    if (color && ![color isKindOfClass:[UIColor class]]) {
        if (CFGetTypeID((__bridge CFTypeRef)(color)) == CGColorGetTypeID()) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        } else {
            color = nil;
        }
    }
    return color;
}

- (NSMutableAttributedString *)dk_context
{
    NSMutableAttributedString *context = objc_getAssociatedObject(self, _cmd);
    if (context == nil) {
        context = [[NSMutableAttributedString alloc] initWithString:self.string ?: @""];
        objc_setAssociatedObject(self, _cmd, context, OBJC_ASSOCIATION_RETAIN);
    }
    return context;
}

- (UIColor *)dk_highlightCocor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (UIFont *)dk_highlightFont
{
    return objc_getAssociatedObject(self, _cmd);
}

- (NSString *)dk_highlightText
{
    return objc_getAssociatedObject(self, _cmd);
}

- (NSRange)dk_highlightRange
{
    return [objc_getAssociatedObject(self, _cmd) rangeValue];
}

@end
