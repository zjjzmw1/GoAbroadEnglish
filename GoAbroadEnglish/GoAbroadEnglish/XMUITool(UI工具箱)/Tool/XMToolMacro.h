//
//  XMToolMacro.h
//  艺库
//
//  Created by zhangmingwei on 2019/7/11.
//  Copyright © 2019 YiKuNetwork. All rights reserved.
//

#ifndef XMToolMacro_h
#define XMToolMacro_h

// 工具类型的宏定义 ！！！！！！

/// 当前版本号 - Version 例如：1.2.0 - 字符串类型
#define kCurrentVersionStr_XM       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/// 当前构建版本 - Build 例如：12 - 字符串类型
#define kCurrentBuidVersionStr_XM   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

/// 语言判断：-------- 语言是否是中文 BOOL ---------------
#define kLanguage_Is_Chinese_XM          ([([[NSLocale preferredLanguages] objectAtIndex:0]) == nil ? @"" : ([[NSLocale preferredLanguages] objectAtIndex:0]) hasPrefix:@"zh"])
/// 语言判断：-------- 语言是否是英文。英语：YES 其他语言：NO
#define kLanguage_Is_English_XM          ([([[NSLocale preferredLanguages] objectAtIndex:0]) == nil ? @"" : ([[NSLocale preferredLanguages] objectAtIndex:0]) hasPrefix:@"en"])

/// 地区判断：-------- 是否在中国地区包括港澳台 BOOL ---------------
#define kArea_In_China_XM \
(([kLocal_string_upper_case_XM hasSuffix:@"CN"] ||    \
[kLocal_string_upper_case_XM hasSuffix:@"HK"] ||   \
[kLocal_string_upper_case_XM hasSuffix:@"TW"] ||   \
[kLocal_string_upper_case_XM hasSuffix:@"MO"]))
/// 地区判断：-------- 是否在中国内地 (不含港澳台) BOOL ------------
#define kArea_In_China_mainland_XM         ([kLocal_string_upper_case_XM hasSuffix:@"CN"])
/// -------- 获取本地语言的字符串。例如： "ZH_CN"
// 中国-大陆    ZH_CN
// 中文-香港    ZH_HK
// 英文-香港    EN_HK
// 英文-中国    EN_CN
// 英文-台湾    EN_TW
// 英文-澳门    EN_MO
#define kLocal_string_upper_case_XM     [(NSString *)[[NSLocale currentLocale] localeIdentifier] uppercaseString]


#endif /* XMToolMacro_h */
