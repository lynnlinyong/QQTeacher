//
//  TeacherPropertyView.m
//  QQStudent
//
//  Created by lynn on 14-2-8.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "TeacherPropertyView.h"

@implementation TeacherPropertyView
@synthesize introLab;
@synthesize nameLab;
//@synthesize sImgView;
@synthesize headImgView;
@synthesize delegate;
@synthesize student;
//@synthesize goodLab;
//@synthesize badLab;
//@synthesize goodImgView;
//@synthesize badImgView;
//@synthesize idImageView;
//@synthesize orgNameLab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float width = self.frame.size.width;
        
        headImgView = [[UIImageView alloc]init];
        headImgView.frame = CGRectMake(0, 0, 50, 50);
        [self addSubview:headImgView];
        
        nameLab = [[UILabel alloc]init];
        nameLab.frame = CGRectMake(60, 0, width-55, 20);
        nameLab.font  = [UIFont systemFontOfSize:12.f];
        nameLab.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLab];
        
        introLab = [[UILabel alloc]init];
        introLab.frame = CGRectMake(60, 20, width-55, 20);
        introLab.font  = [UIFont systemFontOfSize:12.f];
        introLab.backgroundColor = [UIColor clearColor];
        [self addSubview:introLab];
    }
    return self;
}

- (void) dealloc
{
    [student release];
    [nameLab     release];
    [introLab    release];
    [headImgView release];
    [super dealloc];
}

- (void) setStudent:(Student *)sObj
{
    student = nil;
    student = [sObj copy];
    
    nameLab.text = student.nickName;
    
    if (student.gender.intValue == 1)
    {
        self.headImgView.image = [UIImage imageNamed:@"s_boy"];
        self.introLab.text = [NSString stringWithFormat:@"男  %@", student.grade];
    }
    else
    {
        self.headImgView.image = [UIImage imageNamed:@"s_girl"];
        self.introLab.text = [NSString stringWithFormat:@"女  %@", student.grade];
    }
}

@end
