//
//  PersonCenterViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "PersonCenterViewController.h"

@interface PersonCenterViewController ()

@end

@implementation PersonCenterViewController
@synthesize order;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"个人中心"];
    
    [self initBackBarItem];
    
    self.delegate = self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self checkSessidIsValid];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Custom Action
- (void) initBackBarItem
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = self;
}

- (void) checkSessidIsValid
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"updatelogin",ssid, nil];
    NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd, TEACHER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    for (int i=0; i<paramsArr.count; i++)
    {
        CLog(@"value:%@", [valuesArr objectAtIndex:i]);
        CLog(@"param:%@", [paramsArr objectAtIndex:i]);
        
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
        //                [request setTimeOutSeconds:10];
    }
    [request setRequestMethod:@"POST"];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"Content-Type"
                        value:@"text/xml; charset=utf-8"];
    [request startSynchronous];
    [request setDelegate:self];
    NSData *resVal = [request responseData];
    if (resVal )
    {
        NSDictionary *resDic   = [NSJSONSerialization JSONObjectWithData:resVal
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];
        NSString *eerid = [[resDic objectForKey:@"errorid"] copy];
        if (resDic)
        {
            if (eerid.intValue==0)
            {
                //获得最新个人信息
                CLog(@"get New Info:%@", resDic);
                NSDictionary *teacherDic = [resDic objectForKey:@"teacherInfo"];
                Teacher *teacher = [Teacher setTeacherProperty:teacherDic];

                NSData *teacherData = [NSKeyedArchiver archivedDataWithRootObject:teacher];
                [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                          forKey:TEACHER_INFO];
            }
            else
            {
    //            NSString *errorMsg = [resDic objectForKey:@"message"];
    //            [self showAlertWithTitle:@"提示"
    //                                 tag:4
    //                             message:[NSString stringWithFormat:@"错误码%@,%@",eerid,errorMsg]
    //                            delegate:[MainViewController getNavigationViewController]
    //                   otherButtonTitles:@"确定",nil];
            }
        }
        else
        {
    //        [self showAlertWithTitle:@"提示"
    //                             tag:3
    //                         message:@"获取数据失败!"
    //                        delegate:[MainViewController getNavigationViewController]
    //               otherButtonTitles:@"确定",nil];
        }
    }
}

#pragma mark -
#pragma mark - LeveyTabBarControllerDelegate
- (void)tabBarController:(LeveyTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 2)
    {
        [self initBackBarItem];
        
        MainViewController *mainVctr = [[MainViewController alloc]init];
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        [nav pushViewController:mainVctr animated:YES];
    }
    else
    {
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        nav.dataSource = nil;
    }
}

#pragma mark -
#pragma mark - CustomNavigationDataSource
- (UIBarButtonItem *)backBarButtomItem
{
    //设置返回按钮
    UIImage *backImg  = [UIImage imageNamed:@"nav_back_normal_btn@2x"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame     = CGRectMake(0, 0,
                                   50,
                                   30);
    [backBtn setBackgroundImage:backImg
                       forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_hlight_btn@2x"]
                       forState:UIControlStateHighlighted];
    [backBtn addTarget:self
                action:@selector(doBackBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text     = @"返回";
    titleLab.textColor= [UIColor whiteColor];
    titleLab.font     = [UIFont systemFontOfSize:12.f];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame = CGRectMake(8, 0,
                                50,
                                30);
    titleLab.backgroundColor = [UIColor clearColor];
    [backBtn addSubview:titleLab];
    [titleLab release];
    
    return [[UIBarButtonItem alloc]
            initWithCustomView:backBtn];
}

- (void) doBackBtnClicked:(id)sender
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    NSArray *viewCtrs = [nav viewControllers];
    for (UIViewController *vctr in viewCtrs)
    {
        if ([vctr isKindOfClass:[PersonCenterViewController class]])
        {
            PersonCenterViewController *pCvtr = (PersonCenterViewController *) vctr;
            [nav popToViewController:pCvtr animated:YES];
            [pCvtr setSelectedIndex:0];
        }
    }
}
@end
