//
//  MainViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "MainViewController.h"

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

static NSMutableArray  *inviteMsgArray = nil;
static NSMutableArray  *timerArray= nil;

@implementation MainViewBottomInfoView
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        bgView = [[UIImageView alloc]init];
        bgView.image = [UIImage imageNamed:@"mtp_info_bg"];
        bgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:bgView];
        
        UITapGestureRecognizer *tapReg = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(doTapGestureReg:)];
        [self addGestureRecognizer:tapReg];
        [tapReg release];
        
        UILabel *starInfoLab = [[UILabel alloc]init];
        starInfoLab.text = @"星级制度:";
        starInfoLab.backgroundColor = [UIColor clearColor];
        starInfoLab.textColor = [UIColor whiteColor];
        starInfoLab.font = [UIFont systemFontOfSize:13.f];
        starInfoLab.frame = CGRectMake(10, 20, frame.size.width-20, 15);
        [self addSubview:starInfoLab];
        [starInfoLab release];
        
        UIImageView *starImgView = [[UIImageView alloc]init];
        starImgView.image = [UIImage imageNamed:@"mt_star_hlight"];
        starImgView.frame = CGRectMake(10, 37, 10, 10);
        [self addSubview:starImgView];
        [starImgView release];
        
        UILabel *starValueLab = [[UILabel alloc]init];
        starValueLab.text = @"   代表您的受欢迎程度,好评3次加1星,差评1次减1星,最多6星,So~~,鼓励学生多多给您好评吧！";
        starValueLab.numberOfLines = 0;
        starValueLab.lineBreakMode = NSLineBreakByWordWrapping;
        starValueLab.backgroundColor = [UIColor clearColor];
        starValueLab.textColor = [UIColor whiteColor];
        starValueLab.font = [UIFont systemFontOfSize:13.f];
        starValueLab.frame = CGRectMake(10, 28, frame.size.width-20, 60);
        [self addSubview:starValueLab];
        [starValueLab release];
        
        UILabel *complainInfoLab = [[UILabel alloc]init];
        complainInfoLab.text = @"星级制度:";
        complainInfoLab.backgroundColor = [UIColor clearColor];
        complainInfoLab.textColor = [UIColor whiteColor];
        complainInfoLab.font = [UIFont systemFontOfSize:13.f];
        complainInfoLab.frame = CGRectMake(10, 85, frame.size.width-20, 15);
        [self addSubview:complainInfoLab];
        [complainInfoLab release];
        
        UILabel *complainValueLab = [[UILabel alloc]init];
        complainValueLab.text = @"如果我们收到学生投诉,经客服查核若属实,将根据情节严重程度给予冻结账号一个月或永久封号的处罚.";
        complainValueLab.numberOfLines = 0;
        complainValueLab.lineBreakMode = NSLineBreakByWordWrapping;
        complainValueLab.backgroundColor = [UIColor clearColor];
        complainValueLab.textColor = [UIColor whiteColor];
        complainValueLab.font = [UIFont systemFontOfSize:13.f];
        complainValueLab.frame = CGRectMake(10, 95, frame.size.width-20, 60);
        [self addSubview:complainValueLab];
        [complainValueLab release];
    }
    
    return self;
}

- (void) dealloc
{
    [bgView release];
    [super dealloc];
}

- (void) doTapGestureReg:(UIGestureRecognizer *) reg
{
    self.hidden = YES;
}
@end

@implementation MainViewPopInfoView
@synthesize delegate;

