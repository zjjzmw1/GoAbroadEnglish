//
//  XMSoundManager.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/8.
//

#import "XMSoundManager.h"
#import <AVFoundation/AVFoundation.h>   // 播放文字需要

@interface XMSoundManager()

@property (nonatomic, strong) AVSpeechSynthesizer   *speechSyn;
@property (nonatomic, strong) AVSpeechUtterance     *speechUtter;

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
/// 播放文字
+ (void)playText:(NSString *)text {
    if (![XMSoundManager sharedInstance].speechSyn) {
        [XMSoundManager sharedInstance].speechSyn = [[AVSpeechSynthesizer alloc]init];
    }
    if (![XMSoundManager sharedInstance].speechUtter) {
        [XMSoundManager sharedInstance].speechUtter = [[AVSpeechUtterance alloc]init];
    }
    
    // 先暂停目前正在播放的
    [[XMSoundManager sharedInstance].speechSyn stopSpeakingAtBoundary:AVSpeechBoundaryImmediate]; // Immediate 立即暂停
    
    [XMSoundManager sharedInstance].speechUtter = [AVSpeechUtterance speechUtteranceWithString:text];
    [XMSoundManager sharedInstance].speechUtter.voice = [AVSpeechSynthesisVoice voiceWithLanguage: @"en"];  //语言
    [XMSoundManager sharedInstance].speechUtter.rate = 0.5;                     //语速 最小为0.0，最大为1.0
    [XMSoundManager sharedInstance].speechUtter.pitchMultiplier = 1;       //0.5-2.0之间
    [XMSoundManager sharedInstance].speechUtter.volume = 1;             //0.0-1.0之间
    [[XMSoundManager sharedInstance].speechSyn speakUtterance:[XMSoundManager sharedInstance].speechUtter];
}

@end
