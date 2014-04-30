//
//  MyTeacherCell.h
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTeacherCell;
@protocol MyTeacherCellDelegate <NSObject>
- (void) tableViewCell:(MyTeacherCell *)cell ClickedButton:(int) index;
@end

@class Order;
@class Teacher;
@class UIStartsImageView;
@interface MyTeacherCell : UITableViewCell
{
    UIButton            *headBtn;
    UILabel *nameLab;
    UILabel             *introduceLab;
    UIButton            *commBtn;
    UIButton            *compBtn;
}

@property (nonatomic, copy) Order    *order;
@property (nonatomic, assign) id<MyTeacherCellDelegate> delegate;


@end
