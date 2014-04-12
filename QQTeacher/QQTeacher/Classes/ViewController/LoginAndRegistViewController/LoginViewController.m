//
//  LoginViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    //获得帮助电话
    [self getHelpPhone];
    
    [self initUI];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"登陆中"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    phoneFld = nil;
    phoneFld.delegate = nil;
    
    userNameFld = nil;
    userNameFld.delegate = nil;
    [super viewDidUnload];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [registBtn removeFromSuperview];
    registBtn = nil;
    [super viewDidDisappear:animated];
}

- (void) dealloc
{
    [phoneFld           release];
    [userNameFld        release];
    [emailImgView       release];
    [phoneImgView       release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) getHelpPhone
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *helpPhone = [[NSUserDefaults standardUserDefaults] objectForKey:HELP_PHONE];
    if (!helpPhone)
    {
        NSString *idString  = [SingleMQTT getCurrentDevTopic];
        NSArray *paramsArr  = [NSArray arrayWithObjects:@"action",@"deviceId", nil];
        NSArray *valusArr   = [NSArray arrayWithObjects:@"getCSPhone",idString,nil];
        NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valusArr
                                                          forKeys:paramsArr];
        ServerRequest *serverReq = [ServerRequest sharedServerRequest];
        serverReq.delegate = self;
        NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
        NSString *url = [NSString stringWithFormat:@"%@%@", webAddress,TEACHER];
        [serverReq requestASyncWith:kServerPostRequest
                           paramDic:pDic
                             urlStr:url];
    }
}

