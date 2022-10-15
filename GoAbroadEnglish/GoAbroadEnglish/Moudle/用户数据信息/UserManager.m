//
//  UserManager.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/15.
//

#import "UserManager.h"

@implementation UserManager

+ (instancetype)sharedInstance {
    static UserManager *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[UserManager alloc] init];
        single.englishArr = [NSMutableArray array];
    });
    return single;
}

/// 获取本地的英语数组
+ (NSMutableArray *)getLocalEnglishArr {
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userD objectForKey:@"englishArr"];
    if (arr.count > 0) {
        [UserManager sharedInstance].englishArr = [NSMutableArray arrayWithArray:arr];
    } else {
        [UserManager sharedInstance].englishArr = [NSMutableArray array];
    }
    return [UserManager sharedInstance].englishArr;
}
/// 保存数据到本地
+ (void)addLocalEnglishArr:(NSString *)str {
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userD objectForKey:@"englishArr"];
    if (arr.count > 0) {
        [UserManager sharedInstance].englishArr = [NSMutableArray arrayWithArray:arr];
    } else {
        [UserManager sharedInstance].englishArr = [NSMutableArray array];
    }
    NSArray *strArr = [str componentsSeparatedByString:@"\n"];
    if (strArr.count > 1) {
        [[UserManager sharedInstance].englishArr insertObject:str atIndex:0];
    }
    [UserManager saveLocalEnglishArrToUserDefaults];
}

/// 同步数据到userdefalut
+ (void)saveLocalEnglishArrToUserDefaults {
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:[UserManager sharedInstance].englishArr forKey:@"englishArr"];
    [userD synchronize];
}

@end
