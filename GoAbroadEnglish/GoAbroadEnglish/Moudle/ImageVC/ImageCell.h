//
//  ImageCell.h
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCell : UITableViewCell

/// 标题
@property (nonatomic, strong) UILabel       *titleLbl;
@property (nonatomic, strong) UILabel       *desLbl;

- (void)reloadData:(NSInteger)currentRow selectRow:(NSInteger)selectRow title:(NSString *)titleString;

@end

NS_ASSUME_NONNULL_END
