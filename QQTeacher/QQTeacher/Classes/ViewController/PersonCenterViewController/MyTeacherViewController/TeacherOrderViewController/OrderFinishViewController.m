//
//  OrderFinishViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-14.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "OrderFinishViewController.h"

@interface OrderFinishViewController ()

@end

@implementation OrderFinishViewController
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
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"结单审批申请"];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    finishOrderTab.delegate = nil;
    finishOrderTab.dataSource = nil;
    
    finishOrderTab = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void) dealloc
{
    [payLab release];
    [payFld release];
    [backMoneyLab release];
    [finishOrderTab release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action

- (void) initUI
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    
    finishOrderTab = [[UIGridView alloc]init];
    finishOrderTab.uiGridViewDelegate = self;
    finishOrderTab.backgroundColor = [UIColor clearColor];
    if ([finishOrderTab respondsToSelector:@selector(setSeparatorInset:)]) {
        [finishOrderTab setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UILabel *payInfoLab = [[UILabel alloc]init];
    payInfoLab.text  = @"消费金额:";
    payInfoLab.font  = [UIFont systemFontOfSize:14.f];
    payInfoLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:payInfoLab];
    
    UILabel *backInfoLab = [[UILabel alloc]init];
    backInfoLab.text  = @"应退金额:";
    backInfoLab.font  = [UIFont systemFontOfSize:14.f];
    backInfoLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backInfoLab];
    
    payLab = [[UILabel alloc]init];
    payLab.text      = @"￥";
    payLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
    payLab.font      = [UIFont systemFontOfSize:15.f];
    payLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:payLab];

    payFld = [[UITextField alloc]init];
    payFld.delegate  = self;
    payFld.text      = [NSString stringWithFormat:@" %d",order.totalMoney.intValue];
    payFld.textColor = [UIColor colorWithHexString:@"#ff6600"];
    payFld.font      = [UIFont systemFontOfSize:15.f];
    payFld.borderStyle = UITextBorderStyleNone;
    payFld.backgroundColor = [UIColor whiteColor];
    
    backMoneyLab = [[UILabel alloc]init];
    backMoneyLab.text  = [NSString stringWithFormat:@"￥  %@", order.backMoney];
    backMoneyLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
    backMoneyLab.font      = [UIFont systemFontOfSize:15.f];
    backMoneyLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backMoneyLab];
    
    UIImage *loginImg  = [UIImage imageNamed:@"normal_btn"];
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag = 1;
    [okBtn setTitle:@"完成,等待学生家长审批"
           forState:UIControlStateNormal];
    [okBtn setBackgroundImage:loginImg
                     forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                    forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            LBorderView *infoView = [[LBorderView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(18, 60+42, 320-36, 204)
                                                                             isBackView:NO]];
            infoView.borderType   = BorderTypeSolid;
            infoView.dashPattern  = 8;
            infoView.spacePattern = 8;
            infoView.borderWidth  = 1;
            infoView.cornerRadius = 5;
            infoView.alpha = 1.0;
            infoView.borderColor     = [UIColor whiteColor];
            infoView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:infoView];
            [infoView release];
            
            finishOrderTab.frame = [UIView fitCGRect:CGRectMake(20, 60+44, 320-40, 200)
                                          isBackView:NO];
            [self scrollTableToFoot:NO];
            finishOrderTab.scrollEnabled  = NO;
            [self.view addSubview:finishOrderTab];
            
            payInfoLab.frame     = [UIView fitCGRect:CGRectMake(30, 260+44-20, 80, 20)
                                          isBackView:NO];
            backInfoLab.frame    = [UIView fitCGRect:CGRectMake(30, 290+44-20, 80, 20)
                                          isBackView:NO];
            payLab.frame = [UIView fitCGRect:CGRectMake(100, 260+44-20, 15, 20)
                                  isBackView:NO];
            UIView *payFldBgView = [[UIView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(125, 255+44-20, 80, 30)
                                                                       isBackView:NO]];
            payFldBgView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:payFldBgView];
            [payFldBgView release];
            
            payFld.frame = [UIView fitCGRect:CGRectMake(125, 260+44-20, 80, 20)
                                  isBackView:NO];
            [self.view addSubview:payFld];
            
            backMoneyLab.frame = [UIView fitCGRect:CGRectMake(100, 290+44-20, 140, 20)
                                        isBackView:NO];
            okBtn.frame = [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2, 320+44,
                                                       loginImg.size.width, loginImg.size.height)
                                 isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            LBorderView *infoView = [[LBorderView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(18, 60+42, 320-36, 204)
                                                                             isBackView:NO]];
            infoView.borderType   = BorderTypeSolid;
            infoView.dashPattern  = 8;
            infoView.spacePattern = 8;
            infoView.borderWidth  = 1;
            infoView.cornerRadius = 5;
            infoView.alpha = 1.0;
            infoView.borderColor     = [UIColor whiteColor];
            infoView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:infoView];
            [infoView release];

            finishOrderTab.frame = [UIView fitCGRect:CGRectMake(20, 60+44, 320-40, 200)
                                          isBackView:NO];
            [self scrollTableToFoot:NO];
            finishOrderTab.scrollEnabled  = NO;
            [self.view addSubview:finishOrderTab];
            
            payInfoLab.frame = [UIView fitCGRect:CGRectMake(30, 260+44, 80, 20)
                                      isBackView:NO];
            backInfoLab.frame = [UIView fitCGRect:CGRectMake(30, 290+44, 80, 20)
                                       isBackView:NO];
            payLab.frame = [UIView fitCGRect:CGRectMake(100, 260+44, 15, 20)
                                  isBackView:NO];
            UIView *payFldBgView = [[UIView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(125, 255+44, 80, 30)
                                                                       isBackView:NO]];
            payFldBgView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:payFldBgView];
            [payFldBgView release];
            
            payFld.frame = [UIView fitCGRect:CGRectMake(125, 260+44, 80, 20)
                                  isBackView:NO];
            [self.view addSubview:payFld];
            backMoneyLab.frame = [UIView fitCGRect:CGRectMake(100, 290+44, 140, 20)
                                        isBackView:NO];
            okBtn.frame = [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2, 320+44+20,
                                                       loginImg.size.width, loginImg.size.height)
                                 isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            LBorderView *infoView = [[LBorderView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(18, 38, 320-36, 204)
                                                                             isBackView:NO]];
            infoView.borderType   = BorderTypeSolid;
            infoView.dashPattern  = 8;
            infoView.spacePattern = 8;
            infoView.borderWidth  = 1;
            infoView.cornerRadius = 5;
            infoView.alpha = 1.0;
            infoView.borderColor     = [UIColor whiteColor];
            infoView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:infoView];
            [infoView release];
            
            finishOrderTab.frame = [UIView fitCGRect:CGRectMake(20, 40, 320-40, 200)
                                          isBackView:NO];
            [self scrollTableToFoot:NO];
            finishOrderTab.scrollEnabled  = NO;
            [self.view addSubview:finishOrderTab];
            
            payInfoLab.frame = [UIView fitCGRect:CGRectMake(30, 270, 80, 20)
                                      isBackView:NO];
            backInfoLab.frame = [UIView fitCGRect:CGRectMake(30, 300, 80, 20)
                                       isBackView:NO];
            payLab.frame = [UIView fitCGRect:CGRectMake(100, 270, 15, 20)
                                  isBackView:NO];
            UIView *payFldBgView = [[UIView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(125, 265, 80, 30)
                                                                       isBackView:NO]];
            payFldBgView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:payFldBgView];
            [payFldBgView release];
            
            payFld.frame = [UIView fitCGRect:CGRectMake(125, 270, 80, 20)
                                  isBackView:NO];
            [self.view addSubview:payFld];
            backMoneyLab.frame = [UIView fitCGRect:CGRectMake(100, 300, 140, 20)
                                        isBackView:NO];
            okBtn.frame = [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2, 330+20, loginImg.size.width, loginImg.size.height)
                                 isBackView:NO];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            LBorderView *infoView = [[LBorderView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(18, 58, 320-36, 204)
                                                                             isBackView:NO]];
            infoView.borderType   = BorderTypeSolid;
            infoView.dashPattern  = 8;
            infoView.spacePattern = 8;
            infoView.borderWidth  = 1;
            infoView.cornerRadius = 5;
            infoView.alpha = 1.0;
            infoView.borderColor     = [UIColor whiteColor];
            infoView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:infoView];
            [infoView release];
            
            finishOrderTab.frame = [UIView fitCGRect:CGRectMake(20, 60, 320-40, 200)
                                          isBackView:NO];
            [self scrollTableToFoot:NO];
            finishOrderTab.scrollEnabled  = NO;
            [self.view addSubview:finishOrderTab];
            
            payInfoLab.frame = [UIView fitCGRect:CGRectMake(30, 250+20, 80, 20)
                                      isBackView:NO];
            backInfoLab.frame = [UIView fitCGRect:CGRectMake(30, 280+20, 80, 20)
                                       isBackView:NO];
            payLab.frame = [UIView fitCGRect:CGRectMake(100, 250+20, 15, 20)
                                  isBackView:NO];
            
            UIView *payFldBgView = [[UIView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(125, 245+20, 80, 30)
                                                                      isBackView:NO]];
            payFldBgView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:payFldBgView];
            [payFldBgView release];
            
            payFld.frame = [UIView fitCGRect:CGRectMake(125, 250+20, 80, 20)
                                  isBackView:NO];
            [self.view addSubview:payFld];
            
            backMoneyLab.frame = [UIView fitCGRect:CGRectMake(100, 280+20, 140, 20)
                                        isBackView:NO];
            okBtn.frame = [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2, 320+20, loginImg.size.width, loginImg.size.height)
                                 isBackView:NO];
        }
    }
    [backInfoLab release];
    [payInfoLab release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doValueChanged:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
}

- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [finishOrderTab numberOfSections];
    if (s<1) return;
    NSInteger r = [finishOrderTab numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [finishOrderTab scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void) doValueChanged:(NSNotification *) notice
{
    if (payFld.text.length==0)
    {
        return;
    }
    
    if (payFld.text.floatValue>order.totalMoney.floatValue)
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"消费金额不能大于总金额!"
                        delegate:self
               otherButtonTitles:@"确定",nil];
        return;
    }
    
    CGFloat backMoney = order.totalMoney.floatValue-payFld.text.floatValue;
    backMoneyLab.text = [NSString stringWithFormat:@"￥ %.2f", backMoney];
}

//判断是否为整形
- (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
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
#pragma mark - UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveViewWhenViewHidden:okBtn parent:self.view];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self repickView:self.view];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - UIViewController Custom Methods
- (void) repickView:(UIView *)parent
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    CGRect rect  = CGRectMake(parent.frame.origin.x,
                              parent.frame.origin.y+offset,
                              parent.frame.size.width,
                              parent.frame.size.height);
    parent.frame = rect;
    
    [UIView commitAnimations];
    
    offset = 0;
}

- (void) moveViewWhenViewHidden:(UIView *)view parent:(UIView *) parentView
{
    //键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    offset = 180;
    
    int width  = parentView.frame.size.width;
    int height = parentView.frame.size.height;
    CGRect rect= CGRectMake(parentView.frame.origin.x,
                            parentView.frame.origin.y-offset,width, height);
    parentView.frame = rect;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    if( ![self isPureInt:payFld.text] || ![self isPureFloat:payFld.text])
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"消费金额必须输入数字!"
                        delegate:self
               otherButtonTitles:@"确定", nil];
        return;
    }
    
    if (payFld.text.floatValue>order.totalMoney.floatValue)
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"消费金额不能大于总金额!"
                        delegate:self
               otherButtonTitles:@"确定",nil];
        return;
    }
    
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
    
    CGFloat backMoney  = order.totalMoney.floatValue-payFld.text.floatValue;
    
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd,TEACHER];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"orderid",@"xfamount",@"tfamount",@"sessid",nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"submitApply",order.orderId,payFld.text,
                                                  [NSString stringWithFormat:@"%f", backMoney],ssid, nil];
    CLog(@"values:%@", valuesArr);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestAsyncSuccessed:)];
    [request setDidFailSelector:@selector(requestAsyncFailed:)];
    for (int i=0; i<paramsArr.count; i++)
    {
        if ([[paramsArr objectAtIndex:i] isEqual:UPLOAD_FILE])
        {
            NSDictionary *fileDic = [valuesArr objectAtIndex:i];
            NSString *fileParam   = [[fileDic allKeys] objectAtIndex:0];
            NSString *filePath    = [[fileDic allValues]objectAtIndex:0];
            [request setFile:filePath forKey:fileParam];
            continue;
        }
        
        [request setPostValue:[valuesArr objectAtIndex:i]
                       forKey:[paramsArr objectAtIndex:i]];
    }
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"Content-Type"
                        value:@"text/xml; charset=utf-8"];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark - ServerRequest Delegate
