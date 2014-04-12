//
//  CompletePersonalInfoViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-2.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "CompletePersonalInfoViewController.h"

@interface CompletePersonalInfoViewController ()

@end

@implementation CompletePersonalInfoViewController

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
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化UI
    [self initUI];
    
    //注册设置名称昵称消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNickNameFromNotice:)
                                                 name:@"setNickNameNotice"
                                               object:nil];
    
    //注册选择性别消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSexFromNotice:)
                                                 name:@"setSexNotice"
                                               object:nil];
    
    //注册设置身份证号码消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setIdNumbersFromNotice:)
                                                 name:@"setIdNumbersNotice"
                                               object:nil];
    
    //注册设置个人简介消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setPersonalInfoFromNotice:)
                                                 name:@"setPersonalInfoFromCompleteNotice"
                                               object:nil];
    
    //注册设置专业消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSubjectFromNotice:)
                                                 name:@"setSubjectNotice"
                                               object:nil];
    
    //注册设置每小时课酬消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSalaryFromCompleteNotice:)
                                                 name:@"setSalaryFromCompleteNotice"
                                               object:nil];
    
    //注册隐藏选择头像消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hiddenHeadViewNotice:)
                                                 name:@"hiddenHeadViewFromCompleteNotice"
                                               object:nil];
    
    //注册设置时间段消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectTimePeriodNotice:)
                                                 name:@"SELECT_TIME_PERTIOD_FROM_COMPLETE_NOTICE"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)dealloc
{
    [headUrl release];
    [phoneValLab release];
    [emailValLab release];
    [sexValLab   release];
    [nameValLab  release];
    [subValLab   release];
    [idNumLab    release];
    [salaryLab   release];
    [myInfoLab   release];
    [setTimeArray release];
    [uploadStatusLab release];
    [setTimeStatusLab release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UILabel *titleInfoLab = [[UILabel alloc]init];
    titleInfoLab.text = @"完善以下信息,让学生速度找到您!(姓名、性别、身份证号、科目一经选择无法修改)";
    titleInfoLab.font = [UIFont systemFontOfSize:14.f];
    titleInfoLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
    titleInfoLab.backgroundColor = [UIColor clearColor];
    titleInfoLab.numberOfLines   = 0;
    titleInfoLab.lineBreakMode   = NSLineBreakByWordWrapping;
    [self.view addSubview:titleInfoLab];

    isSetTimeStatus = NO;
    
    setTimeArray = [[NSMutableArray alloc]init];
    for (int i=0; i<21; i++)
        [setTimeArray setObject:@"0" atIndexedSubscript:i];
    
    upTab = [[UITableView alloc]init];
    if ([upTab respondsToSelector:@selector(setSeparatorInset:)]) {
        [upTab setSeparatorInset:UIEdgeInsetsZero];
    }
    upTab.delegate     = self;
    upTab.dataSource   = self;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            upTab.frame = [UIView fitCGRect:CGRectMake(20, 44+35, 280, 345)
                                 isBackView:YES];
           titleInfoLab.frame= [UIView fitCGRect:CGRectMake(25, 44+5, 275, 40)
                                                      isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            upTab.frame = [UIView fitCGRect:CGRectMake(20, 44+55, 280, 325)
                                 isBackView:YES];
            titleInfoLab.frame= [UIView fitCGRect:CGRectMake(25, 44+15, 275, 40)
                                       isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            upTab.frame = [UIView fitCGRect:CGRectMake(20, 44+10, 280, 370)
                                 isBackView:YES];
            titleInfoLab.frame= [UIView fitCGRect:CGRectMake(25, 10, 275, 40)
                                       isBackView:NO];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            upTab.frame = [UIView fitCGRect:CGRectMake(20, 44, 280, 385)
                                 isBackView:YES];
            titleInfoLab.frame= [UIView fitCGRect:CGRectMake(25, 10, 275, 40)
                                       isBackView:NO];
        }
    }
    
    upTab.scrollEnabled  = YES;
    upTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:upTab];
    
    upTab.backgroundColor     = [UIColor colorWithHexString:@"E1E0DE"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"E1E0DE"];
    [titleInfoLab release];
    
    headUrl = [[NSString alloc]init];
}

/**
 * 功能:获取指定范围的字符串
 * 参数:字符串的开始小标
 * 参数:字符串的结束下标
 */
-(NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger)value1 Value2:(NSInteger)value2;
{
    return [str substringWithRange:NSMakeRange(value1,value2)];
}


