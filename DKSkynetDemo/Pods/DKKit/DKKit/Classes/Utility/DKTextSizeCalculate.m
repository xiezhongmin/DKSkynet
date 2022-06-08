//
//  NSString+DKSizeCalculate.m
//  DKDebugerExample
//
//  Created by admin on 2020/11/23.
//

#import "DKTextSizeCalculate.h"

@implementation DKTextSizeCalculate

+ (CGSize)dk_getSizeWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{
   CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

+ (CGSize)dk_getSizeWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

// 根据宽度求高度 content 计算的内容 width 计算的宽度 font 字体大小
+ (CGFloat)dk_getHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return ceilf(rect.size.height);
}

// 根据高度度求宽度 text 计算的内容 height 计算的高度 font 字体大小
+ (CGFloat)dk_getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    return ceilf(rect.size.width);
}

// 根据宽度求高度 content 计算的内容 width 计算的宽度 font 字体大小 lineBreak
+ (CGFloat)dk_getHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
       paragraphStyle.lineBreakMode = lineBreakMode;

    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                                            attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy}
                                               context:nil];
    return ceilf(rect.size.height);
}

// 根据高度度求宽度 text 计算的内容 height 计算的高度 font 字体大小 lineBreak
+ (CGFloat)dk_getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
       paragraphStyle.lineBreakMode = lineBreakMode;

    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                                            attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy}
                                               context:nil];
    return ceilf(rect.size.width);
}

@end