- (void) requestAsyncFailed:(ASIHTTPRequest *)request
{
    [self showAlertWithTitle:@"提示"
                         tag:1
                     message:@"网络繁忙"
                    delegate:self
           otherButtonTitles:@"确定",nil];
    
    CLog(@"***********Result****************");
    CLog(@"ERROR");
    CLog(@"***********Result****************");
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
}

- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
    
    NSData   *resVal = [request responseData];
    if (resVal )
    {
        NSDictionary *resDic   = [NSJSONSerialization JSONObjectWithData:resVal
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];

        NSArray      *keysArr  = [resDic allKeys];
        NSArray      *valsArr  = [resDic allValues];
        CLog(@"***********Result****************");
        for (int i=0; i<keysArr.count; i++)
        {
            CLog(@"%@=%@", [keysArr objectAtIndex:i], [valsArr objectAtIndex:i]);
        }
        CLog(@"***********Result****************");
        
        NSNumber *errorid = [resDic objectForKey:@"errorid"];
        if (errorid.intValue == 0)
        {
            CLog(@"Submit Order Success!");
            
            //返回上一页
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *errorMsg = [resDic objectForKey:@"message"];
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:[NSString stringWithFormat:@"错误码%@,%@",errorid,errorMsg]
                            delegate:self
                   otherButtonTitles:@"确定",nil];
            
            //重复登录
            if (errorid.intValue==2)
            {
                //清除sessid,清除登录状态,回到地图页
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SSID];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGINE_SUCCESS];
                [AppDelegate popToMainViewController];
            }
        }
    }
}
@end
