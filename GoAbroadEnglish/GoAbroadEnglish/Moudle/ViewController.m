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

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.customNaviView setTitleStr:@"出国必备短语"];
        
    self.dataArr = [NSMutableArray arrayWithArray:@[@"Help yourself.",@"Please eat up. Take your time.",@"Do you want anymore?",@" It’s your turn.",@"What’s on tonight?",@"Keep on trying.",@"Which one will you choose?"]];
    self.tableView = [UITableView instanceWithType:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, kNaviStatusBarH_XM, kScreenWidth_XM, kScreenHeight_XM - kNaviStatusBarH_XM - kTabBarH_XM);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    if (self.dataArr.count > indexPath.row) {
        cell.textLabel.text = self.dataArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.row < self.dataArr.count) {
        NSString *str = self.dataArr[indexPath.row];
        if (indexPath.row % 2 == 0) {
            [XMSoundManager playText:str voiceLanguage:nil];
        } else {
            [XMSoundManager playText:str voiceLanguage:@"en-US"];
        }
    }
    
}


@end
