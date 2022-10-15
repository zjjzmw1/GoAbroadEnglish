//
//  StudyCell.h
//  GoAbroadEnglish
//
//  Created by zhangmingwei on 2022/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudyCell : UITableViewCell

@property (nonatomic, strong) UILabel       *desLbl;

@property (nonatomic, copy) void (^clickLeftBlock) (void);

- (void)reloadData:(NSInteger)currentRow selectRow:(NSInteger)selectRow title:(NSString *)titleString;

@end

NS_ASSUME_NONNULL_END
