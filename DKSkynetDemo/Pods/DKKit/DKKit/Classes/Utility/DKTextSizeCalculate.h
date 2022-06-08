//
//  NSString+DKSizeCalculate.h
//  DKDebugerExample
//
//  Created by admin on 2020/11/23.
//

#import <UIKit/UIKit.h>

@interface DKTextSizeCalculate : NSObject

// 根据宽度求高度 content 计算的内容 width 计算 size
+ (CGSize)dk_getSizeWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;

// 根据宽度求高度 content 计算的内容 width 计算 size lineBreakMode
+ (CGSize)dk_getSizeWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode;

// 根据宽度求高度 content 计算的内容 width 计算的宽度 font 字体大小
+ (CGFloat)dk_getHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;

// 根据高度度求宽度 text 计算的内容 height 计算的高度 font 字体大小
+ (CGFloat)dk_getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font;

// 根据宽度求高度 content 计算的内容 width 计算的宽度 font 字体大小 lineBreak
+ (CGFloat)dk_getHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode;

// 根据高度度求宽度 text 计算的内容 height 计算的高度 font 字体大小 lineBreak
+ (CGFloat)dk_getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font lineBreak:(NSLineBreakMode)lineBreakMode;

@end

