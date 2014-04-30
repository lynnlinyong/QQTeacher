//
//  AppDelegate.m
//  QQStudent
//
//  Created by lynn on 14-1-23.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CLog(@"%s", __func__);
    
    NSSetUncaughtExceptionHandler(&cauchchException);
    
    //注册设备推送通知
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:
                                                         (UIRemoteNotificationTypeAlert |
                                                          UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound)];
    //ios5设置NavBar背景图片
    [self isIos5ToUpdateNav];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    UIViewController *pVctr = nil;
    if ([self isFirstLauncher])
    {
        SplashViewController *spVctr = [[[SplashViewController alloc]init]autorelease];
        pVctr = spVctr;
        
        self.window.rootViewController = pVctr;
        self.window.backgroundColor    = [[UIColor whiteColor] retain];
        [self.window makeKeyAndVisible];
    }
    else
    {
        BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:LOGINE_SUCCESS];
        if (isLogin)
        {
//            NSArray *paramsArray = [NSArray arrayWithObjects:@"type",@"nickname",@"grade",@"gender",@"subjectId",@"teacherGender",@"tamount",@"yjfdnum",@"sd",@"iaddress",@"iaddress",@"longitude",@"latitude",@"otherText",@"deviceId",@"keyId", nil];
//            
//            NSArray *valuesArray = [NSArray arrayWithObjects:@"0",@"sdfsdf",@"大四",@"男",@"13",@"1",@"100",@"10",@"2013/3/3 上午",@"sdfsdfsdfsdf",@"10.2",@"10.2",@"sdfsd",@"sdfsdfsdf",@"sdfsdfs",@"sdfsd", nil];
//            NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArray forKeys:paramsArray];
            MainViewController *mainVctr     = [[MainViewController alloc]init];
//            [mainVctr addInviteNotice:pDic];
            
            //跳转个人中心
            MyTeacherViewController *mVctr = [[MyTeacherViewController alloc]init];
            UINavigationController *navMvctr = [[UINavigationController alloc]initWithRootViewController:mVctr];
            
            LatlyViewController *lVctr = [[LatlyViewController alloc]init];
            UINavigationController *navLVctr = [[UINavigationController alloc]initWithRootViewController:lVctr];
            
            UIViewController *sVctr = [[UIViewController alloc]init];
            UINavigationController *navSVctr = [[UINavigationController alloc]initWithRootViewController:sVctr];
            
            ShareViewController *shareVctr   = [[ShareViewController alloc]initWithNibName:nil
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
            
            PersonCenterViewController *pcVctr = [[PersonCenterViewController alloc]
                                                  initWithViewControllers:ctrlArr
                                                  imageArray:imgArr];
            
            CustomNavigationViewController *nav = [[CustomNavigationViewController alloc]initWithRootViewController:pcVctr];
            self.window.rootViewController = nav;
            self.window.backgroundColor = [[UIColor whiteColor] retain];
            [self.window makeKeyAndVisible];
            [nav pushViewController:mainVctr animated:YES];
        }
        else
        {
            LoginViewController *login = [[LoginViewController alloc]init];
            CustomNavigationViewController *nav = [[CustomNavigationViewController alloc]initWithRootViewController:login];
            self.window.rootViewController = nav;
            self.window.backgroundColor = [[UIColor whiteColor] retain];
            [self.window makeKeyAndVisible];
        }
    }
    
    return YES;
}

