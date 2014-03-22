//
//  SettingViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutSoftwareViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"设置";
        [self.tabBarItem setImage:[UIImage imageNamed:@"user_4_2"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    //初始化UI
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateEmailInfoNotice:)
                                                 name:@"updateEmailInfoNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateEmailNotice:)
                                                 name:@"updateEmailNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePhoneInfoNotice:)
                                                 name:@"updatePhoneInfoNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePhoneNotice:)
                                                 name:@"updatePhoneNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(suggestNotice:)
                                                 name:@"suggestNotice"
                                               object:nil];
    
    //注册设置每小时课酬消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSalaryFromSettingNotice:)
                                                 name:@"setSalaryFromSettingNotice"
                                               object:nil];
    
    //注册设置个人简介消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setPersonalInfoFromNotice:)
                                                 name:@"setPersonalInfoFromSettingNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCertitionNotice:)
                                                 name:@"setCertitionNotice"
                                               object:nil];
    
    //注册设置时间段消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectTimePeriodNotice:)
                                                 name:@"SELECT_TIME_PERTIOD_FROM_SETTING_NOTICE"
                                               object:nil];
    
    //注册隐藏选择头像消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hiddenHeadViewNotice:)
                                                 name:@"hiddenHeadViewFromSettingNotice"
                                               object:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MainViewController setNavTitle:@"个人中心"];
    [self initBackBarItem];

    ccResDic = nil;
    ccResDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"AssistentData"];
    if ([ccResDic isEqual:[NSNull null]])
        [self getJxzl];
    else
        [self getJxzl];
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void) viewDidDisappear:(BOOL)animated
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = nil;

    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    [teacher release];
    [phoneSw release];
    [locSw   release];
    [headUrl release];
    [salaryValLab release];
    [setTimeArray release];
    [headImgView  release];
    [assitentLab  release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initBackBarItem
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = self;
}

- (void) initUI
{
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
    teacher = [[NSKeyedUnarchiver unarchiveObjectWithData:teacherData] copy];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            setTab = [[UITableView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(0, 20, 320, 480-44-44)
                                                              isBackView:YES]
                                                 style:UITableViewStyleGrouped];        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            setTab = [[UITableView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(0, 20, 320, 480-44-44)
                                                              isBackView:YES]
                                                 style:UITableViewStyleGrouped];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            setTab = [[UITableView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(0, 0, 320, 480-44-44)
                                                              isBackView:YES]
                                                 style:UITableViewStyleGrouped];
            
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            setTab = [[UITableView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(0, 0, 320, 480-44-44)
                                                              isBackView:YES]
                                                 style:UITableViewStyleGrouped];
        }
    }
    if ([setTab respondsToSelector:@selector(setSeparatorInset:)]) {
        [setTab setSeparatorInset:UIEdgeInsetsZero];
    }
    setTab.delegate   = self;
    setTab.dataSource = self;
    [self.view addSubview:setTab];
    
    updateType = OtherUpdate;
    
    headUrl = [teacher.headUrl copy];
    
    setTimeArray = [[NSMutableArray alloc]init];
    setTimeArray = [[teacher.timePeriod componentsSeparatedByString:@","] mutableCopy];
    CLog(@"settimeArray:%@", setTimeArray);
}