- (id) initWithFrame:(CGRect)frame type:(PopInfoType) tmpType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        type = tmpType;
        switch (tmpType)
        {
            case kWaitPopInfoType:
            {
                UIImage *image    = [UIImage imageNamed:@"mtp_confirm_waited"];
                popInfoView       = [[UIImageView alloc]init];
                popInfoView.image = image;
                popInfoView.frame = CGRectMake(frame.size.width/2-image.size.width/2, 20, image.size.width, image.size.height);
                [self addSubview:popInfoView];
                
                
                UIImage *loadImg = [UIImage imageNamed:@"mtp_wait_loading"];
                UIImageView *loadImgView = [[[UIImageView alloc]init]autorelease];
                loadImgView.image = loadImg;
                loadImgView.frame = CGRectMake(20, frame.size.height-20-20-20,
                                               loadImg.size.width, loadImg.size.height);
                [self addSubview:loadImgView];
                
                //开始选择动画
                [self startAnimation:loadImgView];
                
                UILabel *infoLab = [[UILabel alloc]init];
                infoLab.text = @"系统正在处理...";
                infoLab.textColor = [UIColor whiteColor];
                infoLab.textAlignment   = NSTextAlignmentCenter;
                infoLab.backgroundColor = [UIColor clearColor];
                infoLab.font = [UIFont systemFontOfSize:18.f];
                infoLab.frame = CGRectMake(frame.size.width/2-80,
                                           frame.size.height-20-20-20, 200, 20);
                [self addSubview:infoLab];
                [infoLab release];
                
                UILabel *infoLineLab = [[UILabel alloc]init];
                infoLineLab.text = @"请耐心稍等一会儿!";
                infoLineLab.textAlignment   = NSTextAlignmentCenter;
                infoLineLab.textColor = [UIColor whiteColor];
                infoLineLab.backgroundColor = [UIColor clearColor];
                infoLineLab.font = [UIFont systemFontOfSize:18.f];
                infoLineLab.frame = CGRectMake(frame.size.width/2-80,
                                           frame.size.height-20-20, 200, 20);
                [self addSubview:infoLineLab];
                [infoLineLab release];
                
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                                  target:self
                                                                selector:@selector(timeOut:)
                                                                userInfo:nil
                                                                 repeats:YES];
                [timer fire];
                break;
            }
            case kNoResponseType:
            {
                UIImage *image = [UIImage imageNamed:@"mtp_confirm_waited"];
                popInfoView = [[UIImageView alloc]init];
                popInfoView.image = image;
                popInfoView.frame = CGRectMake(frame.size.width/2-image.size.width/2, 20, image.size.width, image.size.height);
                [self addSubview:popInfoView];
                
                UILabel *infoLab = [[UILabel alloc]init];
                infoLab.text = @"长时间未响应";
                infoLab.textColor = [UIColor whiteColor];
                infoLab.textAlignment   = NSTextAlignmentCenter;
                infoLab.backgroundColor = [UIColor clearColor];
                infoLab.font = [UIFont systemFontOfSize:18.f];
                infoLab.frame = CGRectMake(frame.size.width/2-100,
                                           frame.size.height-20-20-20, 200, 20);
                [self addSubview:infoLab];
                [infoLab release];
                
                UILabel *infoLineLab = [[UILabel alloc]init];
                infoLineLab.text = @"请等待几秒再试!";
                infoLineLab.textAlignment   = NSTextAlignmentCenter;
                infoLineLab.textColor = [UIColor whiteColor];
                infoLineLab.backgroundColor = [UIColor clearColor];
                infoLineLab.font = [UIFont systemFontOfSize:18.f];
                infoLineLab.frame = CGRectMake(frame.size.width/2-100,
                                               frame.size.height-20-20, 200, 20);
                [self addSubview:infoLineLab];
                [infoLineLab release];

                timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                                  target:self
                                                                selector:@selector(timeOut:)
                                                                userInfo:nil
                                                                 repeats:YES];
                [timer fire];
                break;
            }
            case kFailedReponseType:
            {
                UIImage *image = [UIImage imageNamed:@"mtp_confirm_failed"];
                popInfoView = [[UIImageView alloc]init];
                popInfoView.image = image;
                popInfoView.frame = CGRectMake(frame.size.width/2-image.size.width/2, 20, image.size.width, image.size.height);
                [self addSubview:popInfoView];
                
                UILabel *infoLab = [[UILabel alloc]init];
                infoLab.text = @"您满了,此单已经被抢!";
                infoLab.textColor = [UIColor whiteColor];
                infoLab.textAlignment   = NSTextAlignmentCenter;
                infoLab.backgroundColor = [UIColor clearColor];
                infoLab.font = [UIFont systemFontOfSize:18.f];
                infoLab.frame = CGRectMake(frame.size.width/2-100,
                                           frame.size.height-20-20-20, 200, 20);
                [self addSubview:infoLab];
                [infoLab release];
                
                UILabel *infoLineLab = [[UILabel alloc]init];
                infoLineLab.text = @"继续去抢单吧!";
                infoLineLab.textAlignment   = NSTextAlignmentCenter;
                infoLineLab.textColor = [UIColor whiteColor];
                infoLineLab.backgroundColor = [UIColor clearColor];
                infoLineLab.font = [UIFont systemFontOfSize:18.f];
                infoLineLab.frame = CGRectMake(frame.size.width/2-100,
                                               frame.size.height-20-20, 200, 20);
                [self addSubview:infoLineLab];
                [infoLineLab release];
                
                timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                                  target:self
                                                                selector:@selector(timeOut:)
                                                                userInfo:nil
                                                                 repeats:YES];
                [timer fire];
                break;
            }
            default:
                break;
        }
        self.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

- (void) dealloc
{
    [popInfoView release];
    [super dealloc];
}

- (void) stopTimer
{
    [timer invalidate];
    timer = nil;
}

- (void)startAnimation:(UIImageView *) imgView
{
    static int angle = 90;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle*(M_PI / 180.0f));
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imgView.transform = endAngle;
    } completion:^(BOOL finished) {
        angle += 10;
        [self startAnimation:imgView];
    }];
    
}

- (void) timeOut:(id)sender
{
    int calTimes     = 0;
    static int count = 0;
    switch (type)
    {
        case kWaitPopInfoType:
        {
            calTimes = 10;
            break;
        }
        case kNoResponseType:
        case kFailedReponseType:
        {
            calTimes = 3;
            break;
        }
        default:
            break;
    }
    
    count++;
    if (count == calTimes)
    {
        count = 0;
        self.hidden = YES;
        
        NSTimer *timer = sender;
        [timer invalidate];
        timer = nil;
        
        if (type == kWaitPopInfoType)
        {
            if (delegate)
            {
                if ([delegate respondsToSelector:@selector(mainViewPopInfoWaitViewTimeOut:)])
                    [delegate mainViewPopInfoWaitViewTimeOut:self];
            }
        }
    }
}
@end

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize mapView;

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
    
    //设置Title
    [MainViewController setNavTitle:@"个人中心"];
    
    [self initBackBarItem];
    
    if (inviteMsgArray.count==0)
    {
        bottomView.hidden = NO;
        noticeTab.hidden = YES;
    }
    else
    {
        noticeTab.hidden = NO;
        bottomView.hidden = YES;
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inviteNotice:)
                                                 name:@"InviteNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(confirmOrderNotice:)
                                                 name:@"confirmOrderNotice"
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    isLocation   = NO;
    
    studentArray = [[NSMutableArray alloc]init];
    
    //初始化地图API
    [self initMapKey];
    
    //初始化UI
    [self initUI];
    
    //获取终端设置属性
    [self setTerminalMapProperty];
    
    //获取教学助理
    [self getJxzl];
}

