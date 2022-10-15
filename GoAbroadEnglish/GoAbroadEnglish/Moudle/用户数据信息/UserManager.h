//
//  UserManager.h
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject

/// 英文短语数组
@property (nonatomic, strong) NSMutableArray    *englishArr;

+ (instancetype)sharedInstance;

/// 获取本地的英语数组
+ (NSMutableArray *)getLocalEnglishArr;
/// 保存数据到本地
+ (void)addLocalEnglishArr:(NSString *)str;
/// 同步数据到userdefalut
+ (void)saveLocalEnglishArrToUserDefaults;
@end

NS_ASSUME_NONNULL_END