- (void) getJxzl
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }

    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"viewstatus",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getJxzl",@"1",ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd, TEACHER];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    NSData   *resVal = [request requestSyncWith:kServerPostRequest
                                       paramDic:pDic
                                         urlStr:url];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic   = [resStr JSONValue];
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
        NSDictionary *ccDic = [[resDic objectForKey:@"cc"] copy];
        if (ccDic.count!=0)     //已签约
        {
            ccResDic = [resDic copy];
            
            [[NSUserDefaults standardUserDefaults] setObject:ccResDic
                                                      forKey:@"AssistentData"];
            
            [setTab reloadData];
        }
        else
        {
            ccResDic = nil;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AssistentData"];
            
            [setTab reloadData];
        }
    }
    else
    {
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

- (void) updateTeacherInfo
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSNumber *phoneNum;
    if (teacher.phoneStar)
        phoneNum = [NSNumber numberWithInt:1];
    else
        phoneNum = [NSNumber numberWithInt:0];
    
    NSNumber *locNum;
    if (teacher.locationStar)
        locNum = [NSNumber numberWithInt:1];
    else
        locNum = [NSNumber numberWithInt:0];
    
    NSNumber *listenNum;
    if (teacher.listenStar)
        listenNum = [NSNumber numberWithInt:1];
    else
        listenNum = [NSNumber numberWithInt:0];
    
    //更新个人资料
    NSString *salary = nil;
    if ([salaryValLab.text isEqualToString:@"师生协商"])
        salary = @"0";
    else
        salary = salaryValLab.text;
    
    NSArray *infosParamsArr = [NSArray arrayWithObjects:@"phone",@"email",@"icon",@"phone_stars",
                               @"pre_listening",@"location_stars",@"expenseValue",
                               @"time_period",@"info",@"certificates",nil];
    NSArray *infosValuesArr = [NSArray arrayWithObjects:phoneValLab.text,emailValLab.text,headUrl,
                               phoneNum,listenNum,locNum,
                               salary,
                               teacher.timePeriod,teacher.info,teacher.certArray,nil];
    NSDictionary *infosDic  = [NSDictionary dictionaryWithObjects:infosValuesArr
                                                          forKeys:infosParamsArr];
    NSString *infosJson = [infosDic JSONFragment];
    
    NSString *ssid   = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"infos",@"sessid",nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"upinfos",infosJson, ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    CLog(@"Dic:%@", pDic);
    
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate   = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@", webAddress,TEACHER];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

- (BOOL) isSetTimePeriod
{
    for (NSString *num in setTimeArray)
    {
        if (num.intValue == 1)
            return YES;
    }
    
    return NO;
}

- (void) uploadSuggest:(NSString *) content
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid   = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"text",@"sessid",nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"submitProposal",content,ssid, nil];
    
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate   = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@", webAddress,TEACHER];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

#pragma mark -
#pragma mark - CustomNavigationDataSource
- (UIBarButtonItem *) backBarButtomItem
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