- (void) viewDidDisappear:(BOOL)animated
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    [annArray removeAllObjects];
    [studentArray removeAllObjects];
    self.mapView.delegate = nil;
    
    [super viewDidUnload];
}

- (void) dealloc
{
    [search release];
    [annArray release];
    [studentArray release];
    [mapView release];

    [noticeTab release];
    noticeTab = nil;
    
    [popInfoView release];
    [bottomView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) confirmOrderNotice:(NSNotification *) notice
{
    popInfoView.hidden = YES;
    [popInfoView stopTimer];
    
    NSDictionary *confirmDic = [[notice.userInfo objectForKey:@"confirmDic"] copy];
    CLog(@"confirmDic:%@", confirmDic);
    
    NSUInteger index = 0;
    NSString *status = [confirmDic objectForKey:@"status"];
    if ([status isEqualToString:@"success"])
    {
        //显示分享过度
        NSString *keyId = [confirmDic objectForKey:@"keyId"];
        for (NSDictionary *item in inviteMsgArray)
        {
            NSString *itemKeyId = [item objectForKey:@"keyId"];
            if ([itemKeyId isEqualToString:keyId])
            {
                index = [inviteMsgArray indexOfObject:item];
                break;
            }
        }
        
        ThreadTimer *timer = [timerArray objectAtIndex:index];
        NSUInteger second = 50 - timer.totalSeconds;
        
        NSDictionary *inviteDic = [[inviteMsgArray objectAtIndex:index] copy];
        NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:confirmDic,@"confirmDic",inviteDic,@"inviteDic", nil];
        CLog(@"userDic:%@", userDic);
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        WaitMaskView *wmView = [[WaitMaskView alloc]initWithFrame:[UIScreen getCurrentBounds]];
        wmView.delegate = self;
        wmView.second = [NSString stringWithFormat:@"%lu", (unsigned long)second];
        wmView.userDic = userDic;
        [nav.view addSubview:wmView];
        [wmView release];
        [inviteDic release];
    }
    else
    {
        //显示失败PopView
        [popInfoView release];
        popInfoView = nil;
        
        popInfoView = [[MainViewPopInfoView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(40, self.view.frame.size.height/2-64-90, 240, 180) isBackView:NO] type:kFailedReponseType];
        [self.view addSubview:popInfoView];
        popInfoView.hidden = NO;
    }
    [confirmDic release];
    
    //删除数据源
    [self deleteIndexDataSource:index];
}

- (void) deleteIndexDataSource:(NSInteger) index
{
    //删除数据源
    [inviteMsgArray removeObjectAtIndex:index];
    
    ThreadTimer *timer = [timerArray objectAtIndex:index];
    [timer stopTimer];
    [timerArray removeObjectAtIndex:index];
    
    if (inviteMsgArray.count==0)
    {
        bottomView.hidden = NO;
        noticeTab.hidden  = YES;
    }
    [noticeTab reloadData];
}

- (void) inviteNotice:(NSNotification *) notice
{
    CLog(@"getNotice:%@", notice.userInfo);
    NSDictionary *inviteDic = [notice.userInfo objectForKey:@"InviteDic"];
    [self addInviteNotice:inviteDic];
}

- (void) addInviteNotice:(NSDictionary *)dic
{
    if (!inviteMsgArray)
        inviteMsgArray = [[NSMutableArray alloc]init];
    
    if (!timerArray)
        timerArray = [[NSMutableArray alloc]init];
    
    [inviteMsgArray insertObject:dic atIndex:0];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //语音播报
        [self speakUri:dic];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });

    if (!noticeTab)
    {
        noticeTab = [[UITableView alloc]init];
        noticeTab.delegate   = self;
        noticeTab.dataSource = self;
        noticeTab.hidden     = YES;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
        {
            if (iPhone5)
            {
                //ios7 iphone5
                CLog(@"It's is iphone5 IOS7");
                noticeTab.frame = [UIView fitCGRect:CGRectMake(0, 47, 320, 480-44)
                                         isBackView:YES];
            }
            else
            {
                CLog(@"It's is iphone4 IOS7");
                //ios 7 iphone 4
                noticeTab.frame = [UIView fitCGRect:CGRectMake(0, 53, 320, 480-44)
                                         isBackView:YES];
            }
        }
        else
        {
            if (!iPhone5)
            {
                // ios 6 iphone4
                CLog(@"It's is iphone4 IOS6");
                noticeTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480-44)
                                         isBackView:YES];
                
            }
            else
            {
                //ios 6 iphone5
                CLog(@"It's is iphone5 IOS6");
                noticeTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480-44)
                                         isBackView:YES];
            }
        }
        noticeTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:noticeTab];
    }
    noticeTab.hidden = NO;
    
    ThreadTimer *timer = [[ThreadTimer alloc]init];
    [timer setMinutesNum:60];
    [timerArray insertObject:timer atIndex:0];
    
    bottomView.hidden = YES;
    [noticeTab reloadData];
    
    CLog(@"dic:%@", dic);
    CLog(@"inviteMsgArray:%lu", (unsigned long)inviteMsgArray.count);
}

