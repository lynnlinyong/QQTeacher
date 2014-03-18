//
//  LatlyViewCell.m
//  QQStudent
//
//  Created by lynn on 14-3-1.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "AssistentCell.h"

@implementation AssistentCell
@synthesize applyDic;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        headImgView = [[TTImageView alloc]init];
        headImgView.delegate = self;
        headImgView.defaultImage = [UIImage imageNamed:@"s_girl"];
        headImgView.frame = CGRectMake(5, 15, 50, 50);
        [self addSubview:headImgView];
        
        nameLab = [[UILabel alloc]init];
        nameLab.font  = [UIFont systemFontOfSize:12.f];
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.frame = CGRectMake(70, 10, 60, 20);
        [self addSubview:nameLab];
        
        infoLab = [[UILabel alloc]init];
        infoLab.font  = [UIFont systemFontOfSize:12.f];
        infoLab.backgroundColor = [UIColor clearColor];
        infoLab.frame = CGRectMake(70, 30, 160, 20);
        [self addSubview:infoLab];
        
        timeLab = [[UILabel alloc]init];
        timeLab.textAlignment = NSTextAlignmentRight;
        timeLab.font  = [UIFont systemFontOfSize:12.f];
        timeLab.backgroundColor = [UIColor clearColor];
        timeLab.frame = CGRectMake(320-60-10, 30, 60, 20);
        [self addSubview:timeLab];
        
        UIImage *phoneImg  = [UIImage imageNamed:@"stp_cc_tel_btn"];
        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneBtn.tag   = 0;
        [phoneBtn setImage:phoneImg
                  forState:UIControlStateNormal];
        phoneBtn.frame = CGRectMake(70, 55, phoneImg.size.width, phoneImg.size.height);
        [phoneBtn addTarget:self
                     action:@selector(tapGestureRecongnizer:)
           forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:phoneBtn];
        
        UIImage *selImg  = [UIImage imageNamed:@"stp_cc_sel_btn"];
        UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selBtn setImage:selImg
                forState:UIControlStateNormal];
        selBtn.tag = 1;
        selBtn.frame = CGRectMake(70+10+phoneImg.size.width, 55, selImg.size.width, selImg.size.height);
        [selBtn addTarget:self
                   action:@selector(tapGestureRecongnizer:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selBtn];
    }
    return self;
}

- (void) dealloc
{
    [applyDic release];
    [headImgView release];
    [nameLab release];
    [infoLab release];
    [timeLab release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setApplyDic:(NSDictionary *)dic
{
    nameLab.text  = [dic objectForKey:@"cc_name"];
    
    infoLab.text  = @"向您发出一条申请助教请求";

    NSString *webAdd  = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    headImgView.URL   = [NSString stringWithFormat:@"%@%@",webAdd,[dic objectForKey:@"cc_icon"]];
    
    timeLab.text  = [dic objectForKey:@"apply_time"];
    
    applyDic = [dic copy];
}

#pragma mark -
#pragma mark - TTImageViewDelegate
- (void)imageView:(TTImageView*)imageView didLoadImage:(UIImage*)image
{
    headImgView.defaultImage = [UIImage circleImage:image
                                          withParam:0
                                          withColor:[UIColor orangeColor]];
    headImgView.URL = @"";
}

- (void)imageView:(TTImageView*)imageView didFailLoadWithError:(NSError*)error
{
    
}

- (void) tapGestureRecongnizer:(id)sender
{
    UIButton *btn = sender;
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(view:clickedIndex:)])
        {
            [delegate view:self clickedIndex:btn.tag];
        }
    }
}
@end
