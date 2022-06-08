//
//  YGStringUtils.h
//  yogo
//
//  Created by admin on 2020/5/27.
//  Copyright © 2020 LuBan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKStringUtils : NSObject

// 判断是否为空白字符
+ (BOOL)dk_isEmpty:(NSString *)aStr;

// 判断是否包含空格
+ (BOOL)dk_haveBlank:(NSString *)aStr;

// 判断手机号码格式
+ (BOOL)dk_checkMobileNumber:(NSString *)aStr;

// 检查身份证
+ (BOOL)dk_checkIDCard:(NSString *)idCard;

// 判断邮箱格式
+ (BOOL)dk_checkEmail:(NSString *)email;

// 是否包含中文字符
+ (BOOL)dk_isContainChineseCharacter:(NSString *)aStr;

// 是否全部都是中文字符
+ (BOOL)dk_isAllChinese:(NSString *)aStr;

// 是否全部是数字
+ (BOOL)dk_isAllNumber:(NSString *)aStr;

/// 字符串中是否包含表情 (unicode v10.0  https://zh.wikipedia.org/wiki/%E7%B9%AA%E6%96%87%E5%AD%97)
+ (BOOL)dk_containsEmoji:(NSString *)string;

// 是否是有效的名字
+ (BOOL)dk_isNameValid:(NSString *)name;

// 只包含中文、字母、数字
+ (BOOL)dk_isOnlyNumberAndCodeAndChinese:(NSString *)aStr;

@end

