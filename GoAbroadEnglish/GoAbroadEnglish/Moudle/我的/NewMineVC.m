//
//  NewMineVC.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/8.
//

#import "NewMineVC.h"
#import "XMTextView.h"
#import "UserManager.h"

@interface NewMineVC()

@property (nonatomic, strong) XMTextView    *textV;

@end

@implementation NewMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) wSelf = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.customNaviView setTitleStr:@"我的"];
    [self.customNaviView setRightBtnImage:nil title:@"添加"];
    [self.customNaviView setRightBlock:^{
        NSString *str = wSelf.textV.text;
        UIPasteboard *paste = UIPasteboard.generalPasteboard;
        NSArray *titleArr = [str componentsSeparatedByString:@"\n"];
        if (titleArr.count > 1) {
            paste.string = str;
        }
        [UserManager addLocalEnglishArr:str];
        [wSelf.textV resignFirstResponder];
        wSelf.textV.text = nil;
    }];

    self.textV = [[XMTextView alloc] init];
    [self.view addSubview:self.textV];
    
    self.textV.frame = CGRectMake(0, kNaviStatusBarH_XM, kScreenWidth_XM, 200);
    self.textV.backgroundColor = [UIColor yellowColor];
    self.textV.font = [UIFont boldSystemFontOfSize:20];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textV resignFirstResponder];
}

@end
