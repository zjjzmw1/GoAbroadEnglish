//
//  HomeCell.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/13.
//

#import "HomeCell.h"
#import "UIView+XMTool.h"
#import "UIColor+XMTool.h"
#import <Masonry/Masonry.h>

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
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.desLbl];
        __weak typeof(self) wSelf = self;
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(wSelf.contentView);
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(wSelf.contentView).inset(16);
            make.top.equalTo(wSelf.contentView).offset(10);
        }];
        [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(wSelf.contentView).inset(16);
            make.top.equalTo(wSelf.titleLbl.mas_bottom).offset(10);
            make.bottom.equalTo(wSelf.contentView).inset(10);
        }];
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
}

#pragma mark - 懒加载

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = [UIFont systemFontOfSize:17];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.numberOfLines = 0;
    }
    return _titleLbl;
}
- (UILabel *)desLbl {
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] init];
        _desLbl.textColor = [UIColor blackColor];
        _desLbl.font = [UIFont systemFontOfSize:16];
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
