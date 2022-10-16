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
#import "UserManager.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,AVSpeechSynthesizerDelegate,KSSideslipCellDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView       *tableView;
/// 是否正在读中文
@property (nonatomic, assign) BOOL              isChinese;

@property (nonatomic, strong) NSIndexPath       *indexP;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.customNaviView setTitleStr:@"出国必备短语"];
    
    [UserManager getLocalEnglishArr];
    
    [XMSoundManager sharedInstance].currentRow = -1;
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, kNaviStatusBarH_XM, kScreenWidth_XM, kScreenHeight_XM - kNaviStatusBarH_XM - kTabBarH_XM);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [UserManager sharedInstance].englishArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    cell.delegate = self;
    if ([UserManager sharedInstance].englishArr.count > indexPath.row) {
        NSString *str = [UserManager sharedInstance].englishArr[indexPath.row];
        NSString *strEN = [UserManager sharedInstance].englishArr[indexPath.row];
        NSString *strCH = [UserManager sharedInstance].englishArr[indexPath.row];
        NSArray *titleArr = [str componentsSeparatedByString:@"\n"];
        if (titleArr.count > 1) {
            strEN = titleArr[0];
            strCH = titleArr[1];
        }
        [cell reloadData:indexPath.row selectRow:[XMSoundManager sharedInstance].currentRow title:[UserManager sharedInstance].englishArr[indexPath.row]];
//        __weak typeof(self) wSelf = self;
//        cell.clickLeftBlock = ^{
//            wSelf.isChinese = NO;
//            [XMSoundManager sharedInstance].currentRow = indexPath.row;
//            [XMSoundManager playText:strEN voiceLanguage:@"en-US" row:indexPath.row];
//            [XMSoundManager sharedInstance].speechSyn.delegate = wSelf;
//            [wSelf.tableView reloadData];
//        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *str = [UserManager sharedInstance].englishArr[indexPath.row];
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    paste.string = str;
    [XMToast showTextToCenter:@"拷贝成功"];
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
        _tableView.separatorColor = [UIColor lightTextColor];
        _tableView.estimatedRowHeight = 100; // 0的话，就是不自动布局
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

#pragma mark - KSSideslipCellDelegate
- (NSArray<KSSideslipCellAction *> *)sideslipCell:(KSSideslipCell *)sideslipCell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) wSelf = self;
    KSSideslipCellAction *action1 = [KSSideslipCellAction rowActionWithStyle:KSSideslipCellActionStyleNormal title:@"置顶" handler:^(KSSideslipCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"置顶");
        NSString *str = [UserManager sharedInstance].englishArr[indexPath.row];
        [UserManager.sharedInstance.englishArr removeObjectAtIndex:self.indexP.row];
        [UserManager.sharedInstance.englishArr insertObject:str atIndex:0];
        [sideslipCell hiddenAllSideslip];
        [wSelf.tableView reloadData];
    }];
    KSSideslipCellAction *action2 = [KSSideslipCellAction rowActionWithStyle:KSSideslipCellActionStyleDestructive title:@"删除" handler:^(KSSideslipCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击删除");
    }];
    
    NSArray *array = @[action1, action2];
    return array;
}

- (BOOL)sideslipCell:(KSSideslipCell *)sideslipCell canSideslipRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UIView *)sideslipCell:(KSSideslipCell *)sideslipCell rowAtIndexPath:(NSIndexPath *)indexPath didSelectedAtIndex:(NSInteger)index {
    self.indexP = indexPath;
    UIButton * view =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 135, 0)];
    view.titleLabel.textAlignment = NSTextAlignmentCenter;
    view.titleLabel.font = [UIFont systemFontOfSize:17];
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view setTitle:@"确认删除" forState:UIControlStateNormal];
    view.backgroundColor = [UIColor redColor];
    [view addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (void)delBtnClick {
    [UserManager.sharedInstance.englishArr removeObjectAtIndex:self.indexP.row];
    [UserManager saveLocalEnglishArrToUserDefaults];
    [self.tableView deleteRowsAtIndexPaths:@[self.indexP] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

@end