/**
 
 * 功能:判断是否在地区码内
 
 * 参数:地区码
 
 */

-(BOOL)areaCode:(NSString *)code
{
    
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dic setObject:@"北京" forKey:@"11"];
    
    [dic setObject:@"天津" forKey:@"12"];
    
    [dic setObject:@"河北" forKey:@"13"];
    
    [dic setObject:@"山西" forKey:@"14"];
    
    [dic setObject:@"内蒙古" forKey:@"15"];
    
    [dic setObject:@"辽宁" forKey:@"21"];
    
    [dic setObject:@"吉林" forKey:@"22"];
    
    [dic setObject:@"黑龙江" forKey:@"23"];
    
    [dic setObject:@"上海" forKey:@"31"];
    
    [dic setObject:@"江苏" forKey:@"32"];
    
    [dic setObject:@"浙江" forKey:@"33"];
    
    [dic setObject:@"安徽" forKey:@"34"];
    
    [dic setObject:@"福建" forKey:@"35"];
    
    [dic setObject:@"江西" forKey:@"36"];
    
    [dic setObject:@"山东" forKey:@"37"];
    
    [dic setObject:@"河南" forKey:@"41"];
    
    [dic setObject:@"湖北" forKey:@"42"];
    
    [dic setObject:@"湖南" forKey:@"43"];
    
    [dic setObject:@"广东" forKey:@"44"];
    
    [dic setObject:@"广西" forKey:@"45"];
    
    [dic setObject:@"海南" forKey:@"46"];
    
    [dic setObject:@"重庆" forKey:@"50"];
    
    [dic setObject:@"四川" forKey:@"51"];
    
    [dic setObject:@"贵州" forKey:@"52"];
    
    [dic setObject:@"云南" forKey:@"53"];
    
    [dic setObject:@"西藏" forKey:@"54"];
    
    [dic setObject:@"陕西" forKey:@"61"];
    
    [dic setObject:@"甘肃" forKey:@"62"];
    
    [dic setObject:@"青海" forKey:@"63"];
    
    [dic setObject:@"宁夏" forKey:@"64"];
    
    [dic setObject:@"新疆" forKey:@"65"];
    
    [dic setObject:@"台湾" forKey:@"71"];
    
    [dic setObject:@"香港" forKey:@"81"];
    
    [dic setObject:@"澳门" forKey:@"82"];
    
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        
        return NO;
        
    }
    
    return YES;
    
}



/**
 * 功能:验证身份证是否合法
 * 参数:输入的身份证号
 */
- (BOOL) chk18PaperId:(NSString *) sPaperId
{
    //判断位数
    if ([sPaperId length] != 15 && [sPaperId length] != 18) {
        return NO;
    }
    NSString *carid = sPaperId;
    
    long lSumQT =0;
    
    //加权因子
    
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    
    //校验码
    
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    
    if ([sPaperId length] == 15) {
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        
        const char *pid = [mString UTF8String];
        
        for (int i=0; i<=16; i++)
            
        {
            
            p += (pid[i]-48) * R[i];
            
        }
        
        int o = p%11;
        
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        
        [mString insertString:string_content atIndex:[mString length]];
        
        carid = mString;
        
    }
    
    //判断地区码
    
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![self areaCode:sProvince]) {
        
        return NO;
        
    }
    
    //判断年月日是否有效
    
    
    
    //年份
    
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    
    //月份
    
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    
    //日
    
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateFormatter setTimeZone:localZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        
        return NO;
        
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    
    if( 18 != strlen(PaperId)) return -1;
    
    
    
    //校验数字
    
    for (int i=0; i<18; i++)
        
    {
        
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
            
        {
            
            return NO;
            
        }
        
    }
    
    //验证最末的校验码
    
    for (int i=0; i<=16; i++)
        
    {
        
        lSumQT += (PaperId[i]-48) * R[i];
        
    }
    
    if (sChecker[lSumQT%11] != PaperId[17] )
        
    {
        
        return NO;
        
    }
    
    return YES;
    
}

