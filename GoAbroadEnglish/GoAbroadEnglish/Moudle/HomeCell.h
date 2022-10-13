//
//  HomeCell.h
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell : UITableViewCell

@property (nonatomic, copy) void (^clickLeftBlock) (void);
@property (nonatomic, copy) void (^clickRightBlock) (void);


/// 刷新数据
- (void)reloadData:(NSInteger)currentRow selectRow:(NSInteger)selectRow title:(NSString *)titleString;

@end

NS_ASSUME_NONNULL_END
