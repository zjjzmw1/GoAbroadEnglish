//
//  StudyVC.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/8.
//

#import "StudyVC.h"
#import "UITableView+XMTool.h"
#import "XMSizeMacro.h"
#import "XMToast.h"
#import "XMTabBarVC.h"
#import "XMSoundManager.h"
#import "StudyCell.h"
#import "UIColor+XMTool.h"
#import <AVFoundation/AVFoundation.h>   // 播放文字需要

@interface StudyVC()<UITableViewDelegate, UITableViewDataSource,AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *dataArr;
/// 英文音色
@property (nonatomic, assign) BOOL              isGirl;
/// 获取颜色
@property (nonatomic, assign) int               colorFlag;
@property (nonatomic, assign) int               titleFlag;

@end

@implementation StudyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) wSelf = self;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.customNaviView setTitleStr:[self getTitleStr]];
    [self.customNaviView setRightBtnImage:nil title:@" "];
    [self.customNaviView setBackBtnImage:nil title:@" "];
    [self.customNaviView setBackBlock:^{
        
    }];
    [self.customNaviView setRightBlock:^{
        wSelf.view.backgroundColor = [wSelf getColorTemp];
    }];
    self.dataArr = [NSMutableArray arrayWithArray:@[@"The windows of that house are broken \n 那间屋子的窗户破了",@"He made a great many mistakes \n 他犯了许多错误",@"A square has four sides \n 正方形有四条边",@" Plastic is hard to break up \n 塑料很难分解",@"The story took place in an October in the 1980s. \n 这个故事发生在20世纪80年代一个10月。",@" I’d like a coffee and a chicken sandwich, sir \n 先生，我要一杯咖啡和一个鸡肉三明治",@"The new is to take the place of the old. \n 新事物最终会取代旧事物",@"There is a reason for every important thing that happens. \n 每件重要事情的发生都有原因"]];

    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, kNaviStatusBarH_XM, kScreenWidth_XM, kScreenWidth_XM - 226);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [self getColorTemp];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleFlag = 0;
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    self.dataArr = [NSMutableArray array];
    if (paste.string.length > 0) {
        [self.dataArr addObject:paste.string];
    }
    [self.tableView reloadData];
    
    [self.customNaviView setTitleStr:[self getTitleStr]];
}

- (NSString *)getTitleStr {
    self.titleFlag += 1;
    if (self.titleFlag == 1) {
        return @"3遍后展示中文"; // 蓝色
    }
    if (self.titleFlag == 2) {
        return @"3遍后展示中文"; // 蓝色
    }
    if (self.titleFlag == 3) {
        return @"2遍后展示中文"; // 蓝色
    }
    if (self.titleFlag == 4) {
        return @"1遍后展示中文"; // 蓝色
    }
    return @"请看中文"; // 蓝色
}

- (UIColor *)getColorTemp {
    if (self.colorFlag > 5) {
        self.colorFlag = 0;
    } else {
        self.colorFlag += 1;
    }
    UIColor *color = [UIColor whiteColor];
    if (self.colorFlag == 0) {
        color = [UIColor colorFromHexString:@"#68B4EC" alpha:0.25]; // 蓝色
    }
    if (self.colorFlag == 1) {
        color = [UIColor colorFromHexString:@"#F6C358" alpha:0.25]; // 黄色
    }
    if (self.colorFlag == 2) {
        color = [UIColor colorFromHexString:@"#e8320d" alpha:0.25]; // 红色
    }
    if (self.colorFlag == 3) {
        color = [UIColor colorFromHexString:@"#7D5D9E" alpha:0.25]; // 紫色
    }
    if (self.colorFlag == 4) {
        color = [UIColor colorFromHexString:@"#61C355" alpha:0.25]; // 绿色
    }
    if (self.colorFlag == 5) {
        color = [UIColor colorFromHexString:@"#35C277" alpha:0.25]; // 绿色2
    }
    self.customNaviView.backgroundColor = [UIColor clearColor];
    [self.customNaviView showBottomLine:NO];
    return color;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenWidth_XM - 226;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudyCell"];
    if (self.titleFlag <= 1) {
        cell.desLbl.alpha = 0.01;
    }
    if (self.dataArr.count > indexPath.row) {
        NSString *str = self.dataArr[indexPath.row];
        NSString *strEN = self.dataArr[indexPath.row];
        NSString *strCH = self.dataArr[indexPath.row];
        NSArray *titleArr = [str componentsSeparatedByString:@"\n"];
        if (titleArr.count > 1) {
            strEN = titleArr[0];
            strCH = titleArr[1];
        }
        NSArray *titleArr2 = [str componentsSeparatedByString:@"\n\n"];
        if (titleArr2.count > 1) {
            strEN = titleArr2[0];
            strCH = titleArr2[1];
        }
        [cell reloadData:indexPath.row selectRow:[XMSoundManager sharedInstance].currentRow title:self.dataArr[indexPath.row]];
        __weak typeof(self) wSelf = self;
        cell.clickLeftBlock = ^{
            if (wSelf.isGirl) {
                wSelf.isGirl = NO;
                [XMSoundManager playText:strEN voiceLanguage:@"en-GB" row:indexPath.row];
            } else {
                wSelf.isGirl = YES;
                [XMSoundManager playText:strEN voiceLanguage:@"en-US" row:indexPath.row];
            }
            [XMSoundManager sharedInstance].speechSyn.delegate = wSelf;
            [wSelf.tableView reloadData];
            [wSelf.customNaviView setTitleStr:[self getTitleStr]];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    StudyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.dataArr.count > indexPath.row) {
        NSString *str = self.dataArr[indexPath.row];
        NSString *strEN = self.dataArr[indexPath.row];
        NSString *strCH = self.dataArr[indexPath.row];
        NSArray *titleArr = [str componentsSeparatedByString:@"\n"];
        if (titleArr.count > 1) {
            strEN = titleArr[0];
            strCH = titleArr[1];
        }
        NSArray *titleArr2 = [str componentsSeparatedByString:@"\n\n"];
        if (titleArr2.count > 1) {
            strEN = titleArr2[0];
            strCH = titleArr2[1];
        }
        [XMSoundManager playText:strCH voiceLanguage:@"zh-CN" row:indexPath.row];
        cell.desLbl.alpha = 1.0;
        [XMSoundManager sharedInstance].speechSyn.delegate = self;
        [self.tableView reloadData];
        [self.customNaviView setTitleStr:[self getTitleStr]];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"播放完成===%ld",(long)[XMSoundManager sharedInstance].currentRow);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 不添加横线
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor redColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 0; // 0的话，就是不自动布局
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView registerClass:[StudyCell class] forCellReuseIdentifier:@"StudyCell"];
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