void cauchchException(NSException *exception)
{
    NSLog(@"Crash:%@", exception);
    NSLog(@"Stack TRace:%@", [exception callStackSymbols]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    //离线更新
    [self updateLoginStatus:0];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    CLog(@"%s", __func__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    CLog(@"%s", __func__);
    
    //清除消息中心消息
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
    
    //获得Web服务器地址
    [MainViewController getWebServerAddress];
    
    //初始化MQTT Server
    [self initMQTTServer];

    //获取未读消息列表
    [self getPushMessage];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //上线更新
        [self updateLoginStatus:1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
    
    //向微信注册
    [WXApi registerApp:WeiXinAppID withDescription:@"QQ_TEACHER_IOS v1.0"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeNoticeWall:)
                                                 name:@"closeNoticeWall"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doOrderConfirmNotice:)
                                                 name:@"setOrderConfirmNotice"
                                               object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    CLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}

#pragma mark -
#pragma mark - Custom Action
- (void) doOrderConfirmNotice:(NSNotification *) notice
{
    NSNumber *tag = [notice.userInfo objectForKey:@"TAG"];
    Order *order  = [notice.userInfo objectForKey:@"ORDER"];
    
    if (tag.intValue == 0)
    {
        //订单确认
        NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"orderid",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"orderConfirm",order.orderId,ssid, nil];
        
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
        if (resVal)
        {
            NSDictionary *resDic   = [NSJSONSerialization JSONObjectWithData:resVal
                                                                     options:NSJSONReadingMutableLeaves
                                                                       error:nil];
            CLog(@"resDic:%@", resDic);
            NSNumber *errorid = [resDic objectForKey:@"errorid"];
            if (errorid.intValue == 0)
            {
                NSString *action = [resDic objectForKey:@"action"];
                if ([action isEqualToString:@"orderConfirm"])
                {
                    CLog(@"OrderConfirm Susscess!");
                    
                    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
                    Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
                    
                    NSNumber *numEmploy = [notice.userInfo objectForKey:@"IsEmploy"];
                    BOOL isEmploy = [numEmploy boolValue];
                    if (!isEmploy)   //修改订单消息
                    {
                        //发出确认消息
                        NSArray *paramsArr  = [NSArray arrayWithObjects:@"type", @"phone", @"nickname", @"icon",
                                               @"orderid",@"taPhone",@"deviceId",nil];
                        NSArray *valuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_ORDER_CONFIRM_SUCCESS],teacher.phoneNums,teacher.name,teacher.headUrl,order.orderId,order.student.phoneNumber,[SingleMQTT getCurrentDevTopic], nil];
                        NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                                          forKeys:paramsArr];
                        
                        //发送消息
    //                    NSString *jsonMsg   = [pDic JSONFragment];
    //                    NSData *data        = [jsonMsg dataUsingEncoding:NSUTF8StringEncoding];
                        NSData *data = [NSJSONSerialization dataWithJSONObject:pDic
                                                                       options:NSJSONWritingPrettyPrinted
                                                                         error:nil];
                        SingleMQTT *session = [SingleMQTT shareInstance];
                        [session.session publishData:data
                                             onTopic:order.student.deviceId];
                    }
                    else            //发起聘请消息
                    {
                        //发出确认消息
                        NSArray *paramsArr  = [NSArray arrayWithObjects:@"type", @"phone", @"nickname", @"icon",
                                               @"orderid",@"taPhone",@"deviceId",nil];
                        NSArray *valuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_ORDER_EDIT_SUCCESS],teacher.phoneNums,teacher.name,teacher.headUrl,order.orderId,order.student.phoneNumber,[SingleMQTT getCurrentDevTopic], nil];
                        NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                                          forKeys:paramsArr];
                        
                        //发送消息
    //                    NSString *jsonMsg   = [pDic JSONFragment];
    //                    NSData *data        = [jsonMsg dataUsingEncoding:NSUTF8StringEncoding];
                        NSData *data = [NSJSONSerialization dataWithJSONObject:pDic
                                                                       options:NSJSONWritingPrettyPrinted
                                                                         error:nil];
                        SingleMQTT *session = [SingleMQTT shareInstance];
                        [session.session publishData:data
                                             onTopic:order.student.deviceId];
                    }
                }
                
                //通知界面更新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrders"
                                                                    object:nil];
            }
            else
            {
                CLog(@"OrderConfirm Failed!");
            }
        }
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) closeNoticeWall:(NSNotification *) notice
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) getPushMessage
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    if (!webAdd)
    {
        [MainViewController getWebServerAddress];
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if (ssid)
    {
        NSArray *paramsArray = [NSArray arrayWithObjects:@"action",@"sessid", nil];
        NSArray *valuesArray = [NSArray arrayWithObjects:@"getPushMessage",ssid,nil];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", webAdd,TEACHER];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestAsyncSuccessed:)];
        [request setDidFailSelector:@selector(requestAsyncFailed:)];
        for (int i=0; i<paramsArray.count; i++)
        {
            if ([[paramsArray objectAtIndex:i] isEqual:UPLOAD_FILE])
            {
                NSDictionary *fileDic = [valuesArray objectAtIndex:i];
                NSString *fileParam   = [[fileDic allKeys] objectAtIndex:0];
                NSString *filePath    = [[fileDic allValues]objectAtIndex:0];
                [request setFile:filePath forKey:fileParam];
                continue;
            }
            
            [request setPostValue:[valuesArray objectAtIndex:i]
                           forKey:[paramsArray objectAtIndex:i]];
        }
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request addRequestHeader:@"Content-Type"
                            value:@"text/xml; charset=utf-8"];
        [request startAsynchronous];
    }
}

