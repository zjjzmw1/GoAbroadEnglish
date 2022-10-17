//
//  ImageCell.m
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/18.
//

#import "ImageCell.h"
#import "UIView+XMTool.h"
#import "UIColor+XMTool.h"
#import <Masonry/Masonry.h>

@interface ImageCell()


@end

@implementation ImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.desLbl];
        __weak typeof(self) wSelf = self;
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(wSelf.contentView).inset(16);
            make.top.equalTo(wSelf.contentView).offset(20);
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
    NSArray *titleArr2 = [titleString componentsSeparatedByString:@"\n\n"];
    if (titleArr2.count > 1) {
        self.titleLbl.text = titleArr2[0];
        self.desLbl.text = titleArr2[1];
    }
}

#pragma mark - 懒加载

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = [UIFont boldSystemFontOfSize:20];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.numberOfLines = 0;
    }
    return _titleLbl;
}
- (UILabel *)desLbl {
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] init];
        _desLbl.textColor = [UIColor blackColor];
        _desLbl.font = [UIFont boldSystemFontOfSize:16];
        _desLbl.textAlignment = NSTextAlignmentCenter;
        _desLbl.numberOfLines = 0;
    }
    return _desLbl;
}

@end
