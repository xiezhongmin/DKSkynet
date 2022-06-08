//
//  NSString+DKSize.h
//  yogo
//
//  Created by admin on 2021/10/26.
//  Copyright © 2021 LuBan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (DKSize)

/**
 *  @brief 计算带富文本的文字高度
 *
 *  @param font         富文本
 *  @param color        字体颜色
 *  @param lineSpacing  行间距
 *  @param width        约束宽度
 */
- (CGFloat)dk_heightWithFont:(UIFont *)font
                       color:(UIColor *)color
                 lineSpacing:(CGFloat)lineSpacing
          constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算带富文本的文字宽度
 *
 *  @param font         富文本
 *  @param color        字体颜色
 *  @param lineSpacing  行间距
 *  @param height       约束高度
 */
- (CGFloat)dk_widthWithFont:(UIFont *)font
                      color:(UIColor *)color
                lineSpacing:(CGFloat)lineSpacing
        constrainedToHeight:(CGFloat)height;
/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)dk_heightWithFont:(UIFont *)font
          constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)dk_widthWithFont:(UIFont *)font
        constrainedToHeight:(CGFloat)height;

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)dk_sizeWithFont:(UIFont *)font
       constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)dk_sizeWithFont:(UIFont *)font
      constrainedToHeight:(CGFloat)height;

@end