#pragma mark -
#pragma mark - Notice Event
- (void) selectTimePeriodNotice:(NSNotification *) sender
{
    NSInteger tag = ((NSNumber *)[sender.userInfo objectForKey:@"TAG"]).integerValue;
    if (tag==0) //确定
    {
        for (int i=0; i<21; i++)
            [setTimeArray setObject:@"0" atIndexedSubscript:i];
        
        isSetTimeStatus = YES;
        setTimeArray = [((NSMutableArray *)[sender.userInfo objectForKey:@"SELECT_TIME_DIC"]) mutableCopy];
        
        NSMutableString *timePdStr = [[NSMutableString alloc]init];
        for (int i=0; i<20; i++)
             [timePdStr appendFormat:@"%@,",[setTimeArray objectAtIndex:i]];
        [timePdStr appendString:[setTimeArray objectAtIndex:20]];
        teacher.timePeriod = [timePdStr copy];
        CLog(@"timePeriod:%@", teacher.timePeriod);
        [setTab reloadData];
        
        [self updateTeacherInfo];
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) hiddenHeadViewNotice:(NSNotification *) sender
{
    if (sender.userInfo)
    {
        headUrl = [[sender.userInfo objectForKey:@"HeadUrl"] copy];
        
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        teacher.headUrl  = [NSString stringWithFormat:@"%@%@", webAdd, headUrl];
        
        [self updateTeacherInfo];
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setPersonalInfoFromNotice:(NSNotification *)sender
{
    int tag = ((NSNumber *)[sender.userInfo objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        NSDictionary *userInfoDic = sender.userInfo;
        if (userInfoDic)
        {
            infoValue.text  = [userInfoDic objectForKey:@"personalInfo"];
            teacher.info    = [userInfoDic objectForKey:@"personalInfo"];
        }
        
        [self updateTeacherInfo];
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setSalaryFromSettingNotice:(NSNotification *) notice
{
    NSString *salary  = @"";
    if ([[notice.userInfo objectForKey:@"name"] isEqualToString:@"0"])
        salary = @"师生协商";
    else
        salary = [notice.userInfo objectForKey:@"name"];
    
    salaryValLab.text = salary;
    teacher.expense   = ((NSString *)[notice.userInfo objectForKey:@"id"]).intValue;
    CLog(@"teacher.expense:%d", teacher.expense);
    
    [self updateTeacherInfo];
}

- (void) updateEmailInfoNotice:(NSNotification *) notice
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    switch (tag)
    {
        case 0:
        {
            UpdateEmailViewController *ueVctr = [[UpdateEmailViewController alloc]init];
            ueVctr.email = teacher.email;
            [nav presentPopupViewController:ueVctr
                              animationType:MJPopupViewAnimationFade];
            break;
        }
        default:
            break;
    }
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) updateEmailNotice:(NSNotification *) notice
{
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        emailValLab.text = [notice.userInfo objectForKey:@"CONTENT"];
        teacher.email = [notice.userInfo objectForKey:@"CONTENT"];
        updateType = EmailUpdate;
        
        //更新个人信息
        [self updateTeacherInfo];
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) updatePhoneNotice:(NSNotification *) notice
{
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        phoneValLab.text  = [notice.userInfo objectForKey:@"CONTENT"];
        updateType = PhoneUpdate;
        teacher.phoneNums = [notice.userInfo objectForKey:@"CONTENT"];
        
        //更新个人信息
        [self updateTeacherInfo];
    }
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setCertitionNotice:(NSNotification *) notice
{
    teacher.certArray = [[notice.userInfo objectForKey:@"CertyUrlArray"] copy];
    CLog(@"teacher.cert:%@", teacher.certArray);
    [self updateTeacherInfo];
}

- (void) suggestNotice:(NSNotification *) notice
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    switch (tag)
    {
        case 0:     //确定
        {
            //上传建议
            [self uploadSuggest:[notice.userInfo objectForKey:@"CONTENT"]];
            break;
        }
        default:
            break;
    }
}

- (void) updatePhoneInfoNotice:(NSNotification *) notice
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    switch (tag)
    {
        case 0:
        {
            UpdatePhoneViewController *ueVctr = [[UpdatePhoneViewController alloc]init];
            ueVctr.phone = teacher.phoneNums;
            [nav presentPopupViewController:ueVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - Controller Event
- (void) doBackBtnClicked:(id)sender
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    NSArray *ctrsArr = nav.viewControllers;
    for (UIViewController *ctr in ctrsArr)
    {
        if ([ctr isKindOfClass:[PersonCenterViewController class]])
        {
            PersonCenterViewController *pCvtr = (PersonCenterViewController *)ctr;
            [pCvtr setSelectedIndex:4];
            [nav popToViewController:pCvtr animated:NO];
            break;
        }
        
    }
}

- (void) doValueChanged:(id)sender
{
    UISwitch *sw = sender;
    switch (sw.tag)
    {
        case 0:        //试听修改
        {
            teacher.listenStar = listenSw.on;
            break;
        }
        case 1:        //电话修改
        {
            teacher.phoneStar = phoneSw.on;
            break;
        }
        case 2:        //定位修改
        {
            teacher.locationStar = locSw.on;
            break;
        }
        default:
            break;
    }

    //更新个人信息
    [self updateTeacherInfo];
}

- (void) doLogoutBtnClicked:(id)sender
{
    //写入登录成功标识
    [[NSUserDefaults standardUserDefaults] setBool:NO
                                            forKey:LOGINE_SUCCESS];
    
    //显示登录页面
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    LoginViewController *loginVctr = [[LoginViewController alloc]init];
    CustomNavigationViewController *nav = [[CustomNavigationViewController alloc]initWithRootViewController:loginVctr];
    appDelegate.window.rootViewController = nav;
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 3;
            break;
        }
        case 1:
        {
            return 14;
            break;
        }
        case 2:
        {
            return 4;
            break;
        }
        default:
            break;
    }
    
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return @"开关设置";
            break;
        }
        case 1:
        {
            return @"个人信息设置";
            break;
        }
        case 2:
        {
            return @"其他设置";
            break;
        }
        default:
            break;
    }
    
    return @"";
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:idString];
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:         //试听
                {
                    UILabel *phoneLab = [[UILabel alloc]init];
                    phoneLab.text     = @"试听";
                    phoneLab.frame    = CGRectMake(20, 16, 80, 20);
                    phoneLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:phoneLab];
                    [phoneLab release];
                    
                    listenSw  = [[UISwitch alloc]init];
                    listenSw.tag   = 0;
                    listenSw.frame = CGRectMake(215, 12, 80, 20);
                    [cell addSubview:listenSw];
                    listenSw.on = teacher.listenStar;
                    [listenSw addTarget:self
                                action:@selector(doValueChanged:)
                      forControlEvents:UIControlEventValueChanged];
                    break;
                }
                case 1:         //电话接听
                {                    
                    UILabel *phoneLab = [[UILabel alloc]init];
                    phoneLab.text     = @"电话接听";
                    phoneLab.frame    = CGRectMake(20, 16, 80, 20);
                    phoneLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:phoneLab];
                    [phoneLab release];
                    
                    phoneSw  = [[UISwitch alloc]init];
                    phoneSw.tag   = 1;
                    phoneSw.frame = CGRectMake(215, 12, 80, 20);
                    [cell addSubview:phoneSw];
                    phoneSw.on = teacher.phoneStar;
                    [phoneSw addTarget:self
                                action:@selector(doValueChanged:)
                      forControlEvents:UIControlEventValueChanged];
                    break;
                }
                case 2:         //定位
                {
                    UILabel *locLab = [[UILabel alloc]init];
                    locLab.text  = @"定位";
                    locLab.frame = CGRectMake(20, 16, 80, 20);
                    locLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:locLab];
                    [locLab release];
                    
                    locSw = [[UISwitch alloc]init];
                    locSw.tag   = 2;
                    locSw.frame = CGRectMake(215, 12, 80, 20);
                    [cell addSubview:locSw];
                    locSw.on = teacher.locationStar;
                    [locSw addTarget:self
                              action:@selector(doValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:        //我的助教
                {
                    UILabel *emailLab = [[UILabel alloc]init];
                    emailLab.text  = @"我的助教";
                    emailLab.frame = CGRectMake(20, 15, 80, 20);
                    emailLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:emailLab];
                    [emailLab release];
                    
                    assitentLab = [[UILabel alloc]init];
                    if (![ccResDic isEqual:[NSNull null]])
                    {
                        NSDictionary *ccDic = [ccResDic objectForKey:@"cc"];
                        if (ccDic.count!=0)
                            assitentLab.text = [ccDic objectForKey:@"cc_name"];
                        else
                            assitentLab.text = @"未签约";
                    }
                    else
                        assitentLab.text   = @"未签约";
                    assitentLab.textAlignment   = NSTextAlignmentRight;
                    assitentLab.backgroundColor = [UIColor clearColor];
                    assitentLab.frame  = CGRectMake(87, 15, 200, 20);
                    [cell addSubview:assitentLab];
                    
                    numView = [[[NoticeNumberView alloc]initWithFrame:CGRectMake(320-60, 15, 40, 40)]autorelease];
                    if (!ccResDic)
                        numView.hidden = YES;
                    else
                    {
                        NSString *newApply = [[ccResDic objectForKey:@"new_apply"] copy];
                        if (newApply.intValue==0)
                            numView.hidden = YES;
                        else
                        {
                            CGSize size = [assitentLab.text sizeWithFont:assitentLab.font constrainedToSize:CGSizeMake(assitentLab.frame.size.width, MAXFLOAT)
                                                           lineBreakMode:NSLineBreakByWordWrapping];
                            [numView setTitle:newApply];
                            numView.hidden = NO;
                            numView.frame = CGRectMake(320-30-numView.frame.size.width,
                                                       numView.frame.origin.y, numView.frame.size.width,
                                                       numView.frame.size.height);
                            assitentLab.frame = CGRectMake(numView.frame.origin.x-size.width,
                                                           assitentLab.frame.origin.y, size.width, size.height);
                        }
                    }
                    [cell addSubview:numView];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 1:
                {
                    UILabel *emailLab = [[UILabel alloc]init];
                    emailLab.text  = @"邮箱";
                    emailLab.frame = CGRectMake(20, 15, 80, 20);
                    emailLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:emailLab];
                    [emailLab release];
                    
                    emailValLab = [[UILabel alloc]init];
                    emailValLab.text   = teacher.email;
                    emailValLab.textAlignment   = NSTextAlignmentRight;
                    emailValLab.backgroundColor = [UIColor clearColor];
                    emailValLab.frame  = CGRectMake(87, 15, 200, 20);
                    [cell addSubview:emailValLab];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 2:
                {
                    UILabel *phoneLab = [[UILabel alloc]init];
                    phoneLab.text  = @"手机";
                    phoneLab.frame = CGRectMake(20, 15, 80, 20);
                    phoneLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:phoneLab];
                    [phoneLab release];
                    
                    phoneValLab = [[UILabel alloc]init];
                    phoneValLab.text   = teacher.phoneNums;
                    phoneValLab.textAlignment   = NSTextAlignmentRight;
                    phoneValLab.backgroundColor = [UIColor clearColor];
                    phoneValLab.frame  = CGRectMake(87, 15, 200, 20);
                    [cell addSubview:phoneValLab];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 3:
                {
                    UILabel *salaryLab = [[UILabel alloc]init];
                    salaryLab.text  = @"每小时课酬";
                    salaryLab.frame = CGRectMake(20, 15, 100, 20);
                    salaryLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:salaryLab];
                    [salaryLab release];
                    
                    salaryValLab = [[UILabel alloc]init];
                    salaryValLab.text   = [Student searchSalaryName:[NSString stringWithFormat:@"%d", teacher.expense]];
                    salaryValLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
                    salaryValLab.textAlignment   = NSTextAlignmentRight;
                    salaryValLab.backgroundColor = [UIColor clearColor];
                    salaryValLab.frame  = CGRectMake(87, 15, 200, 20);
                    [cell addSubview:salaryValLab];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 4:
                {
                    UILabel *infoLab = [[UILabel alloc]init];
                    infoLab.text  = @"个人简介";
                    infoLab.frame = CGRectMake(20, 15, 80, 20);
                    infoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:infoLab];
                    [infoLab release];
                    
                    infoValue = [[UILabel alloc]init];
                    infoValue.text   = teacher.info;
                    infoValue.textAlignment   = NSTextAlignmentRight;
                    infoValue.backgroundColor = [UIColor clearColor];
                    infoValue.frame  = CGRectMake(87, 15, 200, 20);
                    [cell addSubview:infoValue];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 5:
                {
                    UILabel *certifyLab = [[UILabel alloc]init];
                    certifyLab.text  = @"资历证书";
                    certifyLab.frame = CGRectMake(20, 15, 80, 20);
                    certifyLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:certifyLab];
                    [certifyLab release];
                    
                    UILabel *certifyValLab = [[UILabel alloc]init];
                    if ([teacher.certArray isEqual:[NSNull null]] || (teacher.certArray.count==0))
                    {
                        certifyValLab.text = @"未上传资质证书";
                    }
                    else
                    {
                        certifyValLab.text   = @"";
                        certifyValLab.hidden = YES;

                        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
                        for (int i=0; i<teacher.certArray.count; i++)
                        {
                            NSString *url = [teacher.certArray objectAtIndex:i];
                            NSString *certUrl = [NSString stringWithFormat:@"%@%@", webAdd, url];
                            
                            TTImageView *certImgView = [[TTImageView alloc]init];
                            certImgView.delegate = self;
                            certImgView.defaultImage = [UIImage imageNamed:@"s_boy"];
                            certImgView.URL   = certUrl;
                            certImgView.frame = CGRectMake(320-50-25*i, 15, 20, 20);
                            [cell addSubview:certImgView];
                            [certImgView release];
                        }
                    }
                    
                    certifyValLab.textAlignment   = NSTextAlignmentRight;
                    certifyValLab.backgroundColor = [UIColor clearColor];
                    certifyValLab.frame  = CGRectMake(87, 15, 200, 20);
                    [cell addSubview:certifyValLab];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 6:
                {
                    UILabel *numberLab = [[UILabel alloc]init];
                    numberLab.text  = @"绑定账号";
                    numberLab.frame = CGRectMake(20, 15, 80, 20);
                    numberLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:numberLab];
                    [numberLab release];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 7:
                {
                    UILabel *photoLab = [[UILabel alloc]init];
                    photoLab.text  = @"自拍照";
                    photoLab.frame = CGRectMake(20, 15, 80, 20);
                    photoLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:photoLab];
                    [photoLab release];
                    
                    headImgView = [[TTImageView alloc]init];
                    headImgView.delegate = self;
                    headImgView.frame  = CGRectMake(320-60, 15, 20, 20);
                    headImgView.defaultImage = [UIImage imageNamed:@"s_boy"];
                    CLog(@"headUrl:%@", teacher.headUrl);
                    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
                    headImgView.URL  = [NSString stringWithFormat:@"%@%@",webAdd,teacher.headUrl];
                    [cell addSubview:headImgView];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 8:
                {
                    UILabel *timeLab = [[UILabel alloc]init];
                    timeLab.text  = @"设置时段";
                    timeLab.frame = CGRectMake(20, 15, 80, 20);
                    timeLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:timeLab];
                    [timeLab release];
                    
                    UILabel *timeValueLab = [[UILabel alloc]init];
                    if ([self isSetTimePeriod])
                    {
                        timeValueLab.text = @"已设置";
                        timeValueLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
                    }
                    else
                    {
                        UIImageView *flagImgView = [[UIImageView alloc]init];
                        flagImgView.image = [UIImage imageNamed:@"quanquan.png"];
                        flagImgView.frame = CGRectMake(320-30-80, 15, 20, 20);
                        [cell addSubview:flagImgView];
                        [flagImgView release];
                        
                        timeValueLab.text = @"未设置";
                        timeValueLab.textColor = [UIColor blackColor];
                    }
                    timeValueLab.textAlignment   = NSTextAlignmentRight;
                    timeValueLab.backgroundColor = [UIColor clearColor];
                    timeValueLab.frame  = CGRectMake(87, 15, 200, 20);
                    [cell addSubview:timeValueLab];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 9:
                {
                    UILabel *subLab = [[UILabel alloc]init];
                    subLab.text  = @"科目";
                    subLab.frame = CGRectMake(20, 15, 80, 20);
                    subLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:subLab];
                    [subLab release];
                    
                    UILabel *subValueLab = [[UILabel alloc]init];
                    subValueLab.text   = teacher.pf;
                    subValueLab.textAlignment   = NSTextAlignmentRight;
                    subValueLab.backgroundColor = [UIColor clearColor];
                    subValueLab.frame  = CGRectMake(97, 15, 200, 20);
                    [cell addSubview:subValueLab];
                    break;
                }
                case 10:
                {
                    UILabel *nameLab = [[UILabel alloc]init];
                    nameLab.text  = @"姓名";
                    nameLab.frame = CGRectMake(20, 15, 80, 20);
                    nameLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:nameLab];
                    [nameLab release];
                    
                    UILabel *nameValLab = [[UILabel alloc]init];
                    nameValLab.text     = teacher.name;
                    nameValLab.textAlignment   = NSTextAlignmentRight;
                    nameValLab.backgroundColor = [UIColor clearColor];
                    nameValLab.frame  = CGRectMake(97, 15, 200, 20);
                    [cell addSubview:nameValLab];
                    [nameValLab release];
                    break;
                }
                case 11:
                {
                    UILabel *sexLab = [[UILabel alloc]init];
                    sexLab.text  = @"性别";
                    sexLab.frame = CGRectMake(20, 15, 80, 20);
                    sexLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:sexLab];
                    [sexLab release];
                    
                    NSString *gender = @"";
                    if (teacher.sex==1)
                        gender = @"男";
                    else
                        gender = @"女";
                    
                    UILabel *sexValLab = [[UILabel alloc]init];
                    sexValLab.text     = gender;
                    sexValLab.textAlignment   = NSTextAlignmentRight;
                    sexValLab.backgroundColor = [UIColor clearColor];
                    sexValLab.frame  = CGRectMake(97, 15, 200, 20);
                    [cell addSubview:sexValLab];
                    [sexValLab release];
                    break;
                }
                case 12:
                {
                    UILabel *nameLab = [[UILabel alloc]init];
                    nameLab.text  = @"身份证号";
                    nameLab.frame = CGRectMake(20, 15, 80, 20);
                    nameLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:nameLab];
                    [nameLab release];
                    
                    UILabel *nameValLab = [[UILabel alloc]init];
                    nameValLab.text     = teacher.idNums;
                    nameValLab.textAlignment   = NSTextAlignmentRight;
                    nameValLab.backgroundColor = [UIColor clearColor];
                    nameValLab.frame  = CGRectMake(97, 15, 200, 20);
                    [cell addSubview:nameValLab];
                    [nameValLab release];
                    break;
                }
                case 13:
                {
                    UILabel *starLab = [[UILabel alloc]init];
                    starLab.text  = @"星级";
                    starLab.frame = CGRectMake(20, 15, 80, 20);
                    starLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:starLab];
                    [starLab release];
                    
                    UIStartsImageView *starImgView = [[UIStartsImageView alloc]initWithFrame:CGRectMake(320-120, 20, 100, 10)];
                    [starImgView setHlightStar:teacher.comment];
                    [cell addSubview:starImgView];
                    [starImgView release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UILabel *adviseLab = [[UILabel alloc]init];
                    adviseLab.text  = @"建议反馈";
                    adviseLab.frame = CGRectMake(20, 16, 80, 20);
                    adviseLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:adviseLab];
                    [adviseLab release];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 1:
                {
                    UILabel *aboutLab = [[UILabel alloc]init];
                    aboutLab.text  = @"关于轻轻";
                    aboutLab.frame = CGRectMake(20, 16, 80, 20);
                    aboutLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:aboutLab];
                    [aboutLab release];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 2:
                {
                    UILabel *versionLab = [[UILabel alloc]init];
                    versionLab.text  = @"版本检查";
                    versionLab.frame = CGRectMake(20, 16, 80, 20);
                    versionLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:versionLab];
                    [versionLab release];
                    
                    UILabel *versionValLab = [[UILabel alloc]init];
                    versionValLab.textAlignment   = NSTextAlignmentRight;
                    versionValLab.backgroundColor = [UIColor clearColor];
                    versionValLab.frame    = CGRectMake(87, 16, 200, 20);
                    [cell addSubview:versionValLab];

                    //当前版本
                    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
                    NSString *oldVersion   = [infoDict objectForKey:@"CFBundleVersion"];
                    
