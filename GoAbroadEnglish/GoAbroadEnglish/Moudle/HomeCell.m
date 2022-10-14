//
//  HomeCell.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/13.
//

#import "HomeCell.h"
#import "UIView+XMTool.h"
#import "UIColor+XMTool.h"

@interface HomeCell()

/// 标题
@property (nonatomic, strong) UILabel       *titleLbl;
@property (nonatomic, strong) UILabel       *desLbl;
/// 左边按钮
@property (nonatomic, strong) UIButton      *leftBtn;
/// 右边按钮
//@property (nonatomic, strong) UIButton      *rightBtn;

@end

@implementation HomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.desLbl];
//        [self.contentView addSubview:self.rightBtn];
//        self.titleLbl.frame = CGRectMake(18, 12, [UIScreen mainScreen].bounds.size.width - 100, 20);
    }
    return self;
}

/// 刷新数据
- (void)reloadData:(NSInteger)currentRow selectRow:(NSInteger)selectRow title:(NSString *)titleString {
    NSArray *titleArr = [titleString componentsSeparatedByString:@"\n"];
    if (titleArr.count > 1) {
        self.titleLbl.text = titleArr[0];
        self.desLbl.text = titleArr[1];
    }
    self.titleLbl.frame = CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width - 32, self.height/2.0);
    self.desLbl.frame = CGRectMake(16, self.height/2.0, [UIScreen mainScreen].bounds.size.width - 32, self.height/2.0);
    self.leftBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.height);
//    self.rightBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 0, 100, self.height);
    if (currentRow % 2 == 0) {
        _leftBtn.backgroundColor = [UIColor whiteColor];
    } else {
        _leftBtn.backgroundColor = [UIColor getGreenColor_XM];
    }
    if (currentRow == selectRow) {
        _leftBtn.backgroundColor = [UIColor getRedColor_XM];
    }
    _leftBtn.alpha = 0.1;
    __weak typeof(self) wSelf = self;
    [self.leftBtn setTapActionWithBlock:^{
        if (wSelf.clickLeftBlock) {
            wSelf.clickLeftBlock();
        }
    }];
//    [self.rightBtn setTapActionWithBlock:^{
//        if (wSelf.clickRightBlock) {
//            wSelf.clickRightBlock();
//        }
//    }];
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
- (UILabel *)desLbl {
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] init];
        _desLbl.textColor = [UIColor blackColor];
        _desLbl.font = [UIFont systemFontOfSize:15];
        _desLbl.textAlignment = NSTextAlignmentCenter;
        _desLbl.numberOfLines = 0;
    }
    return _desLbl;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.alpha = 0.1;
    }
    return _leftBtn;
}

//- (UIButton *)rightBtn {
//    if (!_rightBtn) {
//        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _rightBtn.backgroundColor = [UIColor greenColor];
//        _rightBtn.alpha = 0.2;
//    }
//    return _rightBtn;
//}


@end
