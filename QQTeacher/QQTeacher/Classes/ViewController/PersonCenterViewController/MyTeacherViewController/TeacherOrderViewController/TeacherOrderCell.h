//
//  TeacherOrderCell.h
//  QQStudent
//
//  Created by lynn on 14-2-12.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeacherOrderCell;
@protocol TeacherOrderCellDelegate <NSObject>
- (void) cell:(TeacherOrderCell *) cell buttonTag:(NSInteger) tag;
@end

@class CommentView;
@interface TeacherOrderCell : UITableViewCell
{
    UILabel  *studyPosLab;
    UILabel  *orderDateLab;
    UILabel  *orderStudyTimeLab;
    UILabel  *orderSalaryLab;
    UILabel  *orderTotalMoneyLab;
    UILabel  *orderPayMoneyLab;
    UILabel  *orderCommentLab;
    UIImageView *commentImgView;
//    UILabel  *noConfirmLab;
    UILabel  *finishLab;
    
    UIButton *ctrBtn;
//    UIButton *finishBtn;
//    UIButton *updateBtn;
    
//    NSMutableArray  *buttonArray;
    UIView *parentView;
    UIImageView *bgLabImageView;
}
//@property (nonatomic, retain) CommentView *commView;
@property (nonatomic, copy)   Order *order;
//@property (nonatomic, retain) UIButton *commentBtn;
@property (nonatomic, assign) id<TeacherOrderCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withParent:(UIView *) pView;
@end