- (void) updateLoginStatus:(int) isBackgroud
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    //判断是否显示试听和聘请
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if (ssid)
    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"online",@"sessid", nil];
        NSArray *valusArr  = [NSArray arrayWithObjects:@"updateLoginStatus",[NSNumber numberWithInt:isBackgroud],ssid, nil];
        
        NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd, TEACHER];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        for (int i=0; i<paramsArr.count; i++)
        {
            CLog(@"value:%@", [valusArr objectAtIndex:i]);
            CLog(@"param:%@", [paramsArr objectAtIndex:i]);
            
            if ([[paramsArr objectAtIndex:i] isEqual:UPLOAD_FILE])
            {
                NSDictionary *fileDic = [valusArr objectAtIndex:i];
                NSString *fileParam   = [[fileDic allKeys] objectAtIndex:0];
                NSString *filePath    = [[fileDic allValues]objectAtIndex:0];
                [request setFile:filePath forKey:fileParam];
                continue;
            }
            
            [request setPostValue:[valusArr objectAtIndex:i]
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
        if (resVal)
        {
            NSDictionary *resDic   = [NSJSONSerialization JSONObjectWithData:resVal
                                                                     options:NSJSONReadingMutableLeaves
                                                                       error:nil];
            CLog(@"updateLoginStatus:%@", resDic);
            NSString *action = [resDic objectForKey:@"action"];
            if ([action isEqualToString:@"updateLoginStatus"])
            {
                CLog(@"Update Login Status Success!");
            }
            else
            {
                CLog(@"Update Login Status Failed!");
            }
        }
    }
}

- (void) initMQTTServer
{
    //连接MQTT服务器
    SingleMQTT *session = [SingleMQTT shareInstance];
    [SingleMQTT connectServer];
    [session.session setDelegate:self];
}

- (void) tapGestureResponse:(UIGestureRecognizer *)reg
{
    MBProgressHUD *hud = (MBProgressHUD *)reg.view;
    [hud removeFromSuperview];
    [hud release];
    hud = nil;
}

+ (BOOL) isConnectionAvailable:(BOOL) animated withGesture:(BOOL) isCan
{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork && animated)
    {
        if (!isCan)
        {   
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
            hud.delegate  = appDelegate;
            hud.labelText = @"当前网络不可用";
            hud.square = YES;
            [hud show:YES];
            [hud hide:YES afterDelay:3];
        }
        return NO;
    }
    
    return isExistenceNetwork;
}

- (BOOL) isFirstLauncher
{
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:LAUNCHERED];
    if (isFirst)
    {
        //表示不是第一次启动软件
        return NO;
    }

    //表示第一次启动软件
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:LAUNCHERED];
    
    return YES;
}

- (void) isIos5ToUpdateNav
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_top_bg"]
                                       forBarMetrics:UIBarMetricsDefault];
#endif
}

+ (void) popToMainViewController
{
    LoginViewController *login = [[LoginViewController alloc]init];
    CustomNavigationViewController *nav = [[CustomNavigationViewController alloc]initWithRootViewController:login];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = nav;
}

+ (BOOL) isInView:(NSString *) vctrName
{
    BOOL isIn = NO;
    
    CustomNavigationViewController *vctr = [MainViewController getNavigationViewController];
    
    UIViewController *lastVctr = [vctr.viewControllers objectAtIndex:vctr.viewControllers.count-1];
    if ([lastVctr isKindOfClass:NSClassFromString(vctrName)])
    {
        isIn = YES;
    }
    
    return isIn;
}

