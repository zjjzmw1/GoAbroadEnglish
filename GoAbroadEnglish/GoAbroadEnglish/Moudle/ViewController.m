//
//  ViewController.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/8.
//

#import "ViewController.h"
#import "UITableView+XMTool.h"
#import "XMSizeMacro.h"
#import "XMToast.h"
#import "XMTabBarVC.h"
#import "XMSoundManager.h"
#import "HomeCell.h"
#import <AVFoundation/AVFoundation.h>   // 播放文字需要

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *dataArr;
/// 当前选择的左边还是右边
@property (nonatomic, assign) BOOL              isLeftClick;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.customNaviView setTitleStr:@"出国必备短语"];
        
    self.dataArr = [NSMutableArray arrayWithArray:@[@"Help yourself.",@"Please eat up. Take your time.",@"Do you want anymore?",@" It’s your turn.",@"What’s on tonight?",@"Keep on trying.",@"Which one will you choose?"]];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, kNaviStatusBarH_XM, kScreenWidth_XM, kScreenHeight_XM - kNaviStatusBarH_XM - kTabBarH_XM);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    if (self.dataArr.count > indexPath.row) {
        NSString *str = self.dataArr[indexPath.row];
        [cell reloadData:indexPath.row selectRow:0 title:self.dataArr[indexPath.row]];
        __weak typeof(self) wSelf = self;
        cell.clickLeftBlock = ^{
            wSelf.isLeftClick = YES;
            [XMSoundManager playText:str voiceLanguage:nil row:indexPath.row];
            [XMSoundManager sharedInstance].speechSyn.delegate = self;
        };
        cell.clickRightBlock = ^{
            wSelf.isLeftClick = NO;
            [XMSoundManager playText:str voiceLanguage:@"en-US" row:indexPath.row];
            [XMSoundManager sharedInstance].speechSyn.delegate = self;
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"播放完成===%ld",(long)[XMSoundManager sharedInstance].currentRow);
    NSInteger newRow = [XMSoundManager sharedInstance].currentRow += 1;
    if (newRow <= self.dataArr.count - 1) {
        NSString *str = self.dataArr[newRow];
        if (self.isLeftClick) {
            [XMSoundManager playText:str voiceLanguage:nil row:newRow];
        } else {
            [XMSoundManager playText:str voiceLanguage:@"en-US" row:newRow];
        }
        [XMSoundManager sharedInstance].speechSyn.delegate = self;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 不添加横线
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor lightTextColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView registerClass:[HomeCell class] forCellReuseIdentifier:@"HomeCell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {

        }
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
        UIView *headV = [[UIView alloc] init];
        _tableView.tableHeaderView = headV;
    }
    return _tableView;
}



@end
