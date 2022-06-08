//
//  NSString+DKSize.m
//  yogo
//
//  Created by admin on 2021/10/26.
//  Copyright © 2021 LuBan. All rights reserved.
//

#import "NSString+DKSize.h"
#import "DKStringUtils.h"

@implementation NSString (DKSize)

/**
 *  @brief 计算带富文本的文字高度
 *
 *  @param font         富文本
 *  @param color        字体颜色
 *  @param lineSpacing  行间距
 *  @param width        约束宽度
 */
- (CGFloat)dk_heightWithFont:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing constrainedToWidth:(CGFloat)width
{
    CGSize textSize;
    
    // 富文本属性
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    // 字号大小
    textDict[NSFontAttributeName] = font;
    // 字体颜色
    textDict[NSForegroundColorAttributeName] = color;
    // 段落样式
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距
    CGFloat fontp = font.lineHeight - font.pointSize;
    paraStyle.lineSpacing = lineSpacing - fontp;
    // 使用文本段落样式
    textDict[NSParagraphStyleAttributeName] = paraStyle;
    
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:textDict context:nil].size;
    
    if (textSize.height - font.lineHeight <= lineSpacing &&
        [DKStringUtils dk_isContainChineseCharacter:self]) { // 只有一行内容&中文，需要减去行间距
        return ceil(textSize.height) - paraStyle.lineSpacing;
    }
    return ceil(textSize.height);
}

/**
 *  @brief 计算带富文本的文字宽度
 *
 *  @param font         富文本
 *  @param color        字体颜色
 *  @param lineSpacing  行间距
 *  @param height       约束高度
 */
- (CGFloat)dk_widthWithFont:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing constrainedToHeight:(CGFloat)height
{
    CGSize textSize;
    
    // 富文本属性
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    // 字号大小
    textDict[NSFontAttributeName] = font;
    // 字体颜色
    textDict[NSForegroundColorAttributeName] = color;
    // 段落样式
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距
    CGFloat fontp = font.lineHeight - font.pointSize;
    paraStyle.lineSpacing = lineSpacing - fontp;
    // 使用文本段落样式
    textDict[NSParagraphStyleAttributeName] = paraStyle;
    
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:textDict context:nil].size;
    if (textSize.height - font.lineHeight <= lineSpacing &&
        [DKStringUtils dk_isContainChineseCharacter:self]) { // 只有一行内容&中文，需要减去行间距
        return ceil(textSize.height) - paraStyle.lineSpacing;
    }
    return ceil(textSize.width);
}

/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)dk_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.height);
}

/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)dk_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.width);
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)dk_sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)dk_sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

@end
