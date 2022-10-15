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

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,AVSpeechSynthesizerDelegate,KSSideslipCellDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *dataArr;
/// 是否正在读中文
@property (nonatomic, assign) BOOL              isChinese;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.customNaviView setTitleStr:@"出国必备短语"];
    [XMSoundManager sharedInstance].currentRow = -1;
    self.dataArr = [NSMutableArray arrayWithArray:@[@"The windows of that house are broken \n 那间屋子的窗户破了",@"He made a great many mistakes \n 他犯了许多错误",@"A square has four sides \n 正方形有四条边",@" Plastic is hard to break up \n 塑料很难分解",@"The story took place in an October in the 1980s. \n 这个故事发生在20世纪80年代一个10月。",@" I’d like a coffee and a chicken sandwich, sir \n 先生，我要一杯咖啡和一个鸡肉三明治",@"The new is to take the place of the old. \n 新事物最终会取代旧事物",@"There is a reason for every important thing that happens. \n 每件重要事情的发生都有原因"]];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, kNaviStatusBarH_XM, kScreenWidth_XM, kScreenHeight_XM - kNaviStatusBarH_XM - kTabBarH_XM);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    cell.delegate = self;
    if (self.dataArr.count > indexPath.row) {
        NSString *str = self.dataArr[indexPath.row];
        NSString *strEN = self.dataArr[indexPath.row];
        NSString *strCH = self.dataArr[indexPath.row];
        NSArray *titleArr = [str componentsSeparatedByString:@"\n"];
        if (titleArr.count > 1) {
            strEN = titleArr[0];
            strCH = titleArr[1];
        }
        [cell reloadData:indexPath.row selectRow:[XMSoundManager sharedInstance].currentRow title:self.dataArr[indexPath.row]];
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
    NSString *str = self.dataArr[indexPath.row];
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    paste.string = str;
    [XMToast showTextToCenter:@"拷贝成功"];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"播放完成===%ld",(long)[XMSoundManager sharedInstance].currentRow);
    NSInteger newRow = [XMSoundManager sharedInstance].currentRow;
    if (self.isChinese == NO) { // 播放当前行的中文
        NSString *lastStr = self.dataArr[newRow];
        NSArray *chineseArr = [lastStr componentsSeparatedByString:@"\n"];
        if (chineseArr.count > 1) {
            lastStr = chineseArr[1];
        }
        self.isChinese = YES;
        [XMSoundManager playText:lastStr voiceLanguage:@"zh" row:newRow];
    } else { // 播放下一行的英文
        [XMSoundManager sharedInstance].currentRow += 1;
        newRow = [XMSoundManager sharedInstance].currentRow;
        if (newRow >= self.dataArr.count) {
            return;
        }
        NSString *lastStr = self.dataArr[newRow];
        NSArray *enArr = [lastStr componentsSeparatedByString:@"\n"];
        if (enArr.count > 1) {
            lastStr = enArr[0];
        }
        self.isChinese = NO;
        [XMSoundManager playText:lastStr voiceLanguage:@"en-US" row:newRow];
    }
    [self.tableView reloadData];
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
//    LYHomeCellModel *model = _dataArray[indexPath.row];
    KSSideslipCellAction *action1 = [KSSideslipCellAction rowActionWithStyle:KSSideslipCellActionStyleNormal title:@"取消关注" handler:^(KSSideslipCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"取消关注");
        [sideslipCell hiddenAllSideslip];
    }];
    KSSideslipCellAction *action2 = [KSSideslipCellAction rowActionWithStyle:KSSideslipCellActionStyleDestructive title:@"删除" handler:^(KSSideslipCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击删除");
    }];
    KSSideslipCellAction *action3 = [KSSideslipCellAction rowActionWithStyle:KSSideslipCellActionStyleNormal title:@"置顶" handler:^(KSSideslipCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"置顶");
        [sideslipCell hiddenAllSideslip];
    }];
    
    NSArray *array = @[action1, action2, action3];
    return array;
}

- (BOOL)sideslipCell:(KSSideslipCell *)sideslipCell canSideslipRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (UIView *)sideslipCell:(KSSideslipCell *)sideslipCell rowAtIndexPath:(NSIndexPath *)indexPath didSelectedAtIndex:(NSInteger)index {
//    self.indexPath = indexPath;
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
//    [_dataArray removeObjectAtIndex:self.indexPath.row];
//    [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
