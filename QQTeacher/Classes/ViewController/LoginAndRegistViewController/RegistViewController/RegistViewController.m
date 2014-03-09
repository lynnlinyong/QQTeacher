//
//  RegistViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MainViewController setNavTitle:@"注册中"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化UI
    [self initUI];
}

- (void) viewDidUnload
{
    userNameFld.delegate = nil;
    userNameFld = nil;
    
    phoneFld.delegate = nil;
    phoneFld = nil;
    
    [super viewDidUnload];
}

- (void) dealloc
{
    [phoneFld     release];
    [userNameFld  release];
    [emailImgView release];
    [phoneImgView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Custom Action

- (void) initUI
{    
    UIImage *normalImg = [UIImage imageNamed:@"normal_fld"];
    emailImgView = [[UIImageView alloc]initWithImage:normalImg];
    userNameFld  = [[UITextField alloc]init];
    userNameFld.delegate    = self;
    userNameFld.borderStyle = UITextBorderStyleNone;
    userNameFld.placeholder = @"输入注册邮箱";
    userNameFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                     70,
                                                     normalImg.size.width-5,
                                                     normalImg.size.height)
                               isBackView:NO];
    emailImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                      65,
                                                      normalImg.size.width,
                                                      normalImg.size.height+10)
                                isBackView:NO];
    [self.view addSubview:emailImgView];
    [self.view addSubview:userNameFld];
    
    phoneFld = [[UITextField alloc]init];
    phoneImgView  = [[UIImageView alloc]initWithImage:normalImg];
    phoneFld.delegate    = self;
    phoneFld.borderStyle = UITextBorderStyleNone;
    phoneFld.placeholder = @"输入手机号码";
    phoneFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                  80+normalImg.size.height+10,
                                                  normalImg.size.width-5,
                                                  normalImg.size.height)
                            isBackView:NO];
    phoneImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                      80+normalImg.size.height+5,
                                                      normalImg.size.width,
                                                      normalImg.size.height+10)
                                isBackView:NO];
    [self.view addSubview:phoneImgView];
    [self.view addSubview:phoneFld];
    
    UIImage *registImg  = [UIImage imageNamed:@"normal_btn.png"];
    registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setTitle:@"注册"
              forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                   forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                   forState:UIControlStateHighlighted];
    [registBtn setBackgroundImage:registImg
                        forState:UIControlStateNormal];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn.png"]
                        forState:UIControlStateHighlighted];
    registBtn.frame = [UIView fitCGRect:CGRectMake(160-registImg.size.width/2,
                                                  80+registImg.size.height*2+30,
                                                  registImg.size.width,
                                                  registImg.size.height)
                            isBackView:NO];
    [registBtn addTarget:self
                 action:@selector(doRegistBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text = @"请务必保密您的邮箱及手机号码组合,并可随时使用\"设置\"功能进行修订,以确保您的权利";
    infoLab.frame= [UIView fitCGRect:CGRectMake(160-registImg.size.width/2,
                                                80+registImg.size.height*3+40,
                                                registImg.size.width,
                                                registImg.size.height*3)
                          isBackView:NO];
    infoLab.font = [UIFont systemFontOfSize:13.f];
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.lineBreakMode   = NSLineBreakByWordWrapping;
    infoLab.numberOfLines   = 0;
    infoLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
    [self.view addSubview:infoLab];
    [infoLab release];
}

- (BOOL) checkInfo
{
    if (userNameFld.text.length == 0 || phoneFld.text.length == 0)
    {
        [self showAlertWithTitle:@"提示"
                             tag:1
                         message:@"注册信息不完整!"
                        delegate:self
               otherButtonTitles:@"确定", nil];
        
        return NO;
    }
    
    BOOL isEmailType = [userNameFld.text isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
    if (!isEmailType)
    {
        [self showAlertWithTitle:@"提示"
                             tag:1
                         message:@"邮箱格式不正确"
                        delegate:self
               otherButtonTitles:@"确定", nil];
        return NO;
    }
    
    BOOL isPhone = [phoneFld.text isMatchedByRegex:@"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$"];
    if (!isPhone)
    {
        [self showAlertWithTitle:@"提示"
                             tag:1
                         message:@"手机号格式不正确"
                        delegate:self
               otherButtonTitles:@"确定",nil];
        return NO;
    }
    
    return YES;
}

- (void) doRegistBtnClicked:(id)sender
{
    //注册完成,跳转完成个人信息
    CompletePersonalInfoViewController *cpVctr = [[CompletePersonalInfoViewController alloc]init];
    [self.navigationController pushViewController:cpVctr
                                         animated:YES];
    [cpVctr release];
    return;
    
    if (![self checkInfo])
    {
        return;
    }
    
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
    
    [self repickView:self.view];
    
    NSString *idString    = [SingleMQTT getCurrentDevTopic];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:QQ_STUDENT];
    
    NSArray *paramsArr  = [NSArray arrayWithObjects:@"action",@"phoneNumber",@"email",
                                                              @"deviceId",@"ios",@"deviceToken",nil];
    NSArray *valuesArr  = [NSArray arrayWithObjects:@"register", phoneFld.text,
                                                   userNameFld.text, idString, IOS,deviceToken,nil];
    NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                      forKeys:paramsArr];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate   = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@/", webAddress,TEACHER];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
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
    
    [self moveViewWhenViewHidden:registBtn
                          parent:self.view];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
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
    
    NSNumber *errorid = [resDic objectForKey:@"errorid"];
    if (errorid.intValue == 0)
    {
//        [self showAlertWithTitle:@"提示"
//                             tag:0
//                         message:@"注册成功"
//                        delegate:self
//               otherButtonTitles:@"确定", nil];
        
        NSString *ssid = [resDic objectForKey:@"sessid"];
        [[NSUserDefaults standardUserDefaults] setObject:ssid
                                                  forKey:SSID];
        
        //获得Teacher
        NSDictionary *teacherDic = [resDic objectForKey:@"teacherInfo"];
        Teacher *tObj = [Teacher setTeacherProperty:teacherDic];
        
        NSData *teacherData = [NSKeyedArchiver archivedDataWithRootObject:tObj];
        [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                  forKey:TEACHER_INFO];
        
        //注册完成,跳转完成个人信息
        CompletePersonalInfoViewController *cpVctr = [[CompletePersonalInfoViewController alloc]init];
        [self.navigationController pushViewController:cpVctr
                                             animated:YES];
        [cpVctr release];
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