- (void) initBackBarItem
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = self;
}

- (void) doBackBtnClicked:(id)sender
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    NSArray *ctrsArr = nav.viewControllers;
    for (UIViewController *ctr in ctrsArr)
    {
        if ([ctr isKindOfClass:[MainViewController class]])
        {
            [nav popToViewController:ctr animated:YES];
            break;
        }
    }
}

#pragma mark -
#pragma mark - WaitMaskViewDelegate
- (void) shareClicked:(WaitMaskView *)view
{
    view.hidden = YES;
    
    //跳转到分享页面
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav popToRootViewControllerAnimated:NO];
    
    
    MyTeacherViewController *mVctr = [[MyTeacherViewController alloc]init];
    UINavigationController *navMvctr = [[UINavigationController alloc]initWithRootViewController:mVctr];
    
    LatlyViewController *lVctr = [[LatlyViewController alloc]init];
    UINavigationController *navLVctr = [[UINavigationController alloc]initWithRootViewController:lVctr];
    
    SearchTeacherViewController *sVctr = [[SearchTeacherViewController alloc]init];
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
    NSMutableArray *ctrlArr = [NSMutableArray arrayWithObjects:navMvctr,navLVctr,navSVctr,navShareVctr,navSetVctr,nil];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic3,imgDic2,
                       imgDic4,imgDic5,nil];
    
    PersonCenterViewController *pcVctr = [[PersonCenterViewController alloc]
                                          initWithViewControllers:ctrlArr
                                          imageArray:imgArr];
    
    nav.dataSource = pcVctr;
    [nav pushViewController:pcVctr
                   animated:YES];
    [pcVctr setSelectedIndex:3];
    [pcVctr release];
}

- (void) timeOutView:(WaitMaskView *)view
{
    view.hidden = YES;
    
    
    NSDictionary *confirmDic = [view.userDic objectForKey:@"confirmDic"];
    NSDictionary *inviteDic  = [view.userDic objectForKey:@"inviteDic"];
    
    Student *student = [Student setPropertyStudent:inviteDic];
    student.phoneNumber = [confirmDic objectForKey:@"phone"];
    
    //跳转到聊天界面
    ChatViewController *cVctr = [[ChatViewController alloc]init];
    cVctr.student = student;
    [self.navigationController pushViewController:cVctr
                                         animated:YES];
    [cVctr release];
}

#pragma mark -
#pragma mark - MainViewPopInfoViewWaitDelegate
- (void) mainViewPopInfoWaitViewTimeOut:(MainViewPopInfoView *)view
{
    [popInfoView release];
    popInfoView = nil;
    
    popInfoView = [[MainViewPopInfoView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(40, self.view.frame.size.height/2-64-90, 240, 180) isBackView:NO] type:kNoResponseType];
    [self.view addSubview:popInfoView];
    popInfoView.hidden = NO;
}

#pragma mark -
#pragma mark - InviteNoticeCellDelegate
- (void) clickView:(InviteNoticeCell *)cell
{
    NSDictionary *inviteDic = [inviteMsgArray objectAtIndex:cell.noticeIndex];
    CLog(@"inviteDicsdfsdf:%@", inviteDic);
    
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
    Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    //发送抢单消息
    NSArray *paramsArr  = [NSArray arrayWithObjects:@"type",@"phone",@"nickname",@"icon",
                           @"gender",@"subjectText",@"stars",
                           @"info",@"idnumber",@"students",
                           @"pushcc",@"deviceId",@"keyId",nil];
    NSArray *valuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_APPLY],teacher.phoneNums,teacher.name,teacher.headUrl,[NSNumber numberWithInt:teacher.sex],teacher.pf,[NSNumber numberWithInt:teacher.comment],teacher.info,teacher.idNums,[NSNumber numberWithInt:teacher.studentCount],@"0",[SingleMQTT getCurrentDevTopic],[inviteDic objectForKey:@"keyId"],nil];
    CLog(@"valuesArra:%@", valuesArr);
    NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                      forKeys:paramsArr];
    NSLog(@"sdfjsidfjsidfjDic:%@", pDic);
    NSString *jsonMsg   = [pDic JSONFragment];
    NSData *data        = [jsonMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    //发送消息
    NSString *deviceId  = [inviteDic objectForKey:@"deviceId"];
    CLog(@"deviceIdsdfs:%@", deviceId);
    SingleMQTT *session = [SingleMQTT shareInstance];
    [session.session publishData:data
                         onTopic:deviceId];
    
    //显示等待图层.
    [popInfoView release];
    popInfoView = nil;
    
    popInfoView = [[MainViewPopInfoView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(40, self.view.frame.size.height/2-64-90, 240, 180) isBackView:NO] type:kWaitPopInfoType];
    popInfoView.delegate = self;
    [self.view addSubview:popInfoView];
    popInfoView.hidden = NO;
}

- (void) timeOut:(InviteNoticeCell *)cell
{
    //删除数据源
    [self deleteIndexDataSource:cell.noticeIndex];
}

