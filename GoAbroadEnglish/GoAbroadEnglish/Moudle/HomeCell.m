//
//  HomeCell.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/13.
//

#import "HomeCell.h"
#import "UIView+XMTool.h"

@interface HomeCell()

/// 标题
@property (nonatomic, strong) UILabel       *titleLbl;
/// 左边按钮
@property (nonatomic, strong) UIButton      *leftBtn;
/// 右边按钮
@property (nonatomic, strong) UIButton      *rightBtn;

@end

@implementation HomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.rightBtn];
        self.titleLbl.frame = CGRectMake(18, 12, [UIScreen mainScreen].bounds.size.width - 100, 20);
    }
    return self;
}

/// 刷新数据
- (void)reloadData:(NSInteger)currentRow selectRow:(NSInteger)selectRow title:(NSString *)titleString {
    self.titleLbl.text = titleString;
    self.titleLbl.frame = CGRectMake(110, 12, [UIScreen mainScreen].bounds.size.width - 220, self.height - 24);
    self.leftBtn.frame = CGRectMake(0, 0, 100, self.height);
    self.rightBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 0, 100, self.height);
    
    __weak typeof(self) wSelf = self;
    [self.leftBtn setTapActionWithBlock:^{
        if (wSelf.clickLeftBlock) {
            wSelf.clickLeftBlock();
        }
    }];
    [self.rightBtn setTapActionWithBlock:^{
        if (wSelf.clickRightBlock) {
            wSelf.clickRightBlock();
        }
    }];
}

#pragma mark - 懒加载

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = [UIFont systemFontOfSize:16];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.numberOfLines = 0;
    }
    return _titleLbl;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.backgroundColor = [UIColor redColor];
        _leftBtn.alpha = 0.2;
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.backgroundColor = [UIColor greenColor];
        _rightBtn.alpha = 0.2;
    }
    return _rightBtn;
}


@end