- (void) initUI
{
    //初始化返回按钮
    UIBarButtonItem *navBtn = [self backBarButtomItem];
    self.navigationItem.leftBarButtonItem = navBtn;
    
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] objectForKey:TEACHER_INFO];
    Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    UIImage *normalImg = [UIImage imageNamed:@"normal_fld"];
    emailImgView = [[UIImageView alloc]initWithImage:normalImg];
    userNameFld  = [[UITextField alloc]init];
    userNameFld.tag = 0;
    userNameFld.delegate = self;
    [userNameFld addTarget:self
                    action:@selector(valueChanged:)
          forControlEvents:UIControlEventEditingChanged];
    userNameFld.text        = teacher.email;
    userNameFld.borderStyle = UITextBorderStyleNone;
    userNameFld.placeholder = @"输入注册邮箱";
    [self.view addSubview:emailImgView];
    [self.view addSubview:userNameFld];
    
    phoneFld = [[UITextField alloc]init];
    phoneFld.tag  = 1;
    phoneImgView  = [[UIImageView alloc]initWithImage:normalImg];
    [phoneFld addTarget:self
                    action:@selector(valueChanged:)
          forControlEvents:UIControlEventEditingChanged];
    phoneFld.delegate = self;
    phoneFld.text     = teacher.phoneNums;
    phoneFld.borderStyle = UITextBorderStyleNone;
    phoneFld.placeholder = @"输入手机号码";
    
    [self.view addSubview:phoneImgView];
    [self.view addSubview:phoneFld];
    
    UIImage *loginImg  = [UIImage imageNamed:@"normal_btn"];
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录"
              forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                   forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                   forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:loginImg
                        forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                        forState:UIControlStateHighlighted];
   
    [loginBtn addTarget:self
                 action:@selector(doLoginBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text = @"请务必保密您的邮箱及手机号码组合,并可随时使用\"设置\"功能进行修订,以确保您的权利";
    
    infoLab.font = [UIFont systemFontOfSize:13.f];
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.lineBreakMode   = NSLineBreakByWordWrapping;
    infoLab.numberOfLines   = 0;
    infoLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
    [self.view addSubview:infoLab];

    
    UIImage *hpImg  = [UIImage imageNamed:@"login_help_phone_btn"];
    UIButton *hpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hpBtn setTitle:@"帮助"
           forState:UIControlStateNormal];
    [hpBtn setImage:hpImg
           forState:UIControlStateNormal];
    
    [hpBtn addTarget:self
              action:@selector(doHpBtnClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hpBtn];
    
    UILabel *helpLab = [[UILabel alloc]init];
    helpLab.text = @"忘记了吗?一键帮助";
    helpLab.textAlignment = NSTextAlignmentLeft;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            userNameFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                             65+44,
                                                             normalImg.size.width-5,
                                                             normalImg.size.height)
                                       isBackView:NO];
            emailImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                              60+44,
                                                              normalImg.size.width,
                                                              normalImg.size.height+10)
                                        isBackView:NO];
            phoneFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                          70+normalImg.size.height+10+44,
                                                          normalImg.size.width-5,
                                                          normalImg.size.height)
                                    isBackView:NO];
            phoneImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                              70+normalImg.size.height+5+44,
                                                              normalImg.size.width,
                                                              normalImg.size.height+10)
                                        isBackView:NO];
            loginBtn.frame = [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2,
                                                          70+normalImg.size.height*2+30+44,
                                                          loginImg.size.width,
                                                          loginImg.size.height)
                                    isBackView:NO];
            infoLab.frame= [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2,
                                                        70+normalImg.size.height*3+40+44,
                                                        loginImg.size.width,
                                                        loginImg.size.height*3)
                                  isBackView:NO];
            hpBtn.frame = [UIView fitCGRect:CGRectMake(237, 480-hpImg.size.height-44-15,
                                                       hpImg.size.width,
                                                       hpImg.size.height)
                                 isBackView:NO];
            helpLab.frame= [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2, 480-hpImg.size.height-44-15,
                                                        loginImg.size.width,
                                                        hpImg.size.height)
                                  isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            userNameFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                             65+44,
                                                             normalImg.size.width-5,
                                                             normalImg.size.height)
                                       isBackView:NO];
            emailImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                              60+44,
                                                              normalImg.size.width,
                                                              normalImg.size.height+10)
                                        isBackView:NO];
            phoneFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                          70+normalImg.size.height+10+44,
                                                          normalImg.size.width-5,
                                                          normalImg.size.height)
                                    isBackView:NO];
            phoneImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                              70+normalImg.size.height+5+44,
                                                              normalImg.size.width,
                                                              normalImg.size.height+10)
                                        isBackView:NO];
            loginBtn.frame = [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2,
                                                          70+normalImg.size.height*2+30+44,
                                                          loginImg.size.width,
                                                          loginImg.size.height)
                                    isBackView:NO];
            infoLab.frame= [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2,
                                                        70+normalImg.size.height*3+40+44,
                                                        loginImg.size.width,
                                                        loginImg.size.height*3)
                                  isBackView:NO];
            hpBtn.frame = [UIView fitCGRect:CGRectMake(237, 480-hpImg.size.height-44-15,
                                                       hpImg.size.width,
                                                       hpImg.size.height)
                                 isBackView:NO];
            helpLab.frame= [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2, 480-hpImg.size.height-44-15,
                                                        loginImg.size.width,
                                                        hpImg.size.height)
                                  isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            userNameFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                             65,
                                                             normalImg.size.width-5,
                                                             normalImg.size.height)
                                       isBackView:NO];
            emailImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                              60,
                                                              normalImg.size.width,
                                                              normalImg.size.height+10)
                                        isBackView:NO];
            phoneFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                          70+normalImg.size.height+10+4,
                                                          normalImg.size.width-5,
                                                          normalImg.size.height)
                                    isBackView:NO];
            phoneImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                              70+normalImg.size.height+5+4,
                                                              normalImg.size.width,
                                                              normalImg.size.height+10)
                                        isBackView:NO];
            loginBtn.frame = [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2,
                                                          70+normalImg.size.height*2+30+4,
                                                          loginImg.size.width,
                                                          loginImg.size.height)
                                    isBackView:NO];
            infoLab.frame= [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2,
                                                        70+normalImg.size.height*3+20+4,
                                                        loginImg.size.width,
                                                        loginImg.size.height*3)
                                  isBackView:NO];
            hpBtn.frame = [UIView fitCGRect:CGRectMake(237, 480-hpImg.size.height-84-15,
                                                       hpImg.size.width,
                                                       hpImg.size.height)
                                 isBackView:NO];
            helpLab.frame= [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2, 480-hpImg.size.height-84-15,
                                                        loginImg.size.width,
                                                        hpImg.size.height)
                                  isBackView:NO];
            
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            userNameFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                             65+4,
                                                             normalImg.size.width-5,
                                                             normalImg.size.height)
                                       isBackView:NO];
            emailImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                              60+4,
                                                              normalImg.size.width,
                                                              normalImg.size.height+10)
                                        isBackView:NO];
            phoneFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                          70+normalImg.size.height+10+4,
                                                          normalImg.size.width-5,
                                                          normalImg.size.height)
                                    isBackView:NO];
            phoneImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                              70+normalImg.size.height+5+4,
                                                              normalImg.size.width,
                                                              normalImg.size.height+10)
                                        isBackView:NO];
            loginBtn.frame = [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2,
                                                          70+normalImg.size.height*2+30+4,
                                                          loginImg.size.width,
                                                          loginImg.size.height)
                                    isBackView:NO];
            infoLab.frame= [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2,
                                                        70+normalImg.size.height*3+20+4,
                                                        loginImg.size.width,
                                                        loginImg.size.height*3)
                                  isBackView:NO];
            hpBtn.frame = [UIView fitCGRect:CGRectMake(237, 480-hpImg.size.height-84-15,
                                                       hpImg.size.width,
                                                       hpImg.size.height)
                                 isBackView:NO];
            helpLab.frame= [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2, 480-hpImg.size.height-84-15,
                                                        loginImg.size.width,
                                                        hpImg.size.height)
                                  isBackView:NO];
        }
    }
    helpLab.backgroundColor = [UIColor clearColor];
    helpLab.font = [UIFont systemFontOfSize:18.f];
    helpLab.textColor = [UIColor colorWithHexString:@"#00947d"];
    [self.view addSubview:helpLab];
    [helpLab release];
    [infoLab release];
}