#pragma mark - 
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return inviteMsgArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    InviteNoticeCell *cell  = [[[InviteNoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idString]autorelease];
    cell.delegate = self;
    NSDictionary *inviteDic = [inviteMsgArray objectAtIndex:indexPath.row];
    [cell setNoticeDic:inviteDic index:indexPath.row];
    [cell setTimer:[timerArray objectAtIndex:indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

- (void) initUI
{
    _calloutMapAnnotation = [[CalloutMapAnnotation alloc]init];

    //显示地图
    NSDictionary *tpDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"TERMINAL_PROPERTY"];
    int updateMeters = 10;
    float zooms = 13;
    if (tpDic)
    {
        zooms = ((NSNumber *)[tpDic objectForKey:@"mapzoom"]).floatValue;
        updateMeters = ((NSNumber *)[tpDic objectForKey:@"uplocationNumber"]).intValue;
    }
    
    mapView = [[MAMapView alloc] initWithFrame:[UIView fitCGRect:CGRectMake(0, 0,
                                                                                 320, 480)
                                                      isBackView:YES]];
    mapView.showsScale = NO;
    mapView.delegate   = self;
    mapView.distanceFilter  = updateMeters;//10米位置更新到服务器
    mapView.headingFilter   = 180;
    mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [mapView setZoomLevel:zooms];
    mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    //检测Timer是否已经超时
    [self checkTimersIsTimeOut];
    
    noticeTab = [[UITableView alloc]init];
    noticeTab.delegate   = self;
    noticeTab.dataSource = self;
    if (inviteMsgArray.count==0)
    {
        noticeTab.hidden = YES;
    }
    else
    {
        noticeTab.hidden = NO;
    }
    noticeTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:noticeTab];
    
    UIImage *bgImg = [UIImage imageNamed:@"mtp_info_bg"];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            bottomView = [[MainViewBottomInfoView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(160-bgImg.size.width/2,
                                                                                                   480-15-bgImg.size.height,
                                                                                                   bgImg.size.width,
                                                                                                   bgImg.size.height)
                                                                             isBackView:NO]];
            noticeTab.frame = [UIView fitCGRect:CGRectMake(0, 47, 320, 480-44)
                                     isBackView:YES];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            bottomView = [[MainViewBottomInfoView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(160-bgImg.size.width/2,
                                                                                                   480-33-bgImg.size.height,
                                                                                                   bgImg.size.width,
                                                                                                   bgImg.size.height)
                                                                             isBackView:NO]];
            noticeTab.frame = [UIView fitCGRect:CGRectMake(0, 53, 320, 480-44)
                                     isBackView:YES];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            bottomView = [[MainViewBottomInfoView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(160-bgImg.size.width/2,
                                                                                                   480-44-14-bgImg.size.height,
                                                                                                   bgImg.size.width,
                                                                                                   bgImg.size.height)
                                                                             isBackView:NO]];
            noticeTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480-44)
                                     isBackView:YES];
            
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            bottomView = [[MainViewBottomInfoView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(160-bgImg.size.width/2,
                                                                                                   480-30-bgImg.size.height,
                                                                                                   bgImg.size.width,
                                                                                                   bgImg.size.height)
                                                                             isBackView:NO]];
            noticeTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480-44)
                                     isBackView:YES];
        }
    }
    
    [self.view addSubview:bottomView];
    
    popInfoView = nil;
}

- (void) checkTimersIsTimeOut
{
    NSArray *tmpArray = [timerArray copy];
    for (ThreadTimer *timer in tmpArray)
    {
        if ([timer isTimeOut])
        {
            CLog(@"TimerOut shdfshfusdhfus");
            NSUInteger index = [timerArray indexOfObject:timer];
            
            //删除数据源
            [self deleteIndexDataSource:index];
        }
    }
    [tmpArray release];
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
            NSDictionary *ccResDic = [resDic copy];
            [[NSUserDefaults standardUserDefaults] setObject:ccResDic forKey:@"AssistentData"];
            [ccResDic release];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AssistentData"];
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

- (void) speakUri:(NSDictionary *) inviteDic
{
    NSString *msgCnt = nil;
    NSString *totalMoney = [inviteDic objectForKey:@"tamount"];
    if (totalMoney.intValue==0)
    {
        msgCnt   = [NSString stringWithFormat:@"订单金额师生协商;共%@课时;上课地址%@;", [inviteDic objectForKey:@"yjfdnum"], [inviteDic objectForKey:@"iaddress"]];
    }
    else
    {
        msgCnt   = [NSString stringWithFormat:@"订单金额%@;共%@课时;上课地址%@;", [inviteDic objectForKey:@"tamount"], [inviteDic objectForKey:@"yjfdnum"], [inviteDic objectForKey:@"iaddress"]];
    }
    
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"text",@"mp3",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"speakUri",msgCnt,@"1", ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd, TEACHER];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    NSData *resVal     = [serverReq requestSyncWith:kServerPostRequest
                                           paramDic:pDic
                                             urlStr:url];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic  = [resStr JSONValue];
    if (resDic)
    {
        NSString *errorid = [resDic objectForKey:@"errorid"];
        if (errorid.intValue==0)
        {
            //下载语音播报
            if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
            {
                return;
            }
            
            NSString *downPath  = [[ChatViewController getRecordURL] retain];
            
            NSString *webAdd    = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
            NSString *soundPath = [NSString stringWithFormat:@"%@%@", webAdd, [resDic objectForKey:@"uri"]];
            
            //下载音频文件
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:soundPath]];
            [request setDelegate:self];
            [request setDownloadProgressDelegate:self];
            [request setDownloadDestinationPath:downPath];
            [request startAsynchronous];
            
        }
        else
        {
            CLog(@"speakUri failed!");
        }
    }
    else
    {
        CLog(@"speark failed!")
    }
}