+(void) dealWithMessage:(NSDictionary *)msgDic isPlayVoice:(BOOL) isPlay
{    
    //解析MQTT接收消息
    int msgType = ((NSString *)[msgDic objectForKey:@"type"]).intValue;
    switch (msgType)
    {
        case PUSH_TYPE_PUSH:       //接收学生邀请信息
        {
            //提示音播放,刷新页面显示
            NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_record_start"
                                                                ofType:@"wav"];
            NSData *infoSound = [NSData dataWithContentsOfFile:path];
            [RecordAudio playVoice:infoSound];
            
            //跳转到抢单页显示
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            if (![AppDelegate isInView:NSStringFromClass([MainViewController class])])  //不在最顶层页面.
            {
                MainViewController *mVctr = [[MainViewController alloc]init];
                [mVctr addInviteNotice:msgDic];
                [nav pushViewController:mVctr animated:YES];
                [mVctr release];
            }
            else
            {
                //发送邀请Notice,在顶层
                NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:msgDic,@"InviteDic", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"InviteNotice"
                                                                    object:nil
                                                                  userInfo:userDic];
            }
            break;
        }
        case PUSH_TYPE_APPLY:
        {
            break;
        }
        case PUSH_TYPE_CONFIRM:     //学生的确认抢单消息
        {
            //提示音播放,刷新页面显示
            NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_record_start"
                                                                ofType:@"wav"];
            NSData *infoSound = [NSData dataWithContentsOfFile:path];
            [RecordAudio playVoice:infoSound];
            
            NSDictionary *confirmDic = [NSDictionary dictionaryWithObjectsAndKeys:msgDic,@"confirmDic", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"confirmOrderNotice"
                                                                object:nil
                                                              userInfo:confirmDic];
            break;
        }
        case PUSH_TYPE_IMAGE:       //接收到图片消息
        case PUSH_TYPE_AUDIO:       //接收到音频消息
        {
            //判断是否在聊天界面
            if ([AppDelegate isInView:@"ChatViewController"] )
            {
                if (isPlay)
                {
                    //提示音播放,刷新页面显示
                    NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_record_start"
                                                                        ofType:@"wav"];
                    NSData *infoSound = [NSData dataWithContentsOfFile:path];
                    [RecordAudio playVoice:infoSound];
                }
                
                //发送刷新数据Notice
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewData"
                                                                    object:nil
                                                                  userInfo:msgDic];
            }
            else
            {
                
                //播放您有一条新消息,跳转聊天界面显示
                if (isPlay)
                {
                    NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_message_text_new"
                                                                        ofType:@"wav"];
                    NSData *infoSound = [NSData dataWithContentsOfFile:path];
                    [RecordAudio playVoice:infoSound];
                }
                
                //pop当前页显示提示
                NoticePopView *popView  = [NoticePopView shareInstance];
                popView.noticeType      = NOTICE_MSG;
                popView.contentDic      = msgDic;
                popView.titleLab.text   = @"您有一条新消息";
                popView.contentLab.text = @"语音消息";
                [popView popView];
            }
            break;
        }
        case PUSH_TYPE_TEXT:        //接收到文本消息
        {
            //判断是否在聊天界面
            if ([AppDelegate isInView:@"ChatViewController"] )
            {
                //提示音播放,刷新页面显示
                if (isPlay)
                {
                    NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_record_start"
                                                                        ofType:@"wav"];
                    NSData *infoSound = [NSData dataWithContentsOfFile:path];
                    [RecordAudio playVoice:infoSound];
                }
                
                //发送刷新数据Notice
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewData"
                                                                    object:nil
                                                                 userInfo:msgDic];
            }
            else
            {
                //播放您有一条新消息,点击跳转聊天界面显示
                if (isPlay)
                {
                    NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_message_text_new"
                                                                        ofType:@"wav"];
                    NSData *infoSound = [NSData dataWithContentsOfFile:path];
                    [RecordAudio playVoice:infoSound];
                }
                
                //pop当前页显示提示
                NoticePopView *popView = [NoticePopView shareInstance];
                popView.noticeType     = NOTICE_MSG;
                popView.contentDic     = [msgDic copy];
                popView.titleLab.text  = @"您有一条新消息";
                popView.contentLab.text= [msgDic objectForKey:@"text"];
                [popView popView];
            }
            break;
        }
        case PUSH_TYPE_ORDER_EDIT:    //收到学生修改订单消息
        {
            //提示音播放,刷新页面显示
            NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_record_start"
                                                                ofType:@"wav"];
            NSData *infoSound = [NSData dataWithContentsOfFile:path];
            [RecordAudio playVoice:infoSound];
            
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            OrderConfirmViewController *ocVctr  = [[OrderConfirmViewController alloc]init];
            ocVctr.isEmploy = NO;
            ocVctr.order = nil;
            ocVctr.noticeDic = msgDic;
            [nav presentPopupViewController:ocVctr animationType:MJPopupViewAnimationFade];
            break;
        }
        case PUSH_TYPE_ORDER_CONFIRM: //收到学生聘请消息
        {
            //提示音播放,刷新页面显示
            NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_record_start"
                                                                ofType:@"wav"];
            NSData *infoSound = [NSData dataWithContentsOfFile:path];
            [RecordAudio playVoice:infoSound];
            
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            OrderConfirmViewController *ocVctr  = [[OrderConfirmViewController alloc]init];
            ocVctr.isEmploy = YES;
            ocVctr.order = nil;
            ocVctr.noticeDic = msgDic;
            [nav presentPopupViewController:ocVctr animationType:MJPopupViewAnimationFade];
            break;
        }
        case PUSH_TYPE_ORDER_EDIT_SUCCESS:
        {
//            CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
//            [nav showAlertWithTitle:@"恭喜您"
//                                tag:0
//                            message:@"老师已经接受了您的聘请!"
//                           delegate:self
//                  otherButtonTitles:@"知道了",nil];
            break;
        }
        case PUSH_TYPE_ORDER_CONFIRM_SUCCESS:  //订单修改确认
        {
//            CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
//            [nav showAlertWithTitle:@"提示"
//                                tag:0
//                            message:@"老师已经确认了您的订单修改!"
//                           delegate:self
//                  otherButtonTitles:@"知道了",nil];
            break;
        }
        case PUSH_TYPE_PUSHCC:                //助教消息
        {
            NoticeWallViewController *noticeWall = [[NoticeWallViewController alloc]init];
            noticeWall.title   = [msgDic objectForKey:@"title"];
            noticeWall.content = [msgDic objectForKey:@"text"];
            CustomNavigationViewController *nav  = [MainViewController getNavigationViewController];
            [nav presentPopupViewController:noticeWall
                              animationType:MJPopupViewAnimationFade];
            
            if ([AppDelegate isInView:NSStringFromClass([AssistentViewController class])])
            {
                //刷新界面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewApplyNotice"
                                                                    object:nil];
            }
            break;
        }
        case PUSH_TYPE_LISTENING_CHANG:       //试听改变
        {
//            //判断当前是否在聊天窗口
//            if ([AppDelegate isInView:@"ChatViewController"])
//            {
//                //发送教师端试听改变Notice
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"listenChanged"
//                                                                    object:nil
//                                                                  userInfo:msgDic];
//            }
            break;
        }
        case PUSH_TYPE_OFFLINE_MSG:           //异地登录,消息下线
        {
            //清除登录标识
            [[NSUserDefaults standardUserDefaults] setBool:NO
                                                    forKey:LOGINE_SUCCESS];
            
            //显示登录页面
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            LoginViewController *loginVctr = [[LoginViewController alloc]init];
            CustomNavigationViewController *nav = [[CustomNavigationViewController alloc]initWithRootViewController:loginVctr];
            appDelegate.window.rootViewController = nav;
            
            //提示用户
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"您已经在另一台设备上登录!"
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"知道了", nil];
            [alertView show];
            [alertView release];
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
    CLog(@"***********Result****************");
    CLog(@"ERROR");
    CLog(@"***********Result****************");
}

- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{
    NSData   *resVal = [request responseData];
    if (resVal)
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
        
        NSString *errorid = (NSString *)[[resDic objectForKey:@"errorid"] copy];
        if (errorid.intValue == 0)
        {
            NSString *action = [[resDic objectForKey:@"action"] copy];
            if ([action isEqualToString:@"getPushMessage"])
            {
                //处理未处理消息
                NSArray *messageArr = [resDic objectForKey:@"messages"];
                if (messageArr.count>0)
                {
                    NSDictionary *msgDic = [messageArr objectAtIndex:messageArr.count-1];
                    [AppDelegate dealWithMessage:msgDic
                                     isPlayVoice:YES];
                }
            }
            [action release];
        }
        //重复登录
        else if (errorid.intValue==2)
        {
            //清除sessid,清除登录状态,回到地图页
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SSID];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGINE_SUCCESS];
            [AppDelegate popToMainViewController];
        }
        [errorid release];
    }
}

#pragma mark - MQtt Callback methods
- (void)session:(MQTTSession*)sender
     newMessage:(NSData*)data
        onTopic:(NSString*)topic
{
    NSDictionary *pDic = nil;
    CLog(@"new message, %lu bytes, topic=%@", (unsigned long)[data length], topic);
    if (data)
    {
        pDic = [NSJSONSerialization JSONObjectWithData:data
                                               options:NSJSONReadingMutableLeaves error:nil];
        CLog(@"DIC:%@", pDic);
    }
    
    if ([topic isEqualToString:@"adtopic"])         //广告消息
    {
        NoticePopView *popView = [NoticePopView shareInstance];
        popView.noticeType = NOTICE_AD;
        popView.contentDic = pDic;
        popView.titleLab.text   = [pDic objectForKey:@"title"];
        popView.contentLab.text = [pDic objectForKey:@"message"];
        [popView popView];
    }
    else if ([topic isEqualToString:@"ggtopic"])    //公告消息
    {
        NoticeWallViewController *noticeWall = [[NoticeWallViewController alloc]init];
        noticeWall.title   = [pDic objectForKey:@"title"];
        noticeWall.content = [pDic objectForKey:@"message"];
        CustomNavigationViewController *nav  = [MainViewController getNavigationViewController];
        [nav presentPopupViewController:noticeWall
                          animationType:MJPopupViewAnimationFade];
    }
    else //交互消息  1.沟通消息(文本,语音) 2.修改订单确认 3.聘请修改 4.订单确认 5.抢单)
    {
        [AppDelegate dealWithMessage:pDic
                         isPlayVoice:YES];
    }
}

