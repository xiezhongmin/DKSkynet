//
//  YGStringUtils.m
//  yogo
//
//  Created by admin on 2020/5/27.
//  Copyright © 2020 LuBan. All rights reserved.
//

#import "DKStringUtils.h"

@implementation DKStringUtils

+ (BOOL)dk_isEmpty:(NSString *)aStr
{
    if (aStr == nil || ![aStr isKindOfClass:NSString.class] || aStr.length == 0 || [aStr isEqualToString:@""] || ([[aStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)) {
        return YES;
    }
    return NO;
}

// 判断是否包含空格
+ (BOOL)dk_haveBlank:(NSString *)aStr
{
    NSRange _range = [aStr rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        return YES;
    } else {
        //没有空格
        return NO;
    }
}

// 判断手机号码格式
+ (BOOL)dk_checkMobileNumber:(NSString *)aStr
{
    if (aStr == nil) {
        return NO;
    }
    NSString * mobileFormat = [NSString stringWithFormat:@"^1[0-9]\\d{9}$"];
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileFormat];
    if ([regexMobile evaluateWithObject:aStr]) {
        return YES;
    } else {
        return NO;
    }
}

// 检查身份证
+ (BOOL)dk_checkIDCard:(NSString *)idCard
{
    BOOL flag;
    if (idCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:idCard];
}

// 判断邮箱格式
+ (BOOL)dk_checkEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 是否包含中文字符
+ (BOOL)dk_isContainChineseCharacter:(NSString *)aStr
{
    for (int i = 0; i < [aStr length]; i++)
    {
        unichar char_nick = [aStr characterAtIndex:i];
        
        ///Unicode --char 值处于区间[19968, 19968+20902]里的，都是汉字
        if((char_nick >= 19968 && char_nick <= 19968+20902))
        {
            return YES;
        }
    }
    return NO;
}

// 是否全部都是中文字符
+ (BOOL)dk_isAllChinese:(NSString *)aStr
{
    BOOL isChinese = NO;
    for (int i = 0; i < [aStr length]; i++){
        int a = [aStr characterAtIndex:i];
        if( a >= 0x4e00 && a <= 0x9fa5){
            isChinese = YES;
        }else{
            return NO;
        }
    }
    return isChinese;
}

// 是否全部是数字
+ (BOOL)dk_isAllNumber:(NSString *)aStr
{
    NSString *emailRegex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:aStr];
}

/// 字符串中是否包含表情 (unicode v10.0  https://zh.wikipedia.org/wiki/%E7%B9%AA%E6%96%87%E5%AD%97)
+ (BOOL)dk_containsEmoji:(NSString *)string
{
    if (![string isKindOfClass:[NSString class]] || string.length <= 0) {
        return NO;
    }
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f9ef) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3 || ls == 0xfe0f) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        if (0x278b <= hs && hs <= 0x2792) {
                                            returnValue = NO;;
                                        }else if (0x263b == hs) {
                                            returnValue = NO;;
                                        }else {
                                            returnValue = YES;
                                        }
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}

// 是否是有效的名字
+ (BOOL)dk_isNameValid:(NSString *)name
{
    BOOL isValid = NO;
    
    if (name.length > 0)
    {
        for (NSInteger i = 0; i < name.length; i++)
        {
            unichar chr = [name characterAtIndex:i];
            
            if (chr < 0x80)
            { //字符
                if (chr >= 'a' && chr <= 'z')
                {
                    isValid = YES;
                }
                else if (chr >= 'A' && chr <= 'Z')
                {
                    isValid = YES;
                }
                else if (chr >= '0' && chr <= '9')
                {
                    isValid = NO;
                }
                else if (chr == '-' || chr == '_')
                {
                    isValid = YES;
                }
                else
                {
                    isValid = NO;
                }
            }
            else if (chr >= 0x4e00 && chr < 0x9fa5)
            { //中文
                isValid = YES;
            }
            else
            { //无效字符
                isValid = NO;
            }
            
            if (!isValid)
            {
                break;
            }
        }
    }
    
    return isValid;
}

+ (BOOL)dk_isOnlyNumberAndCodeAndChinese:(NSString *)aStr
{
    NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:aStr];
    return isMatch;
}

#pragma mark - Private Method -


@end
