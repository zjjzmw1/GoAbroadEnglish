//
//  XMSoundManager.h
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMSoundManager : NSObject

/// 播放文字
+ (void)playText:(NSString *)text voiceLanguage:(nullable NSString *)voiceLanguage;

@end

NS_ASSUME_NONNULL_END