- (void) setTerminalMapProperty
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSDictionary *tpDic= [[NSUserDefaults standardUserDefaults] objectForKey:@"TERMINAL_PROPERTY"];
    if (!tpDic)
    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"getMapZoom", nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        
        NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd, TEACHER];
        ServerRequest *serverReq = [ServerRequest sharedServerRequest];
        NSData *resVal     = [serverReq requestSyncWith:kServerPostRequest
                                               paramDic:pDic
                                                 urlStr:url];
        NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                 encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *resDic  = [resStr JSONValue];
        if (resDic)
        {
            CLog(@"Map ResDic:%@", resDic);
            
            //保存终端设置
            [[NSUserDefaults standardUserDefaults] setObject:resDic
                                                      forKey:@"TERMINAL_PROPERTY"];
            
            //显示默认中心
            NSString *lg = [tpDic objectForKey:@"longitude"];
            NSString *la = [tpDic objectForKey:@"latitude"];
            self.mapView.centerCoordinate = CLLocationCoordinate2DMake(la.floatValue,
                                                                       lg.floatValue);
            //更新个人位置服务器
            [self searchReGeocode:self.mapView.centerCoordinate];
            meAnn.coordinate = self.mapView.centerCoordinate;
            
            //搜索附近老师
            [self searchNearStudent];
        }
        else
        {
            CLog(@"setTerminalProperty failed!");
        }
    }
    else
    {
        CLog(@"setTerminalProperty Haved Success!");
    }
}

+ (void) setNavTitle:(NSString *) title
{
    BOOL isSet = NO;
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    NSArray *subArray = [nav.navigationBar subviews];
    for (UIView *view in subArray)
    {
        if (view.tag == 1010)   //Title View
        {
            UILabel *titleLab = (UILabel *)view;
            titleLab.text     = title;
            isSet = YES;
        }
    }
    if (!isSet)
    {
        UILabel *titleLab     = [[UILabel alloc] initWithFrame:CGRectMake(160-100, nav.navigationBar.frame.size.height/2-15, 200, 30)];
        titleLab.tag             = 1010;
        titleLab.font            = [UIFont systemFontOfSize:18.f];
        titleLab.textColor       = [UIColor colorWithHexString:@"#009f66"];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textAlignment = UITextAlignmentCenter;
        titleLab.text = title;
        [nav.navigationBar addSubview:titleLab];
        [titleLab release];
    }
}

+ (CustomNavigationViewController *) getNavigationViewController
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return (CustomNavigationViewController *)app.window.rootViewController;
}

+ (void) getWebServerAddress
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
//    NSString *webAdd  = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
//    NSString *pushAdd = [[NSUserDefaults standardUserDefaults] objectForKey:PUSHADDRESS];
//    if (!webAdd||!pushAdd)
//    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"lb", nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        
        ServerRequest *serverReq = [ServerRequest sharedServerRequest];
        NSData *resVal     = [serverReq requestSyncWith:kServerPostRequest
                                               paramDic:pDic
                                                 urlStr:ServerAddress];
        if (resVal)
        {
            NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                     encoding:NSUTF8StringEncoding]autorelease];
            NSDictionary *resDic  = [resStr JSONValue];
            if (resDic)
            {
                NSString *webAddress  = [resDic objectForKey:@"web"];
                NSString *pushAddress = [MainViewController getPushAddress:[resDic objectForKey:@"push"]];
                NSString *port = [MainViewController getPort:[resDic objectForKey:@"push"]];
                NSString *pushMaxTime = [resDic objectForKey:@"pushMaxTime"];
                NSString *pushPageTime= [resDic objectForKey:@"pushPageTime"];
                
                [[NSUserDefaults standardUserDefaults] setObject:webAddress
                                                          forKey:WEBADDRESS];
                [[NSUserDefaults standardUserDefaults] setObject:pushAddress
                                                          forKey:PUSHADDRESS];
                [[NSUserDefaults standardUserDefaults] setObject:port
                                                          forKey:PORT];
                [[NSUserDefaults standardUserDefaults] setObject:pushMaxTime
                                                          forKey:PUSHMAXTIME];
                [[NSUserDefaults standardUserDefaults] setObject:pushPageTime
                                                          forKey:PUSHPAGETIME];
            }
        }
        else
        {
            CLog(@"getWebAddress failed!");
        }
//    }
}

+ (NSString *) getPushAddress:(NSString *) str
{
    NSRange start = [str rangeOfRegex:@"//"];
//    CLog(@"start:%d %d", start.location, start.length);
    NSString *subStr = [str substringFromIndex:start.location];
    NSRange end = [subStr rangeOfRegex:@":"];
    
    NSString *pushAddress = [str substringWithRange:NSMakeRange(start.location+2, end.location-2)];
//    CLog(@"pushAddress:%@", pushAddress);
    
    return pushAddress;
}

+ (NSString *) getPort:(NSString *) str
{
    NSRange start = [str rangeOfRegex:@"//"];
    //    CLog(@"start:%d %d", start.location, start.length);
    NSString *subStr = [str substringFromIndex:start.location];
    NSRange end = [subStr rangeOfRegex:@":"];
    NSString *port = [subStr substringFromIndex:end.location+1];
    
    return port;
}