- (BOOL) checkInfo
{
    if (userNameFld.text.length == 0 || phoneFld.text.length == 0)
    {
        return NO;
    }
    
    BOOL isEmailType = [userNameFld.text isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
    if (!isEmailType)
    {
        return NO;
    }
    
    BOOL isPhone = [phoneFld.text isMatchedByRegex:@"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$"];
    if (!isPhone)
    {
        return NO;
    }
    
    return YES;
}

- (void) doBackBtnClicked:(id)sender
{
    RegistViewController *rVctr = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:rVctr animated:YES];
    [rVctr release];
}

- (void) doRegistBtnClicked:(id)sender
{
    RegistViewController *rVctr = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:rVctr animated:YES];
    [rVctr release];
}

- (void) valueChanged:(id)sender
{
    if (![self checkInfo])
    {
        [loginBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                       forState:UIControlStateNormal];
    }
    else
    {
        [loginBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                       forState:UIControlStateNormal];
    }
}

- (void) doLoginBtnClicked:(id)sender
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    if (![self checkInfo])
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"请输入邮箱和手机号!"
                        delegate:self
               otherButtonTitles:@"确定",nil];
        return;
    }
    
    //恢复视图
    [self repickView:self.view];
    
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
    
    NSString *idString    = [SingleMQTT getCurrentDevTopic];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phoneNumber",@"email",
                                                   @"deviceId",@"ios",@"deviceToken", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"login", phoneFld.text, userNameFld.text,
                                                   idString, IOS,deviceToken, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    CLog(@"LoginPic:%@", pDic);
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@", webAddress,TEACHER];
    CLog(@"url:%@", url);
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

