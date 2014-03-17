//
//  OrderConfirmViewController.m
//  QQTeacher
//
//  Created by Lynn on 14-3-16.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import "OrderConfirmViewController.h"

@interface OrderConfirmViewController ()

@end

@implementation OrderConfirmViewController
@synthesize order;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [gdView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UIImage *bottomImg= [UIImage imageNamed:@"dialog_bottom"];
    UIImage *titleImg         = [UIImage imageNamed:@"dialog_title"];
    self.view.frame = CGRectMake(0, 0,
                                 titleImg.size.width,270+bottomImg.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.frame = CGRectMake(-2, -titleImg.size.height,
                                    self.view.frame.size.width+5,
                                    titleImg.size.height);
    titleImgView.image = titleImg;
    [self.view addSubview:titleImgView];
    [titleImgView release];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text  = @"学生修改了订单信息";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame= CGRectMake(-2, -titleImg.size.height,
                               self.view.frame.size.width+5, titleImg.size.height);
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    [titleLab release];
    
    gdView = [[UIGridView alloc]init];
    gdView.scrollEnabled = NO;
    gdView.uiGridViewDelegate = self;
    gdView.frame = CGRectMake(0, 30, 240, 210);
    gdView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
#pragma mark - UIGridViewDelegate
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    
}

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return 120;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    return 40;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 2;
}

- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return 10;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    UIGridViewCell *cell = [[[UIGridViewCell alloc]init]autorelease];
    switch (rowIndex)
    {
        case 0:
        {
            switch (columnIndex)
            {
                case 0:
                {
                    UILabel *infoLab = [[UILabel alloc]init];
                    infoLab.text = @"开始日期";
                    infoLab.font = [UIFont systemFontOfSize:14.f];
                    infoLab.frame= CGRectMake(10, 10, 110, 20);
                    infoLab.textAlignment = NSTextAlignmentLeft;
                    infoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:infoLab];
                    [infoLab release];
                    break;
                }
                case 1:
                {
                    UILabel *infoLab = [[UILabel alloc]init];
                    infoLab.text = order.orderStudyStartDate;
                    infoLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
                    infoLab.font = [UIFont systemFontOfSize:14.f];
                    infoLab.frame= CGRectMake(10, 10, 110, 20);
                    infoLab.textAlignment = NSTextAlignmentLeft;
                    infoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:infoLab];
                    [infoLab release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (columnIndex)
            {
                case 0:
                {
                    UILabel *infoLab = [[UILabel alloc]init];
                    infoLab.text = @"每小时课酬标准";
                    infoLab.font = [UIFont systemFontOfSize:14.f];
                    infoLab.frame= CGRectMake(10, 10, 110, 20);
                    infoLab.textAlignment = NSTextAlignmentLeft;
                    infoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:infoLab];
                    [infoLab release];
                    break;
                }
                case 1:
                {
                    UILabel *infoLab = [[UILabel alloc]init];
                    infoLab.text = [NSString stringWithFormat:@"￥%@",order.everyTimesMoney];
                    infoLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
                    infoLab.font = [UIFont systemFontOfSize:14.f];
                    infoLab.frame= CGRectMake(10, 10, 110, 20);
                    infoLab.textAlignment = NSTextAlignmentLeft;
                    infoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:infoLab];
                    [infoLab release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch (columnIndex)
            {
                case 0:
                {
                    UILabel *infoLab = [[UILabel alloc]init];
                    infoLab.text = @"预计辅导小时数";
                    infoLab.frame= CGRectMake(10, 10, 110, 20);
                    infoLab.font = [UIFont systemFontOfSize:14.f];
                    infoLab.textAlignment   = NSTextAlignmentLeft;
                    infoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:infoLab];
                    [infoLab release];
                    break;
                }
                case 1:
                {
                    UILabel *infoLab = [[UILabel alloc]init];
                    infoLab.text = [NSString stringWithFormat:@"%@小时",order.orderStudyTimes];
                    infoLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
                    infoLab.font = [UIFont systemFontOfSize:14.f];
                    infoLab.frame= CGRectMake(10, 10, 110, 20);
                    infoLab.textAlignment = NSTextAlignmentLeft;
                    infoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:infoLab];
                    [infoLab release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 3:
        {
            switch (columnIndex)
            {
                case 0:
                {
                    UILabel *infoLab = [[UILabel alloc]init];
                    infoLab.text = @"授课地址";
                    infoLab.frame= CGRectMake(10, 10, 110, 20);
                    infoLab.font = [UIFont systemFontOfSize:14.f];
                    infoLab.textAlignment   = NSTextAlignmentLeft;
                    infoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:infoLab];
                    [infoLab release];
                    break;
                }
                case 1:
                {
                    UILabel *infoLab = [[UILabel alloc]init];
                    infoLab.text = order.orderStudyPos;
                    infoLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
                    infoLab.font = [UIFont systemFontOfSize:14.f];
                    infoLab.frame= CGRectMake(10, 10, 110, 20);
                    infoLab.textAlignment = NSTextAlignmentLeft;
                    infoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:infoLab];
                    [infoLab release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 4:
        {
            switch (columnIndex)
            {
                case 0:
                {
                    UILabel *infoLab = [[UILabel alloc]init];
                    infoLab.text = @"总金额数";
                    infoLab.frame= CGRectMake(10, 10, 100, 20);
                    infoLab.font = [UIFont systemFontOfSize:14.f];
                    infoLab.textAlignment = NSTextAlignmentLeft;
                    infoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:infoLab];
                    [infoLab release];
                    break;
                }
                case 1:
                {
                    UILabel *infoLab = [[UILabel alloc]init];
                    infoLab.text = [NSString stringWithFormat:@"￥%@", order.totalMoney];
                    infoLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
                    infoLab.font = [UIFont systemFontOfSize:14.f];
                    infoLab.frame= CGRectMake(10, 10, 110, 20);
                    infoLab.textAlignment = NSTextAlignmentLeft;
                    infoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:infoLab];
                    [infoLab release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    UIButton *btn = sender;
    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:btn.tag],@"TAG",order,@"ORDER", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setOrderConfirmNotice"
                                                        object:nil
                                                      userInfo:userDic];
}
@end