- (void) uploadPosToServer:(NSString *) posName
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    CLLocationCoordinate2D  loc = self.mapView.userLocation.coordinate;
    NSString *log = [NSString stringWithFormat:@"%f", loc.longitude];
    NSString *la  = [NSString stringWithFormat:@"%f", loc.latitude];
    
    //地理编码获得地址
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if (ssid)
    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"longitude",@"latitude",
                              @"acode",@"address",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"uplocation",log,la,
                              @"0755",posName,ssid, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url = [NSString stringWithFormat:@"%@%@", webAdd, TEACHER];
        ServerRequest *request = [ServerRequest sharedServerRequest];
        request.delegate = self;
        [request requestASyncWith:kServerPostRequest
                         paramDic:pDic
                           urlStr:url];
    }
}

- (void)searchReGeocode:(CLLocationCoordinate2D) loc
{
    AMapReGeocodeSearchRequest *regeoRequest = [[[AMapReGeocodeSearchRequest alloc] init]autorelease];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:loc.latitude
                                                     longitude:loc.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    [search AMapReGoecodeSearch:regeoRequest];
}

- (void) searchNearStudent
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    CLLocationCoordinate2D  loc = self.mapView.centerCoordinate;
    NSString *log  = [NSString stringWithFormat:@"%f", loc.longitude];
    NSString *la   = [NSString stringWithFormat:@"%f", loc.latitude];
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if (!ssid)
        ssid = @"";
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"latitude",@"longitude", @"zoom",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"findNearbyStudent",la,log,
                                                   [NSNumber numberWithFloat:self.mapView.zoomLevel],ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@", webAddress,TEACHER];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ServerRequest *request = [ServerRequest sharedServerRequest];
        request.delegate = self;
        [request requestASyncWith:kServerPostRequest
                         paramDic:pDic
                           urlStr:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });  

    //删除个人标注
    [self.mapView removeAnnotation:self.mapView.userLocation];
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (void) initMapKey
{
    [MAMapServices sharedServices].apiKey = (NSString *)MAP_API_KEY;
    search = [[AMapSearchAPI alloc]initWithSearchKey:(NSString *)MAP_API_KEY
                                            Delegate:self];
}

- (void) initTeachersAnnotation
{
    NSMutableArray *annArrs = [[NSMutableArray alloc]init];
    for (Student *student in studentArray)
    {
        CustomPointAnnotation *ann = [[[CustomPointAnnotation alloc] init]autorelease];
        ann.coordinate = CLLocationCoordinate2DMake(student.latitude.floatValue, student.longitude.floatValue);
        ann.student = student;
        [annArrs addObject:ann];
    }
    [self.mapView addAnnotations:annArrs];
    
    [annArrs release];
    [studentArray removeAllObjects];
}

#pragma mark -
#pragma mark ServerRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //播放声音
    NSString *soundPath = [[ChatViewController getRecordURL] retain];
    NSData *soundData   = [NSData dataWithContentsOfFile:soundPath];
    
    RecordAudio *audio = [[RecordAudio alloc]init];
    [audio playMP3:soundData];
}

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
    NSData   *resVal = [[request responseData] retain];
    NSString *resStr = [[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding];
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
        if ([action isEqualToString:@"findNearbyStudent"])
        {
            NSArray *items = [resDic objectForKey:@"students"];
            for (NSDictionary *item in items)
            {
                //设置老师属性
                Student *student = [Student setPropertyStudent:item];
                [studentArray addObject:student];
            }
            
            //添加老师地图标注
            [self initTeachersAnnotation];
            
            //删除我的位置标注
            if (self.mapView.overlays.count>0)
            {
                [self.mapView removeAnnotation:self.mapView.userLocation];
                [self.mapView removeOverlay:self.mapView.overlays[0]];
            }
        }
        else if ([action isEqualToString:@"uplocation"])
        {
            CLog(@"Upload Location Success!");
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

#pragma mark -
#pragma mark - AMapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request
                     response:(AMapReGeocodeSearchResponse *)response;
{
    NSString *posName = response.regeocode.formattedAddress;
    [self uploadPosToServer:posName];
}

#pragma mark -
#pragma mark - MAMapViewDelegate
- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    //添加个人位置标注,选择地点标注
    if (!meAnn)
    {
        meAnn = [[[CustomPointAnnotation alloc] init]autorelease];
        meAnn.coordinate = userLocation.coordinate;
        meAnn.tag = 1000;
        [self.mapView addAnnotation:meAnn];
    }
    
    if (updatingLocation)
    {
        if (!isLocation)
        {
            isLocation = YES;
            [self.mapView setCenterCoordinate:userLocation.coordinate];
        }
        
        meAnn.coordinate = userLocation.location.coordinate;
        
        //保存个人位置
        NSString *log = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
        NSString *la  = [NSString stringWithFormat:@"%f", userLocation.coordinate.latitude];
        [[NSUserDefaults standardUserDefaults] setObject:log
                                                  forKey:LONGITUDE];
        [[NSUserDefaults standardUserDefaults] setObject:la
                                                  forKey:LATITUDE];

        CLog(@"New Loc:%@,%@", log, la);
        
        //更新个人位置服务器
        [self searchReGeocode:userLocation.coordinate];
    
        //搜索附近老师
        [self searchNearStudent];
    }
}

- (void) mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    CLog(@"Locate User Failed");
    
    //显示默认中心
    NSDictionary *tpDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"TERMINAL_PROPERTY"];
    if (tpDic)
    {
        NSString *lg = [tpDic objectForKey:@"longitude"];
        NSString *la = [tpDic objectForKey:@"latitude"];
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(la.floatValue,
                                                                   lg.floatValue);
    }
    
    //更新个人位置服务器
    [self searchReGeocode:self.mapView.centerCoordinate];
    meAnn.coordinate = self.mapView.centerCoordinate;
    
    //搜索附近老师
    [self searchNearStudent];
}

