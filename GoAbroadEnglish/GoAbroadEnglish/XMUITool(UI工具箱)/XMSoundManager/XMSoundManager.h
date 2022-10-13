//
//  XMSoundManager.h
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/8.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>   // 播放文字需要

NS_ASSUME_NONNULL_BEGIN

@interface XMSoundManager : NSObject

/// 当前播放的行数
@property (nonatomic, assign) NSInteger             currentRow;
@property (nonatomic, strong) AVSpeechSynthesizer   *speechSyn;
@property (nonatomic, strong) AVSpeechUtterance     *speechUtter;

+ (instancetype)sharedInstance;
/// 播放文字
+ (void)playText:(NSString *)text voiceLanguage:(nullable NSString *)voiceLanguage row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
