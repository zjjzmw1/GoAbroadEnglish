//
//  ImageVC.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/18.
//

#import "ImageVC.h"
#import "UITableView+XMTool.h"
#import "XMSizeMacro.h"
#import "XMToast.h"
#import "XMTabBarVC.h"
#import "XMSoundManager.h"
#import "ImageCell.h"
#import "ImageCell.h"
#import "UIColor+XMTool.h"
#import <AVFoundation/AVFoundation.h>   // 播放文字需要
#import "UIImage+XMTool.h"

@interface ImageVC()<UITableViewDelegate, UITableViewDataSource,AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *dataArr;
/// 英文音色
@property (nonatomic, assign) BOOL              isGirl;
/// 获取颜色
@property (nonatomic, assign) int               colorFlag;
@property (nonatomic, assign) int               titleFlag;

@end

@implementation ImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) wSelf = self;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.customNaviView setRightBtnImage:nil title:@" "];
    [self.customNaviView setBackBtnImage:nil title:@" "];
    [self.customNaviView setBackBlock:^{
        [wSelf.customNaviView setTitleStr:[wSelf getTitleStr]];
        [wSelf.tableView reloadData];
    }];
    [self.customNaviView setRightBlock:^{
        wSelf.view.backgroundColor = [wSelf getColorTemp];
    }];

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
        return @"先盲听两遍"; // 蓝色
    }
    if (self.titleFlag == 2) {
        return @"再看英文听两遍"; // 蓝色
    }
    return @"最后看中文听两遍"; // 蓝色
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
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
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
            
            if (self.titleFlag == 1) {
                cell.titleLbl.hidden = YES;
                cell.desLbl.hidden = YES;
            } else if (self.titleFlag == 2) {
                cell.titleLbl.hidden = NO;
                cell.desLbl.hidden = YES;
                cell.titleLbl.text = strEN;
            } else {
                cell.titleLbl.hidden = NO;
                cell.desLbl.hidden = YES;
                cell.titleLbl.text = strCH;
            }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 截图
    UIImage *img = [UIImage imageFromView:self.view atFrame:CGRectMake(0, kStatusBarHeight_XM, kScreenWidth_XM, 44 + (kScreenWidth_XM - 226) - 2)];
    UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);
    [XMToast showTextToCenter:@"保存成功"];
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
        [_tableView registerClass:[ImageCell class] forCellReuseIdentifier:@"ImageCell"];
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