- (void)session:(MQTTSession*)sender handleEvent:(MQTTSessionEvent)eventCode {
    switch (eventCode) {
        case MQTTSessionEventConnected:
            CLog(@"connected");
            break;
        case MQTTSessionEventConnectionRefused:
            CLog(@"connection refused");
            break;
        case MQTTSessionEventConnectionClosed:
            CLog(@"connection closed");
            break;
        case MQTTSessionEventConnectionError:
            CLog(@"connection error");
            CLog(@"reconnecting...");
            // Forcing reconnection
            if ([AppDelegate isConnectionAvailable:YES withGesture:NO])
                [SingleMQTT connectServer];
            break;
        case MQTTSessionEventProtocolError:
            CLog(@"protocol error");
            break;
    }
}

#pragma mark - Remote Notice Action
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *devToken = [token stringByReplacingOccurrencesOfString:@" "
                                                          withString:@""];
    CLog(@"New Device ToKen:%@", devToken);
    [[NSUserDefaults standardUserDefaults] setObject:devToken
                                              forKey:DEVICE_TOKEN];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    CLog(@"RegisterForRemoteNotifications:%@", [NSString stringWithFormat: @"Error: %@", error]);
    [[NSUserDefaults standardUserDefaults] setObject:@"deviceToken_error"
                                              forKey:DEVICE_TOKEN];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    CLog(@"New APNS Message:%@", userInfo);
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideAllHUDsForView:nav.view animated:YES];
}

#pragma mark -
#pragma mark - WXApiDelegate
- (void) onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {        
        if (resp.errCode == 0) //分享成功
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"分享成功"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else                   //分享失败
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[NSString stringWithFormat:@"分享失败,errCode:%d", resp.errCode]
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }

}
@end
