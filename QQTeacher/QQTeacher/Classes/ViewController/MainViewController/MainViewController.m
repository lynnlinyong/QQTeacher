//
//  MainViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "MainViewController.h"

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

static NSMutableArray *inviteMsgArray = nil;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inviteNotice:)
                                                 name:@"InviteNotice"
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
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
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
    
    [inviteMsgArray addObject:dic];
    
    if (!noticeTab)
    {
        noticeTab = [[UITableView alloc]init];
        noticeTab.delegate   = self;
        noticeTab.dataSource = self;
        noticeTab.hidden     = YES;
        noticeTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480)
                                 isBackView:YES];
        noticeTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:noticeTab];
    }
    noticeTab.hidden = NO;
    [noticeTab reloadData];
    
    CLog(@"dic:%@", dic);
    CLog(@"inviteMsgArray:%d", inviteMsgArray.count);
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
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idString] autorelease];
    
    NSDictionary *inviteDic = [inviteMsgArray objectAtIndex:indexPath.row];
    
    
    UILabel *infoLab = [[UILabel alloc]init];
    NSString *totalMoney = [inviteDic objectForKey:@"tamount"];
    if (totalMoney.intValue==0)
    {
        infoLab.text = [NSString stringWithFormat:@"%@ %@ %@  金额师生协商", [inviteDic objectForKey:@"nickname"],
                                                                     [inviteDic objectForKey:@"grade"],
                                                                     [Student searchGenderName:[inviteDic objectForKey:@"gender"]]];
    }
    else
    {
        infoLab.text = [NSString stringWithFormat:@"%@ %@ %@  ￥%@", [inviteDic objectForKey:@"nickname"], [inviteDic objectForKey:@"grade"], [Student searchGenderName:[inviteDic objectForKey:@"gender"]], [inviteDic objectForKey:@"tamount"]];
    }
    infoLab.font = [UIFont systemFontOfSize:14.f];
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.frame = CGRectMake(5, 5, 270, 20);
    [cell addSubview:infoLab];
    [infoLab release];
    
    
    UILabel *timesLab = [[UILabel alloc]init];
    timesLab.text = [NSString stringWithFormat:@"预计辅导小时数:%@", [inviteDic objectForKey:@"yjfdnum"]];
    timesLab.backgroundColor = [UIColor clearColor];
    timesLab.frame = CGRectMake(5, 25, 270, 20);
    timesLab.font  = [UIFont systemFontOfSize:14.f];
    [cell addSubview:timesLab];
    [timesLab release];
    
    UILabel *startDateLab = [[UILabel alloc]init];
    startDateLab.text = [NSString stringWithFormat:@"开课日期:%@", [inviteDic objectForKey:@"sd"]];
    startDateLab.backgroundColor = [UIColor clearColor];
    startDateLab.frame = CGRectMake(5, 45, 270, 20);
    startDateLab.font  = [UIFont systemFontOfSize:14.f];
    [cell addSubview:startDateLab];
    [startDateLab release];
    
    UILabel *posLab = [[UILabel alloc]init];
    posLab.text = [NSString stringWithFormat:@"授课地址:%@", [inviteDic objectForKey:@"iaddress"]];
    posLab.backgroundColor = [UIColor clearColor];
    posLab.frame = CGRectMake(5, 65, 270, 20);
    posLab.font  = [UIFont systemFontOfSize:14.f];
    [cell addSubview:posLab];
    [posLab release];
    
    //计算距离
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
    Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    NSString *distLatitude = [inviteDic objectForKey:@"latitude"];
    NSString *distLongtitude = [inviteDic objectForKey:@"longitude"];
    
    CLLocation* orig=[[[CLLocation alloc] initWithLatitude:[teacher.latitude doubleValue]  longitude:[teacher.longitude doubleValue]] autorelease];
    CLLocation* dist=[[[CLLocation alloc] initWithLatitude:[distLatitude doubleValue] longitude:[distLongtitude doubleValue] ] autorelease];
    
    CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
    
    UILabel *distanceLab = [[UILabel alloc]init];
    distanceLab.text = [NSString stringWithFormat:@"距离:%0.2fkm", kilometers];
    distanceLab.backgroundColor = [UIColor clearColor];
    distanceLab.frame = CGRectMake(5, 85, 270, 20);
    distanceLab.font  = [UIFont systemFontOfSize:14.f];
    [cell addSubview:distanceLab];
    [distanceLab release];
    
    UILabel *secondeLab = [[UILabel alloc]init];
    secondeLab.text = [NSString stringWithFormat:@"还剩50秒"];
    secondeLab.backgroundColor = [UIColor clearColor];
    secondeLab.frame = CGRectMake(320-70, 85, 60, 20);
    secondeLab.font  = [UIFont systemFontOfSize:14.f];
    [cell addSubview:secondeLab];
    [secondeLab release];
    
    [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lt_list_bg"]]];
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
    
    noticeTab = [[UITableView alloc]init];
    noticeTab.delegate   = self;
    noticeTab.dataSource = self;
    noticeTab.hidden     = YES;
    noticeTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480)
                             isBackView:YES];
    noticeTab.separatorStyle = UITableViewCellSeparatorStyleNone;
//    noticeTab.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    [self.view addSubview:noticeTab];
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
    
    NSString *webAdd  = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *pushAdd = [[NSUserDefaults standardUserDefaults] objectForKey:PUSHADDRESS];
    if (!webAdd||!pushAdd)
    {
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
    }
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
