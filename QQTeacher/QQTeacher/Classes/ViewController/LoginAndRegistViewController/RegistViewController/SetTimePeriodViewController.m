//
//  SetTimePeriodViewController.m
//  QQTeacher
//
//  Created by Lynn on 14-3-12.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import "SetTimePeriodViewController.h"

@interface SetTimePeriodViewController ()

@end

@implementation SetTimePeriodViewController
@synthesize setTimesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化UI
    [self initUI];
}

- (void) dealloc
{
//    [selArr release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UIImage *bottomImg = [UIImage imageNamed:@"dialog_bottom"];
    UIImage *titleImg  = [UIImage imageNamed:@"dialog_title"];
    self.view.frame    = CGRectMake(0, 0,
                                    titleImg.size.width,
                                    300+bottomImg.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.frame = CGRectMake(-2, -titleImg.size.height,
                                    self.view.frame.size.width+5, titleImg.size.height);
    titleImgView.image = titleImg;
    [self.view addSubview:titleImgView];
    [titleImgView release];
    
    UILabel *titleLab  = [[UILabel alloc]init];
    titleLab.text      = @"设置时段";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame= CGRectMake(0, -titleImg.size.height,
                               self.view.frame.size.width+5, titleImg.size.height);
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    [titleLab release];
    
    gdView = [[UIGridView alloc]init];
    gdView.isTimePeriod = YES;
    gdView.uiGridViewDelegate = self;
    gdView.separatorStyle = UITableViewCellSeparatorStyleNone;
    gdView.scrollEnabled = YES;
    gdView.frame = CGRectMake(2.5, 13, 240, 300);
    [self.view addSubview:gdView];
    
    UIImageView *bottomImgView = [[UIImageView alloc]init];
    bottomImgView.image = bottomImg;
    bottomImgView.frame = CGRectMake(-2,
                                     self.view.frame.size.height-bottomImg.size.height+5,
                                     self.view.frame.size.width+4, bottomImg.size.height);
    [self.view addSubview:bottomImgView];
    [bottomImgView release];
    
    UIImage *okBtnImg = [UIImage imageNamed:@"dialog_ok_normal_btn"];
    UIButton *okBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag   = 0;
    [okBtn setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    okBtn.frame = CGRectMake(self.view.frame.size.width/2-okBtnImg.size.width-10,
                             self.view.frame.size.height-bottomImg.size.height+11,
                             okBtnImg.size.width,
                             okBtnImg.size.height);
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"dialog_ok_normal_btn"]
                     forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"dialog_ok_hlight_btn"]
                     forState:UIControlStateHighlighted];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIImage *cancelImg  = [UIImage imageNamed:@"dialog_cancel_normal_btn"];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.tag = 1;
    [cancelBtn setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    cancelBtn.frame = CGRectMake(self.view.frame.size.width/2+10,
                                 self.view.frame.size.height-bottomImg.size.height+11,
                                 cancelImg.size.width,
                                 cancelImg.size.height);
    [cancelBtn setTitle:@"取消"
               forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"dialog_cancel_normal_btn"]
                         forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"dialog_cancel_hlight_btn"]
                         forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

#pragma mark - 
#pragma mark - UIGrideViewDelegate
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
}

- (void) cellPressGridView:(UIGridViewCell *) cell didSelectRowAt:(int)rowIndex AndColumnAt:(int) columnIndex;
{
    if (rowIndex==0||columnIndex==0)
        return;
    
    NSArray *subsArr = cell.subviews;
    for (UIView *view in subsArr)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            int index = (rowIndex-1)*3+(columnIndex-1);
            view.hidden = !view.hidden;
            if (view.hidden==NO)
                [setTimesArray setObject:@"1" atIndexedSubscript:index];
            else
                [setTimesArray setObject:@"0" atIndexedSubscript:index];
        }
    }
}

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return 60;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    return 35;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 4;
}

- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return 8*4;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    NSString *idString = @"idString";
    UIGridViewCell *cell = [grid dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[[UIGridViewCell alloc]init]autorelease];
    }
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, 60, 1);
    view.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"];
    [cell addSubview:view];
    [view release];
    
    if (rowIndex==7)
    {
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 34, 60, 1);
        view.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"];
        [cell addSubview:view];
        [view release];
    }
    
    if (columnIndex==0)
    {
        UIView *splitStartView = [[UIView alloc]init];
        splitStartView.frame = CGRectMake(0, 0, 1, 35);
        splitStartView.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"];
        [cell addSubview:splitStartView];
        [splitStartView release];
    }
    
    UIView *splitEndView = [[UIView alloc]init];
    splitEndView.frame = CGRectMake(59, 0, 1, 35);
    splitEndView.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"];
    [cell addSubview:splitEndView];
    [splitEndView release];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *checkImgView = [[UIImageView alloc]init];
    if (rowIndex==0||columnIndex==0)
        checkImgView.hidden= YES;
    else
    {
        int index = (rowIndex-1)*3+(columnIndex-1);
        NSString *num = [setTimesArray objectAtIndex:index];
        if (num.intValue==1)
            checkImgView.hidden= NO;
        else
            checkImgView.hidden= YES;
    }
    checkImgView.frame = CGRectMake(12, 2, 40, 35);
    checkImgView.image = [UIImage imageNamed:@"stp_checked"];
    [cell addSubview:checkImgView];
    [checkImgView release];
    
    switch (rowIndex)
    {
        case 0:
        {
            switch (columnIndex)
            {
                case 1:
                {
                    UILabel *dayLab = [[UILabel alloc]init];
                    dayLab.text  = @"上午";
                    dayLab.font  = [UIFont systemFontOfSize:11.f];
                    dayLab.frame = CGRectMake(3, 5, 54, 20);
                    dayLab.textAlignment = NSTextAlignmentLeft;
                    [cell addSubview:dayLab];
                    [dayLab release];
                    
                    UILabel *timeLab = [[UILabel alloc]init];
                    timeLab.text  = @"8:00-12:00";
                    timeLab.font  = [UIFont systemFontOfSize:9.f];
                    timeLab.frame = CGRectMake(3, 15, 54, 20);
                    timeLab.textAlignment = NSTextAlignmentLeft;
                    [cell addSubview:timeLab];
                    [timeLab release];
                    break;
                }
                case 2:
                {
                    UILabel *dayLab = [[UILabel alloc]init];
                    dayLab.text  = @"下午";
                    dayLab.font  = [UIFont systemFontOfSize:11.f];
                    dayLab.frame = CGRectMake(3, 5, 54, 20);
                    dayLab.textAlignment = NSTextAlignmentLeft;
                    [cell addSubview:dayLab];
                    [dayLab release];
                    
                    UILabel *timeLab = [[UILabel alloc]init];
                    timeLab.text  = @"12:00-18:00";
                    timeLab.font  = [UIFont systemFontOfSize:9.f];
                    timeLab.frame = CGRectMake(3, 15, 54, 20);
                    timeLab.textAlignment = NSTextAlignmentLeft;
                    [cell addSubview:timeLab];
                    [timeLab release];
                    break;
                }
                case 3:
                {
                    UILabel *dayLab = [[UILabel alloc]init];
                    dayLab.text  = @"晚上";
                    dayLab.font  = [UIFont systemFontOfSize:11.f];
                    dayLab.frame = CGRectMake(3, 5, 54, 20);
                    dayLab.textAlignment = NSTextAlignmentLeft;
                    [cell addSubview:dayLab];
                    [dayLab release];
                    
                    UILabel *timeLab = [[UILabel alloc]init];
                    timeLab.text  = @"18:00-22:00";
                    timeLab.font  = [UIFont systemFontOfSize:9.f];
                    timeLab.frame = CGRectMake(3, 15, 54, 20);
                    timeLab.textAlignment = NSTextAlignmentLeft;
                    [cell addSubview:timeLab];
                    [timeLab release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            if (columnIndex==0)
            {
                UILabel *contentLab = [[UILabel alloc]init];
                contentLab.text  = @"周一";
                contentLab.font  = [UIFont systemFontOfSize:13.f];
                contentLab.frame = CGRectMake(5, 7.5, 50, 20);
                contentLab.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:contentLab];
                [contentLab release];
            }
            break;
        }
        case 2:
        {
            if (columnIndex==0)
            {
                UILabel *contentLab = [[UILabel alloc]init];
                contentLab.text  = @"周二";
                contentLab.font  = [UIFont systemFontOfSize:13.f];
                contentLab.frame = CGRectMake(5, 7.5, 50, 20);
                contentLab.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:contentLab];
                [contentLab release];
            }
            break;
        }
        case 3:
        {
            if (columnIndex==0)
            {
                UILabel *contentLab = [[UILabel alloc]init];
                contentLab.text  = @"周三";
                contentLab.font  = [UIFont systemFontOfSize:13.f];
                contentLab.frame = CGRectMake(5, 7.5, 50, 20);
                contentLab.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:contentLab];
                [contentLab release];
            }
            break;
        }
        case 4:
        {
            if (columnIndex==0)
            {
                UILabel *contentLab = [[UILabel alloc]init];
                contentLab.text  = @"周四";
                contentLab.font  = [UIFont systemFontOfSize:13.f];
                contentLab.frame = CGRectMake(5, 7.5, 50, 20);
                contentLab.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:contentLab];
                [contentLab release];
            }
            break;
        }
        case 5:
        {
            if (columnIndex==0)
            {
                UILabel *contentLab = [[UILabel alloc]init];
                contentLab.text  = @"周五";
                contentLab.font  = [UIFont systemFontOfSize:13.f];
                contentLab.frame = CGRectMake(5, 7.5, 50, 20);
                contentLab.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:contentLab];
                [contentLab release];
            }
            break;
        }
        case 6:
        {
            if (columnIndex==0)
            {
                UILabel *contentLab = [[UILabel alloc]init];
                contentLab.text  = @"周六";
                contentLab.font  = [UIFont systemFontOfSize:13.f];
                contentLab.frame = CGRectMake(5, 7.5, 50, 20);
                contentLab.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:contentLab];
                [contentLab release];
            }
            break;
        }
        case 7:
        {
            if (columnIndex==0)
            {
                UILabel *contentLab = [[UILabel alloc]init];
                contentLab.text  = @"周日";
                contentLab.font  = [UIFont systemFontOfSize:13.f];
                contentLab.frame = CGRectMake(5, 7.5, 50, 20);
                contentLab.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:contentLab];
                [contentLab release];
            }
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 
#pragma mark - Custom Action
- (void) doButtonClicked:(id)sender
{
    UIButton *btn = sender;
    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:btn.tag],@"TAG",
                             setTimesArray,@"SELECT_TIME_DIC" ,nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECT_TIME_PERTIOD_NOTICE"
                                                        object:nil
                                                      userInfo:userDic];
}
@end
