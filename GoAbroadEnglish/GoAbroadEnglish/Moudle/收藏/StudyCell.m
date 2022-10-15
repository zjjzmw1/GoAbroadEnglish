//
//  StudyCell.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/15.
//

#import "StudyCell.h"
#import "UIView+XMTool.h"
#import "UIColor+XMTool.h"
#import <Masonry/Masonry.h>

@interface StudyCell()

/// 标题
@property (nonatomic, strong) UILabel       *titleLbl;
/// 左边按钮
@property (nonatomic, strong) UIButton      *leftBtn;

@end

@implementation StudyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.desLbl];
        __weak typeof(self) wSelf = self;
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(wSelf.contentView);
            make.width.mas_equalTo(100);
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(wSelf.contentView).inset(16);
            make.top.equalTo(wSelf.contentView).offset(0);
        }];
        [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(wSelf.contentView).inset(16);
            make.top.equalTo(wSelf.titleLbl.mas_bottom).offset(0);
            make.bottom.equalTo(wSelf.contentView).inset(30);
        }];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.desLbl.alpha = 0.01;
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
        _titleLbl.font = [UIFont boldSystemFontOfSize:26];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.numberOfLines = 0;
    }
    return _titleLbl;
}
- (UILabel *)desLbl {
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] init];
        _desLbl.textColor = [UIColor blackColor];
        _desLbl.font = [UIFont boldSystemFontOfSize:18];
        _desLbl.textAlignment = NSTextAlignmentCenter;
        _desLbl.numberOfLines = 0;
    }
    return _desLbl;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.backgroundColor = [UIColor clearColor];
    }
    return _leftBtn;
}

@end
