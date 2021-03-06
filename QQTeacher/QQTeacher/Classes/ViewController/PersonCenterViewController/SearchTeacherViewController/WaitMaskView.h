//
//  WaitMaskView.h
//  QQStudent
//
//  Created by lynn on 14-3-7.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Teacher;
@class TTImageView;
@class LBorderView;

@class WaitMaskView;
@protocol WaitMaskViewDelegate <NSObject>

- (void) timeOutView:(WaitMaskView *) view;
- (void) shareClicked:(WaitMaskView *) view;
@end

@interface WaitMaskView : UIView
{
    //top
//    TTImageView *headImgView;
//    UIStartsImageView *starImgView;
    UIView       *mainView;
    LBorderView  *bgView;
    
    UILabel *nameLab;
    UILabel *totalMoneyLab;
    UILabel *startDateLab;
    UILabel *gradeLab;
    UILabel *posLab;
//    UILabel *idNumsLab;
//    UILabel *fdStudentLab;
//    UILabel *sayLab;
//    UIImageView *sayImgView;
    UILabel *secondLab;
    
    
    //bottom
    UIImageView *sayHeadImgView;
    UIImageView *infoBgView;
    UIButton    *sendFrdBtn;
    UILabel     *infoSecondLab;
    
    int curSecond;
    NSTimer     *timer;
}

@property (nonatomic, copy) NSDictionary *userDic;
@property (nonatomic, retain) NSString *second;
@property (nonatomic, assign) id<WaitMaskViewDelegate> delegate;
@end
