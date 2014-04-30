//
//  MyTeacherCell.m
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "MyTeacherCell.h"
@implementation MyTeacherCell
@synthesize delegate;
@synthesize order;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame =  CGRectMake(10, 15, 50, 50);

        nameLab = [[UILabel alloc]init];
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.font  = [UIFont systemFontOfSize:14.f];
        nameLab.frame = CGRectMake(65, 5, 100, 20);
        [self addSubview:nameLab];
        
        
        introduceLab  = [[UILabel alloc]init];
        introduceLab.font = [UIFont systemFontOfSize:14.f];
        introduceLab.backgroundColor = [UIColor clearColor];
        introduceLab.frame = CGRectMake(65, 25, 100, 20);
        
        UIImage *chatImg = [UIImage imageNamed:@"mt_chat_normal_btn"];
        commBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
        commBtn.tag = 1;
        [commBtn setImage:chatImg
                 forState:UIControlStateNormal];
        [commBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        commBtn.frame = CGRectMake(65, 50, chatImg.size.width, chatImg.size.height);
        
        UIImage *cmpImg = [UIImage imageNamed:@"mt_confirm_normal_btn"];
        compBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
        compBtn.tag = 2;
        [compBtn setImage:cmpImg
                 forState:UIControlStateNormal];
        [compBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        compBtn.frame = CGRectMake(110, 50, cmpImg.size.width, cmpImg.size.height);
        
        [self addSubview:headBtn];
        [self addSubview:introduceLab];
        [self addSubview:commBtn];
        [self addSubview:compBtn];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) dealloc
{
    [nameLab release];
    [introduceLab  release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) setOrder:(Order *)tOrder
{
    Student *student = tOrder.student;
    
    nameLab.text = student.nickName;
    
    if (student.gender.intValue == 1)
    {
        [headBtn setImage:[UIImage circleImage:[UIImage imageNamed:@"s_boy"]
                                     withParam:0
                                     withColor:[UIColor colorWithHexString:@"#73CCAD"]]
                 forState:UIControlStateNormal];
        introduceLab.text = [NSString stringWithFormat:@"男  %@", student.grade];
    }
    else
    {
        [headBtn setImage:[UIImage circleImage:[UIImage imageNamed:@"s_girl"]
                                     withParam:0
                                     withColor:[UIColor colorWithHexString:@"#FF9800"]]
                 forState:UIControlStateNormal];
        introduceLab.text = [NSString stringWithFormat:@"女  %@", student.grade];
    }
    
    order = nil;
    order = [tOrder copy];
}

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    UIButton *btn = sender;
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(tableViewCell:ClickedButton:)])
        {
            [delegate tableViewCell:self ClickedButton:btn.tag];
        }
    }
}

@end