- (void) checkInfoComplete
{
    if ((nameValLab.text.length!=0) && (subValLab.text.length!=0)
                                    && (sexValLab.text.length!=0)
                                    && (idNumLab.text.length!=0)
                                    && (salaryLab.text.length!=0) && isSetTimeStatus && headUrl.length!=0)
    {
        finishBtn.enabled = YES;
        
        [finishBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                        forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark - Notice
- (void) selectTimePeriodNotice:(NSNotification *) sender
{
    NSInteger tag = ((NSNumber *)[sender.userInfo objectForKey:@"TAG"]).integerValue;
    if (tag==0) //确定
    {
        for (int i=0; i<21; i++)
            [setTimeArray setObject:@"0" atIndexedSubscript:i];
        
        isSetTimeStatus = YES;
        setTimeStatusLab.hidden = NO;
        
        setTimeArray = [((NSMutableArray *)[sender.userInfo objectForKey:@"SELECT_TIME_DIC"]) mutableCopy];
        [self checkInfoComplete];
    }
    
    CLog(@"setTimeArray:%@", setTimeArray);
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) hiddenHeadViewNotice:(NSNotification *) sender
{
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] dataForKey:TEACHER_INFO];
    Teacher *tObj = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    if (sender.userInfo)
    {
        headUrl = [[sender.userInfo objectForKey:@"HeadUrl"] copy];
        uploadStatusLab.hidden = NO;
        
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url = [NSString stringWithFormat:@"%@%@", webAdd, headUrl];
        tObj.headUrl = url;
        
        [self checkInfoComplete];
    }
    
    teacherData = [NSKeyedArchiver archivedDataWithRootObject:tObj];
    [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                              forKey:TEACHER_INFO];
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setSalaryFromCompleteNotice:(NSNotification *)sender
{
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] dataForKey:TEACHER_INFO];
    Teacher *tObj = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    int tag = ((NSNumber *)[sender.userInfo objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        NSDictionary *userInfoDic = sender.userInfo;
        if (userInfoDic)
        {
            salaryLab.text  = [userInfoDic objectForKey:@"name"];
            tObj.expense    = ((NSString *)[userInfoDic objectForKey:@"name"]).intValue;
        }
        
        teacherData = [NSKeyedArchiver archivedDataWithRootObject:tObj];
        [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                  forKey:TEACHER_INFO];
        [self checkInfoComplete];
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setSubjectFromNotice:(NSNotification *) sender
{
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] dataForKey:TEACHER_INFO];
    Teacher *tObj = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    int tag = ((NSNumber *)[sender.userInfo objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        NSDictionary *userInfoDic = sender.userInfo;
        if (userInfoDic)
        {
            NSDictionary *subDic = [userInfoDic objectForKey:@"subDic"];
            subValLab.text  = [subDic objectForKey:@"name"];
            tObj.pf         = [subDic objectForKey:@"name"];
        }
        
        teacherData = [NSKeyedArchiver archivedDataWithRootObject:tObj];
        [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                  forKey:TEACHER_INFO];
        [self checkInfoComplete];
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setPersonalInfoFromNotice:(NSNotification *)sender
{
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] dataForKey:TEACHER_INFO];
    Teacher *tObj = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    int tag = ((NSNumber *)[sender.userInfo objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        NSDictionary *userInfoDic = sender.userInfo;
        if (userInfoDic)
        {
            myInfoLab.text  = [userInfoDic objectForKey:@"personalInfo"];
            tObj.info       = [userInfoDic objectForKey:@"personalInfo"];
        }
        
        teacherData = [NSKeyedArchiver archivedDataWithRootObject:tObj];
        [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                  forKey:TEACHER_INFO];
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

- (void) setIdNumbersFromNotice:(NSNotification *)sender
{
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] dataForKey:TEACHER_INFO];
    Teacher *tObj = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    int tag = ((NSNumber *)[sender.userInfo objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        //验证身份证号码
        if (![self chk18PaperId:[sender.userInfo objectForKey:@"idNumbers"]])
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"请输入正确的身份证号码!"
                            delegate:self
                   otherButtonTitles:@"确定", nil];
        }
        else
        {
            NSDictionary *userInfoDic = sender.userInfo;
            if (userInfoDic)
            {
                idNumLab.text  = [userInfoDic objectForKey:@"idNumbers"];
                tObj.idNums    = [userInfoDic objectForKey:@"idNumbers"];
            }
            
            teacherData = [NSKeyedArchiver archivedDataWithRootObject:tObj];
            [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                      forKey:TEACHER_INFO];
            [self checkInfoComplete];
        }
    }
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setNickNameFromNotice:(NSNotification *)sender
{
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] dataForKey:TEACHER_INFO];
    Teacher *tObj = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    NSNotification *notice = sender;
    NSDictionary *userInfoDic = notice.userInfo;
    if (userInfoDic)
    {
        nameValLab.text  = [userInfoDic objectForKey:@"nickName"];
        tObj.name = [userInfoDic objectForKey:@"nickName"];
    }
    
    teacherData = [NSKeyedArchiver archivedDataWithRootObject:tObj];
    [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                              forKey:TEACHER_INFO];
    
    [self checkInfoComplete];
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setSexFromNotice:(NSNotification *) sender
{
    NSNotification *notice = sender;
    NSDictionary *userInfoDic = notice.userInfo;
    
    int tag = ((NSNumber *)[userInfoDic objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        NSData *teacherData  = [[NSUserDefaults standardUserDefaults] dataForKey:TEACHER_INFO];
        Teacher *tObj = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
        if (userInfoDic)
        {
            int index = ((NSNumber *)[userInfoDic objectForKey:@"Index"]).intValue;
            tObj.sex  = index;
            switch (index)
            {
                case 1:
                {
                    sexValLab.text = @"男";
                    break;
                }
                case 2:
                {
                    sexValLab.text = @"女";
                    break;
                }
                default:
                    break;
            }
        }
        
        teacherData = [NSKeyedArchiver archivedDataWithRootObject:tObj];
        [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                  forKey:TEACHER_INFO];
        [self checkInfoComplete];
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) doButtonClicked:(id)sender
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid   = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    
    NSString *valSex = nil;
    if ([sexValLab.text isEqualToString:@"男"])
        valSex = @"1";
    else
        valSex = @"2";
    
    NSArray *infosParamsArr = [NSArray arrayWithObjects:@"phone",@"email",@"nickname",
                               @"icon",@"subject",@"gender",
                               @"idnumber",@"expense", @"time_period",@"info",nil];
    
    NSMutableString *timePeriod = [[NSMutableString alloc]init];
    for (int i=0;i<20;i++)
         [timePeriod appendFormat:@"%@,",[setTimeArray objectAtIndex:i]];
    [timePeriod appendFormat:@"%@",[setTimeArray objectAtIndex:20]];
    
    NSArray *infosValuesArr = [NSArray arrayWithObjects:phoneValLab.text,emailValLab.text,nameValLab.text,headUrl,[Student searchSubjectID:subValLab.text],[Student searchGenderID:sexValLab.text],idNumLab.text,salaryLab.text,timePeriod,myInfoLab.text,nil];
    NSDictionary *infosDic  = [NSDictionary dictionaryWithObjects:infosValuesArr
                                                          forKeys:infosParamsArr];
    NSString *jsonInfos = [infosDic JSONFragment];
    
    //更新个人资料
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"infos",@"sessid",nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"upinfo",jsonInfos,ssid,nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    CLog(@"updateInfo:%@", pDic);
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate   = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@", webAddress,TEACHER];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
    [timePeriod release];
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDatasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 10)
    {
        return 80;
    }
    
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:idString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //获得Student
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
    Teacher *teacher     = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    switch (indexPath.row)
    {
        case 0:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text  = @"邮箱";
            infoLab.frame = CGRectMake(10, 12, 40, 20);
            infoLab.font  = [UIFont systemFontOfSize:14.f];
            [cell addSubview:infoLab];
            [infoLab release];
            
            emailValLab = [[UILabel alloc]init];
            emailValLab.text = teacher.email;
            emailValLab.font = [UIFont systemFontOfSize:14.f];
            emailValLab.textAlignment   = NSTextAlignmentLeft;
            emailValLab.backgroundColor = [UIColor clearColor];
            emailValLab.frame = CGRectMake(110, 12, 170, 20);
            [cell addSubview:emailValLab];
            
            break;
        }
        case 1:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text = @"手机";
            infoLab.font = [UIFont systemFontOfSize:14.f];
            infoLab.frame = CGRectMake(10, 12, 40, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            phoneValLab = [[UILabel alloc]init];
            phoneValLab.text  = teacher.phoneNums;
            phoneValLab.font  = [UIFont systemFontOfSize:14.f];
            phoneValLab.frame = CGRectMake(110, 12, 170, 20);
            phoneValLab.backgroundColor = [UIColor clearColor];
            phoneValLab.textAlignment   = NSTextAlignmentLeft;
            [cell addSubview:phoneValLab];
            break;
        }
        case 2:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"] highlightedImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text  = @"科目";
            infoLab.font  = [UIFont systemFontOfSize:14.f];
            infoLab.frame = CGRectMake(10, 12, 40, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            subValLab = [[UILabel alloc]init];
            subValLab.text  = teacher.pf;
            subValLab.font  = [UIFont systemFontOfSize:14.f];
            subValLab.frame = CGRectMake(110, 12, 170, 20);
            subValLab.backgroundColor = [UIColor clearColor];
            subValLab.textAlignment   = NSTextAlignmentLeft;
            [cell addSubview:subValLab];
            
            break;
        }
        case 3:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"] highlightedImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text  = @"姓名";
            infoLab.font  = [UIFont systemFontOfSize:14.f];
            infoLab.frame = CGRectMake(10, 12, 40, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            nameValLab = [[UILabel alloc]init];
            nameValLab.text  = teacher.name;
            nameValLab.font  = [UIFont systemFontOfSize:14.f];
            nameValLab.frame = CGRectMake(110, 12, 170,
                                           20);
            nameValLab.backgroundColor = [UIColor clearColor];
            nameValLab.textAlignment   = NSTextAlignmentLeft;
            [cell addSubview:nameValLab];
            
            break;
        }
        case 4:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"] highlightedImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text  = @"性别";
            infoLab.font  = [UIFont systemFontOfSize:14.f];
            infoLab.frame = CGRectMake(10, 12, 40, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            sexValLab = [[UILabel alloc]init];
            sexValLab.text  = [Student searchGenderName:[NSString stringWithFormat:@"%d",teacher.sex]];
            sexValLab.font  = [UIFont systemFontOfSize:14.f];
            sexValLab.textAlignment = NSTextAlignmentLeft;
            sexValLab.frame = CGRectMake(110, 12, 170, 20);
            sexValLab.backgroundColor = [UIColor clearColor];
            [cell addSubview:sexValLab];
            
            break;
        }
        case 5:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"]
                                                   highlightedImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text  = @"身份证号码";
            infoLab.font  = [UIFont systemFontOfSize:14.f];
            infoLab.frame = CGRectMake(10, 12, 100, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            idNumLab = [[UILabel alloc]init];
            idNumLab.text  = teacher.idNums;
            idNumLab.font  = [UIFont systemFontOfSize:14.f];
            idNumLab.textAlignment = NSTextAlignmentLeft;
            idNumLab.frame = CGRectMake(110, 12, 170, 20);
            idNumLab.backgroundColor = [UIColor clearColor];
            [cell addSubview:idNumLab];
            break;
        }
        case 6:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"] highlightedImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text  = @"每小时课酬";
            infoLab.font  = [UIFont systemFontOfSize:14.f];
            infoLab.frame = CGRectMake(10, 12, 100, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            salaryLab = [[UILabel alloc]init];
            salaryLab.text  = [NSString stringWithFormat:@"%d", teacher.expense];
            salaryLab.font  = [UIFont systemFontOfSize:14.f];
            salaryLab.textAlignment = NSTextAlignmentLeft;
            salaryLab.frame = CGRectMake(110, 12, 170, 20);
            salaryLab.backgroundColor = [UIColor clearColor];
            [cell addSubview:salaryLab];
            break;
        }
        case 7:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"] highlightedImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text  = @"自拍照";
            infoLab.font  = [UIFont systemFontOfSize:14.f];
            infoLab.frame = CGRectMake(10, 12, 60, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            uploadStatusLab = [[UILabel alloc]init];
            uploadStatusLab.hidden= YES;
            uploadStatusLab.text  = @"已上传";
            uploadStatusLab.font  = [UIFont systemFontOfSize:14.f];
            uploadStatusLab.textAlignment = NSTextAlignmentCenter;
            uploadStatusLab.frame = CGRectMake(50, 12, 170, 20);
            uploadStatusLab.backgroundColor = [UIColor clearColor];
            [cell addSubview:uploadStatusLab];
            break;
        }
        case 8:   //时间段设置
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"] highlightedImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text  = @"设置时段";
            infoLab.font  = [UIFont systemFontOfSize:14.f];
            infoLab.frame = CGRectMake(10, 12, 60, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            setTimeStatusLab = [[UILabel alloc]init];
            if (isSetTimeStatus)
                setTimeStatusLab.hidden = NO;
            else
                setTimeStatusLab.hidden = YES;
            setTimeStatusLab.text  = @"已设置";
            setTimeStatusLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
            setTimeStatusLab.font  = [UIFont systemFontOfSize:14.f];
            setTimeStatusLab.textAlignment = NSTextAlignmentCenter;
            setTimeStatusLab.frame = CGRectMake(50, 12, 170, 20);
            setTimeStatusLab.backgroundColor = [UIColor clearColor];
            [cell addSubview:setTimeStatusLab];
            break;
        }
        case 9:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"] highlightedImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text = @"个人简介";
            infoLab.font = [UIFont systemFontOfSize:14.f];
            infoLab.frame = CGRectMake(10, 12, 80, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            myInfoLab = [[UILabel alloc]init];
            myInfoLab.text  = teacher.info;
            myInfoLab.font  = [UIFont systemFontOfSize:14.f];
            myInfoLab.textAlignment = NSTextAlignmentLeft;
            myInfoLab.frame = CGRectMake(110, 12, 170, 20);
            myInfoLab.backgroundColor = [UIColor clearColor];
            [cell addSubview:myInfoLab];
            break;
        }
        case 10:
        {
            UIImage *loginImg  = [UIImage imageNamed:@"normal_btn"];
            finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            finishBtn.enabled = NO;
            [finishBtn setTitle:@"完成"
                       forState:UIControlStateNormal];
            [finishBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                            forState:UIControlStateNormal];
            [finishBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                            forState:UIControlStateHighlighted];
            [finishBtn setBackgroundImage:loginImg
                                 forState:UIControlStateNormal];
            finishBtn.frame = CGRectMake(5,
                                         30,
                                         upTab.frame.size.width-10,
                                         cell.frame.size.height);
            [finishBtn addTarget:self
                          action:@selector(doButtonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:finishBtn];
            cell.backgroundColor = [UIColor colorWithHexString:@"E1E0DE"];
            
            [self checkInfoComplete];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
   
    switch (indexPath.row)
    {
        case 2:        //选择科目
        {
            SelectSubjectViewController *ssVctr = [[SelectSubjectViewController alloc]init];
            ssVctr.subName = subValLab.text;
            [nav presentPopupViewController:ssVctr
                              animationType:MJPopupViewAnimationFade];
            break;
        }
        case 3:        //设置姓名
        {
            SetNickNameViewController *snVc = [[SetNickNameViewController alloc]init];
            snVc.name = nameValLab.text;
            [nav presentPopupViewController:snVc
                              animationType:MJPopupViewAnimationFade];
            break;
        }
        case 4:        //性别
        {
            SelectSexViewController *ssVctr = [[SelectSexViewController alloc]init];
            ssVctr.isSetSex = YES;
            ssVctr.sexName  = sexValLab.text;
            [nav presentPopupViewController:ssVctr
                              animationType:MJPopupViewAnimationFade];
            break;
        }
        case 5:        //身份证号码
        {
            SetIdNumberViewController *sIdVctr = [[SetIdNumberViewController alloc]init];
            sIdVctr.idNums = idNumLab.text;
            [nav presentPopupViewController:sIdVctr
                              animationType:MJPopupViewAnimationFade];
            break;
        }
        case 6:        //每小时课酬
        {
            SelectSalaryViewController *ssVctr = [[SelectSalaryViewController alloc]init];
            if (salaryLab.text.length==0)
                ssVctr.money = @"180";
            else
                ssVctr.money = salaryLab.text;
            [nav pushViewController:ssVctr animated:YES];
            [ssVctr release];
            break;
        }
        case 7:        //自拍照
        {
            SelectHeadViewController *shVctr = [[SelectHeadViewController alloc]init];
            shVctr.headUrl = headUrl;
            
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            [nav presentPopupViewController:shVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 8:        //设置时间
        {
            SetTimePeriodViewController *stpVctr = [[SetTimePeriodViewController alloc]init];
            stpVctr.setTimesArray = [setTimeArray mutableCopy];
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            [nav presentPopupViewController:stpVctr
                              animationType:MJPopupViewAnimationFade];
            break;
        }
        case 9:        //个人简介
        {
            SetPersonalInfoViewController *spVctr = [[SetPersonalInfoViewController alloc]init];
            [nav presentPopupViewController:spVctr animationType:MJPopupViewAnimationFade];
            break;
        }
        default:
            break;
    }
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
        NSDictionary *teacherDic = [resDic objectForKey:@"teacherInfo"];
        
        Teacher *tObj = [Teacher setTeacherProperty:teacherDic];
        NSData *teacherData = [NSKeyedArchiver archivedDataWithRootObject:tObj];
        
        [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                  forKey:TEACHER_INFO];
        
        //返回登陆
        [self gotoLoginView];
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

- (void) gotoLoginView
{
    //登录成功
    
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
@end
