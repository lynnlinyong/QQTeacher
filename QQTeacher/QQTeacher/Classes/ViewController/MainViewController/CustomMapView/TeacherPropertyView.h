//
//  TeacherPropertyView.h
//  QQStudent
//
//  Created by lynn on 14-2-8.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeacherPropertyView;
@protocol TeacherPropertyViewDelegate <NSObject>

- (void) view:(TeacherPropertyView *) view clickedView:(id) clickView;

@end

@interface TeacherPropertyView : UIView
{
    UILabel           *introLab;
    UILabel           *nameLab;
    UIImageView       *headImgView;
}

@property (nonatomic, copy)   Student *student;
@property (nonatomic, retain) UILabel *introLab;
//@property (nonatomic, retain) UILabel *tsLab;
//@property (nonatomic, retain) UIStartsImageView *sImgView;
@property (nonatomic, retain) UILabel *nameLab;
@property (nonatomic, retain) UIImageView *headImgView;
@property (nonatomic, assign) id<TeacherPropertyViewDelegate> delegate;

//@property (nonatomic, retain) UIImageView *goodImgView;
//@property (nonatomic, retain) UIImageView *badImgView;
//@property (nonatomic, retain) UIImageView *idImageView;
//@property (nonatomic, retain) UILabel     *goodLab;
//@property (nonatomic, retain) UILabel     *badLab;
//@property (nonatomic, retain) UILabel     *orgNameLab;

@end