- (void) mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocation *newPoint = [[CLLocation alloc]initWithLatitude:self.mapView.centerCoordinate.latitude
                                                     longitude:self.mapView.centerCoordinate.longitude];
    
    double offsetKilometers = [newPoint distanceFromLocation:originPoint];
    
    CLog(@"距离:%f", offsetKilometers);
    
    //获得市、区、街道的缩放级别
    NSDictionary *tpDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"TERMINAL_PROPERTY"];
    if (tpDic)
    {
        float cityZooms   = ((NSNumber *)[tpDic objectForKey:@"cityZoom"]).floatValue;
        float distZooms   = ((NSNumber *)[tpDic objectForKey:@"districtZoom"]).floatValue;
        float streatZooms = ((NSNumber *)[tpDic objectForKey:@"streetZoom"]).floatValue;
        
        float cityFilter  = ((NSNumber *)[tpDic objectForKey:@"mapCityDistance"]).floatValue;
        float distFilter  = ((NSNumber *)[tpDic objectForKey:@"mapDistrictDistance"]).floatValue;
        float streatFilter= ((NSNumber *)[tpDic objectForKey:@"mapStreetDistance"]).floatValue;
        
        CLog(@"city:%f dist:%f streat:%f cur:%f", cityZooms, distZooms, streatZooms, self.mapView.zoomLevel);
        CLog(@"city:%f dist:%f streat:%f", cityFilter, distFilter, streatFilter);
        
        //重新设置地图的缩放级别
        if ((self.mapView.zoomLevel>=cityZooms) && (self.mapView.zoomLevel<=distZooms) && cityFilter<offsetKilometers)
        {
            [self searchNearStudent];
        }
        else if ((self.mapView.zoomLevel>distZooms)&&(self.mapView.zoomLevel<=streatZooms) && (distFilter<offsetKilometers))
        {
            [self searchNearStudent];
        }
        else if ((self.mapView.zoomLevel>streatZooms) && (streatFilter<offsetKilometers))
        {
            [self searchNearStudent];
        }
    }
    originPoint = [[CLLocation alloc]initWithLatitude:self.mapView.centerCoordinate.latitude
                                            longitude:self.mapView.centerCoordinate.longitude];
    [self.mapView removeAnnotation:self.mapView.userLocation];
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"meView";
        CustomPointAnnotation *cpAnn = (CustomPointAnnotation *) annotation;
        if (meAnn == cpAnn)
        {
            MAAnnotationView *annView = (MAAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annView == nil)
            {
                annView = [[[MAAnnotationView alloc] initWithAnnotation:annotation
                                                       reuseIdentifier:pointReuseIndetifier]autorelease];
            }
            annView.image = [UIImage imageNamed:@"my_location_icon"];
            return annView;
        }
        else
        {
            static NSString *pointReuseIndetifier = @"teacherView";
            TTCustomAnnotationView *annView = (TTCustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annView == nil)
            {
                annView = [[TTCustomAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:pointReuseIndetifier];
            }

            return annView;
        }
    }
    else if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        //此时annotation就是我们calloutview的annotation
        CalloutMapAnnotation *ann = (CalloutMapAnnotation*)annotation;
        
        //如果可以重用
        CallOutAnnotationView *outAnnView = (CallOutAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
        
        //否则创建新的calloutView
        if (!outAnnView) {
            outAnnView = [[[CallOutAnnotationView alloc] initWithAnnotation:annotation
                                                            reuseIdentifier:@"calloutview"] autorelease];
            Student *student = [ann.student copy];
            TeacherPropertyView *tpView = [[[TeacherPropertyView alloc]initWithFrame:CGRectMake(0,
                                                                                                0,
                                                                                               outAnnView.contentView.frame.size.width,
                                                                                               outAnnView.contentView.frame.size.height)]autorelease];
            tpView.student  = student;
            tpView.delegate = self;
            [outAnnView.contentView addSubview:tpView];
            [student release];
        }
        
        return outAnnView;  
    }
    return nil;
}

- (void) mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    CustomPointAnnotation *annn = (CustomPointAnnotation*)view.annotation;
    if (annn == meAnn)     //我的位置
        return;
    
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]]) {
        //如果点到了这个marker点，什么也不做
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        
        //如果当前显示着calloutview，又触发了select方法，删除这个calloutview annotation
        if (_calloutMapAnnotation) {
            [self.mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation=nil;
            
        }
        
        //创建搭载自定义calloutview的annotation
        CLog(@"Old:%f,%f", view.annotation.coordinate.latitude,view.annotation.coordinate.longitude)
        _calloutMapAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude];
        _calloutMapAnnotation.student = annn.student;
        
        [self.mapView addAnnotation:_calloutMapAnnotation];
        [self.mapView setCenterCoordinate:view.annotation.coordinate
                                 animated:YES];
    }
}

- (void) mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if (_calloutMapAnnotation &&![view isKindOfClass:[CallOutAnnotationView class]]) {
        CLog(@"%f,%f  %f,%f", _calloutMapAnnotation.latitude,_calloutMapAnnotation.longitude, view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
        if (_calloutMapAnnotation.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.longitude == view.annotation.coordinate.longitude) {
            [self.mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation = nil;
        }
    }
}
@end