- (void) doHpBtnClicked:(id)sender
{
    NSString *helpPhone = [[NSUserDefaults standardUserDefaults] objectForKey:HELP_PHONE];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", helpPhone]]];
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
    titleLab.text     = @"注册";
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
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self repickView:self.view];
    [textField resignFirstResponder];
    return YES;
}



- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == userNameFld)
    {
        emailImgView.image    = [UIImage imageNamed:@"hight_fld"];
        phoneImgView.image    = [UIImage imageNamed:@"normal_fld"];
    }
    else
    {
        phoneImgView.image    = [UIImage imageNamed:@"hight_fld"];
        emailImgView.image    = [UIImage imageNamed:@"normal_fld"];
    }
    
    [self moveViewWhenViewHidden:loginBtn
                          parent:self.view];
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
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
}

- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
    
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
    
    NSNumber *errorid = [[resDic objectForKey:@"errorid"] copy];
    if (errorid.intValue == 0)
    {        
        NSString *ssid = [[resDic objectForKey:@"sessid"] retain];
        if (ssid)
        {
            NSString *action = [resDic objectForKey:@"action"];
            if ([action isEqualToString:@"getCSPhone"])
            {
                NSString *helpPhone = [resDic objectForKey:@"message"];
                CLog(@"helpPhone:%@", helpPhone);
                [[NSUserDefaults standardUserDefaults] setObject:helpPhone
                                                          forKey:HELP_PHONE];
            }
            else if ([action isEqualToString:@"login"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:ssid
                                                          forKey:SSID];
                CLog(@"ssid:%@", ssid);
                
                NSString *preCurDeviceId = [resDic objectForKey:@"fDeviceId"];
                NSString *curDeviceId = [SingleMQTT getCurrentDevTopic];
                if (![preCurDeviceId isEqualToString:curDeviceId])
                {
                    //本次登录和上次登录手机不同,通知上次手机下线
                    NSDictionary *offlineDic = [NSDictionary dictionaryWithObjectsAndKeys:@"9999",@"type", nil];
                    NSString *jsonStr   = [offlineDic JSONFragment];
                    NSData *data        = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                    SingleMQTT *session = [SingleMQTT shareInstance];
                    [session.session publishData:data
                                         onTopic:preCurDeviceId];
                }
                
                //获得Teacher
                NSDictionary *teacherDic = [resDic objectForKey:@"teacherInfo"];
                CLog(@"teacherDic:%@", teacherDic);
                
                Teacher *tObj       = [Teacher setTeacherProperty:teacherDic];
                NSData *teacherData = [NSKeyedArchiver archivedDataWithRootObject:tObj];
                [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                          forKey:TEACHER_INFO];
                CLog(@"sdfjsdfsdfi:%@", tObj.timePeriod);
                //判断用户是否完善个人资料
                if (!tObj.isInfoComplete)
                {
                    //跳转到完善个人资料页
                    CompletePersonalInfoViewController *cpVctr = [[[CompletePersonalInfoViewController alloc]init]autorelease];
                    [self.navigationController pushViewController:cpVctr
                                                         animated:YES];
                }
                else
                {
                    //写入登录成功标识
                    [[NSUserDefaults standardUserDefaults] setBool:YES
                                                            forKey:LOGINE_SUCCESS];
                    
                    //跳转个人中心
                    
                    MyTeacherViewController *mVctr = [[MyTeacherViewController alloc]init];
                    UINavigationController *navMvctr = [[UINavigationController alloc]initWithRootViewController:mVctr];
                    
                    LatlyViewController *lVctr = [[LatlyViewController alloc]init];
                    UINavigationController *navLVctr = [[UINavigationController alloc]initWithRootViewController:lVctr];
                    
                    UIViewController *sVctr = [[UIViewController alloc]init];
                    UINavigationController *navSVctr = [[UINavigationController alloc]initWithRootViewController:sVctr];
                    
                    ShareViewController *shareVctr = [[ShareViewController alloc]initWithNibName:nil
                                                                                          bundle:nil];
                    UINavigationController *navShareVctr = [[UINavigationController alloc]initWithRootViewController:shareVctr];
                    
                    SettingViewController *setVctr = [[SettingViewController alloc]initWithNibName:nil
                                                                                            bundle:nil];
                    UINavigationController *navSetVctr = [[UINavigationController alloc]initWithRootViewController:setVctr];
                    
                    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
                    [imgDic setObject:[UIImage imageNamed:@"s_1_1"]
                               forKey:@"Default"];
                    [imgDic setObject:[UIImage imageNamed:@"s_1_2"]
                               forKey:@"Highlighted"];
                    [imgDic setObject:[UIImage imageNamed:@"s_1_2"]
                               forKey:@"Seleted"];
                    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
                    [imgDic2 setObject:[UIImage imageNamed:@"s_2_1"]
                                forKey:@"Default"];
                    [imgDic2 setObject:[UIImage imageNamed:@"s_2_2"]
                                forKey:@"Highlighted"];
                    [imgDic2 setObject:[UIImage imageNamed:@"s_2_2"]
                                forKey:@"Seleted"];
                    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
                    [imgDic3 setObject:[UIImage imageNamed:@"s_3_1"]
                                forKey:@"Default"];
                    [imgDic3 setObject:[UIImage imageNamed:@"s_3_2"]
                                forKey:@"Highlighted"];
                    [imgDic3 setObject:[UIImage imageNamed:@"s_3_2"]
                                forKey:@"Seleted"];
                    NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
                    [imgDic4 setObject:[UIImage imageNamed:@"s_4_1"]
                                forKey:@"Default"];
                    [imgDic4 setObject:[UIImage imageNamed:@"s_4_2"]
                                forKey:@"Highlighted"];
                    [imgDic4 setObject:[UIImage imageNamed:@"s_4_2"]
                                forKey:@"Seleted"];
                    NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
                    [imgDic5 setObject:[UIImage imageNamed:@"s_5_1"]
                                forKey:@"Default"];
                    [imgDic5 setObject:[UIImage imageNamed:@"s_5_2"]
                                forKey:@"Highlighted"];
                    [imgDic5 setObject:[UIImage imageNamed:@"s_5_2"]
                                forKey:@"Seleted"];
                    
                    NSMutableArray *ctrlArr = [NSMutableArray arrayWithObjects:navMvctr,navLVctr,navSVctr,
                                                                               navShareVctr,navSetVctr,nil];
                    NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic3,imgDic2,
                                                                imgDic4,imgDic5,nil];
                    PersonCenterViewController *pcVctr    = [[PersonCenterViewController alloc]
                                                                         initWithViewControllers:ctrlArr imageArray:imgArr];
                    CustomNavigationViewController *nav   = [[CustomNavigationViewController alloc]initWithRootViewController:pcVctr];
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    appDelegate.window.rootViewController = nav;
                    [pcVctr release];
                    
                    MainViewController *mainVctr     = [[MainViewController alloc]init];
                    [nav pushViewController:mainVctr animated:NO];
                    [mainVctr release];
                }
            }
            else if ([action isEqualToString:@"register"])   //系统查询到没有该用户则相当于注册成功
            {
                NSString *ssid = [resDic objectForKey:@"sessid"];
                [[NSUserDefaults standardUserDefaults] setObject:ssid
                                                          forKey:SSID];
                
                //获得Teacher
                NSDictionary *teacherDic = [resDic objectForKey:@"teacherInfo"];
                Teacher *tObj       = [Teacher setTeacherProperty:teacherDic];
                NSData *teacherData = [NSKeyedArchiver archivedDataWithRootObject:tObj];
                [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                          forKey:TEACHER_INFO];
                
                //注册完成,跳转完成个人信息
                CompletePersonalInfoViewController *cpVctr = [[CompletePersonalInfoViewController alloc]init];
                [self.navigationController pushViewController:cpVctr
                                                     animated:YES];
                [cpVctr release];
            }
        }
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
@end