//                    NSString *Dic =  [[NSUserDefaults standardUserDefaults]
//                                                                        objectForKey:APP_VERSION];
//                    NSString *newVersion = [newDic objectForKey:@"Version"];
                    versionValLab.text   = [NSString stringWithFormat:@"当前版本:V%@", oldVersion];
                    cell.userInteractionEnabled = NO;
                    [versionValLab release];
                    break;
                }
                case 3:
                {
                    UIImage *loginImg   = [UIImage imageNamed:@"normal_btn"];
                    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [logoutBtn setTitle:@"退出当前账号"
                              forState:UIControlStateNormal];
                    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                                   forState:UIControlStateNormal];
                    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                                   forState:UIControlStateHighlighted];
                    [logoutBtn setBackgroundImage:loginImg
                                        forState:UIControlStateNormal];
                    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                                        forState:UIControlStateHighlighted];
                    logoutBtn.frame = CGRectMake(20, 2.5, 280, 40);
                    [logoutBtn addTarget:self
                                 action:@selector(doLogoutBtnClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:logoutBtn];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    switch (indexPath.section)
    {
        case 0:      //开关设置
        {
            break;
        }
        case 1:      //个人信息设置
        {
            switch (indexPath.row)
            {
                case 0:        //我的助教
                {
                    AssistentViewController *assVctr = [[AssistentViewController alloc]init];
                    [nav pushViewController:assVctr animated:YES];
                    [assVctr release];
                    break;
                }
                case 1:        //邮箱
                {
                    UpdateEmailInfoViewController *uiVctr = [[UpdateEmailInfoViewController alloc]init];
                    [nav presentPopupViewController:uiVctr
                                      animationType:MJPopupViewAnimationFade];
                    break;
                }
                case 2:        //电话
                {
                    UpdatePhoneInfoViewController *upVctr = [[UpdatePhoneInfoViewController alloc]init];
                    [nav presentPopupViewController:upVctr
                                       animationType:MJPopupViewAnimationFade];

                    break;
                }
                case 3:        //课酬
                {
                    SelectSalaryViewController *ssVctr = [[SelectSalaryViewController alloc]init];
                    if (salaryValLab.text.length>0)
                        ssVctr.money = salaryValLab.text;
                    else
                        ssVctr.money = @"180";
                    [nav pushViewController:ssVctr animated:YES];
                    [ssVctr release];
                    break;
                }
                case 4:        //个人简介
                {
                    SetPersonalInfoViewController *spVctr = [[SetPersonalInfoViewController alloc]init];
                    spVctr.contentInfo = teacher.info;
                    [nav presentPopupViewController:spVctr
                                      animationType:MJPopupViewAnimationFade];
                    break;
                }
                case 5:        //资历证书
                {
                    UploadCertificateViewController *upCtr = [[UploadCertificateViewController alloc]init];
                    upCtr.certyUrlArray = [teacher.certArray mutableCopy];
                    [nav pushViewController:upCtr animated:YES];
                    [upCtr release];
                    break;
                }
                case 6:        //绑定账号
                {
                    //跳转分享页面
                    for (UIViewController *vtr in nav.viewControllers)
                    {
                        if ([vtr isKindOfClass:[LeveyTabBarController class]])
                        {
                            [((LeveyTabBarController *)vtr) setSelectedIndex:3];
                        }
                    }
                    break;
                }
                case 7:        //自拍照
                {
                    CustomNavigationViewController *nav  = [MainViewController getNavigationViewController];
                    SelectHeadViewController *shVctr = [[SelectHeadViewController alloc]init];
                    shVctr.headUrl = teacher.headUrl;
                    [nav presentPopupViewController:shVctr
                                       animationType:MJPopupViewAnimationFade];
                    break;
                }
                case 8:        //设置时间段
                {
                    CustomNavigationViewController *nav  = [MainViewController getNavigationViewController];
                    SetTimePeriodViewController *stpVctr = [[SetTimePeriodViewController alloc]init];
                    stpVctr.setTimesArray = [setTimeArray mutableCopy];
                    [nav presentPopupViewController:stpVctr
                                      animationType:MJPopupViewAnimationFade];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:      //其他设置
        {
            switch (indexPath.row)
            {
                case 0:          //建议反馈
                {
                    SuggestViewController *sVctr = [[SuggestViewController alloc]init];
                    [nav presentPopupViewController:sVctr
                                       animationType:MJPopupViewAnimationFade];
                    break;
                }
                case 1:          //关于轻轻
                {
                    AboutSoftwareViewController *aboutVctr = [[AboutSoftwareViewController alloc]init];
                    [nav pushViewController:aboutVctr animated:YES];
                    [aboutVctr release];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark ServerRequest Delegate
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
}

- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{
    NSData   *resVal = [request responseData];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic   = [resStr JSONValue];
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
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"submitProposal"])
        {
            CLog(@"upload suggest success!");
        }
        else if ([action isEqualToString:@"upinfos"])
        {
            CLog(@"update infomation success!");
            
            //更新本地个人信息
            NSData *teacherData = [NSKeyedArchiver archivedDataWithRootObject:teacher];
            [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                      forKey:TEACHER_INFO];
            
            if ((updateType==EmailUpdate) || (updateType==PhoneUpdate))
            {
                //退出回到登录页面
                [self doLogoutBtnClicked:nil];
            }
            
            [setTab reloadData];
        }
    }
    else
    {
//        NSString *errorMsg = [resDic objectForKey:@"message"];
//        [self showAlertWithTitle:@"提示"
//                             tag:0
//                         message:[NSString stringWithFormat:@"错误码%@,%@",errorid,errorMsg]
//                        delegate:self
//               otherButtonTitles:@"确定",nil];
        
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
@end
