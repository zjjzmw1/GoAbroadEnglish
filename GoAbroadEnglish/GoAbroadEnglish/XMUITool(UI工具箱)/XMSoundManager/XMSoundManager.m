//
//  XMSoundManager.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/8.
//

#import "XMSoundManager.h"

@interface XMSoundManager()


@end

@implementation XMSoundManager

+ (instancetype)sharedInstance {
    static XMSoundManager *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[XMSoundManager alloc] init];
    });
    return single;
}

#pragma mark - 播放文字

+ (void)playText:(NSString *)text voiceLanguage:(nullable NSString *)voiceLanguage row:(NSInteger)row {
    [XMSoundManager lastPlayText:text voiceLanguage:voiceLanguage row:row];
}

/// 最终的播放文字
+ (void)lastPlayText:(NSString *)text voiceLanguage:(nullable NSString *)voiceLanguage row:(NSInteger)row {
    if (![XMSoundManager sharedInstance].speechSyn) {
        [XMSoundManager sharedInstance].speechSyn = [[AVSpeechSynthesizer alloc]init];
    }
    if (![XMSoundManager sharedInstance].speechUtter) {
        [XMSoundManager sharedInstance].speechUtter = [[AVSpeechUtterance alloc]init];
    }
    [XMSoundManager sharedInstance].currentRow = row;
    // 先暂停目前正在播放的
    [[XMSoundManager sharedInstance].speechSyn stopSpeakingAtBoundary:AVSpeechBoundaryImmediate]; // Immediate 立即暂停
    
    [XMSoundManager sharedInstance].speechUtter = [AVSpeechUtterance speechUtteranceWithString:text];
    [XMSoundManager sharedInstance].speechUtter.voice = [AVSpeechSynthesisVoice voiceWithLanguage: @"en-US"];  // 女 英语 -- 美国 @"en-GB" 男 英国
    if (voiceLanguage.length > 0) {
        [XMSoundManager sharedInstance].speechUtter.voice = [AVSpeechSynthesisVoice voiceWithLanguage: voiceLanguage];
    }
    if ([voiceLanguage hasPrefix:@"zh"]) { // 中文
        [XMSoundManager sharedInstance].speechUtter.rate = 0.55;                     //语速 最小为0.0，最大为1.0
        [XMSoundManager sharedInstance].speechUtter.pitchMultiplier = 0.95;       //0.5-2.0之间 语调
    } else { // 英语
        [XMSoundManager sharedInstance].speechUtter.rate = AVSpeechUtteranceDefaultSpeechRate;                     //语速 最小为0.0，最大为1.0
        [XMSoundManager sharedInstance].speechUtter.pitchMultiplier = 0.91;       //0.5-2.0之间 语调
    }
    NSLog(@"===%@",[XMSoundManager sharedInstance].speechUtter.voice);
    [XMSoundManager sharedInstance].speechUtter.volume = 0.9;             //0.0-1.0之间
    [XMSoundManager sharedInstance].speechUtter.preUtteranceDelay = 0.1; // 播放前停顿
    [XMSoundManager sharedInstance].speechUtter.postUtteranceDelay = 0.1; // 播放后停顿
    [[XMSoundManager sharedInstance].speechSyn speakUtterance:[XMSoundManager sharedInstance].speechUtter];
    [[XMSoundManager sharedInstance].speechSyn continueSpeaking];
}

@end
