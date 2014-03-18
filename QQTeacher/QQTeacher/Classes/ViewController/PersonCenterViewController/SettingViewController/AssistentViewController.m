//
//  AssistentViewController.m
//  QQTeacher
//
//  Created by Lynn on 14-3-17.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import "AssistentViewController.h"

@interface AssistentViewController ()

@end

@implementation BottomView
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithHexString:@"#80c3b3"];
        
        UIImage *titleImg = [UIImage imageNamed:@"stp_cc_info_title"];
        titleImgView = [[UIImageView alloc]init];
        titleImgView.image = titleImg;
        titleImgView.frame = CGRectMake(0, 0, titleImg.size.width, titleImg.size.height);
        [self addSubview:titleImgView];
        
        UIImage *lightImg  = [UIImage imageNamed:@"stp_cc_info_light"];
        lightImgView = [[UIImageView alloc]init];
        lightImgView.image = lightImg;
        lightImgView.frame = CGRectMake(10, 10, lightImg.size.width, lightImg.size.height);
        [self addSubview:lightImgView];
        
        firstLab = [[UILabel alloc]init];
        firstLab.backgroundColor = [UIColor clearColor];
        firstLab.text = @"轻轻助教是您接单、抢单的好管家,实时在线不遗漏每一位学生.";
        firstLab.numberOfLines = 0;
        firstLab.lineBreakMode = NSLineBreakByWordWrapping;
        firstLab.textColor = [UIColor whiteColor];
        firstLab.frame = CGRectMake(10+lightImgView.frame.size.width+10, 5, 280, 30);
        firstLab.font  = [UIFont systemFontOfSize:14.f];
        [self addSubview:firstLab];
        
        secondLab = [[UILabel alloc]init];
        secondLab.backgroundColor = [UIColor clearColor];
        secondLab.text = @"替忙碌的您抢到发单学生,透明公开的聊天内容，让您一目了然.";
        secondLab.numberOfLines = 0;
        secondLab.lineBreakMode = NSLineBreakByWordWrapping;
        secondLab.textColor = [UIColor whiteColor];
        secondLab.frame = CGRectMake(10+lightImgView.frame.size.width+10, 35, 280, 30);
        secondLab.font  = [UIFont systemFontOfSize:14.f];
        [self addSubview:secondLab];
        
        thirdLab = [[UILabel alloc]init];
        thirdLab.backgroundColor = [UIColor clearColor];
        thirdLab.text = @"助教服务免费体验中,现在就去试试吧~~";
        thirdLab.numberOfLines = 0;
        thirdLab.lineBreakMode = NSLineBreakByWordWrapping;
        thirdLab.textColor = [UIColor whiteColor];
        thirdLab.frame = CGRectMake(10+lightImgView.frame.size.width+10, 65, 280, 30);
        thirdLab.font  = [UIFont systemFontOfSize:14.f];
        [self addSubview:thirdLab];
        
        UITapGestureRecognizer *tapReg = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(doTapGestureReg:)];
        [self addGestureRecognizer:tapReg];
        [tapReg release];
    }
    
    return self;
}

- (void) dealloc
{
    [firstLab release];
    [secondLab release];
    [thirdLab release];
    [lightImgView release];
    [titleImgView release];
    [super dealloc];
}

- (void) doTapGestureReg:(UIGestureRecognizer *) reg
{
    self.hidden = YES;
}
@end

@implementation AssistentViewController

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
    
    //获得助理信息
    [self getAssistentsMessage];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MainViewController setNavTitle:@"我的助教"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(assistentNotice:)
                                                 name:@"assistentNotice"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void) viewDidUnload
{
    latlyTab.delegate   = nil;
    latlyTab.dataSource = nil;
    
    latlyTab = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [ccDic       release];
    [applyArray  release];

    [latlyTab    release];
    [bgImgView   release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Notice
- (void) assistentNotice:(NSNotification *) notice
{
    NSDictionary *applyDic = [notice.userInfo objectForKey:@"ApplyDic"];
    CLog(@"applyDic:%@", applyDic);
    
    NSNumber *tagNum = [notice.userInfo objectForKey:@"TAG"];
    switch (tagNum.intValue)
    {
        case 0:     //接受
        {
            if (ccDic.count!=0)
            {
                //提示先解约当前老师
                NSString *infoStr = [NSString stringWithFormat:@"您已经签约教学助理，请先与助理[%@]解约再申请", [ccDic objectForKey:@"cc_name"]];
                [self showAlertWithTitle:@"提示"
                                     tag:0
                                 message:infoStr
                                delegate:self
                       otherButtonTitles:@"确定",nil];
            }
            else
            {
                //删除Cell
                CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
                [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
                
                NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
                NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"id",@"sessid", nil];
                NSArray *valuesArr = [NSArray arrayWithObjects:@"jsApply",[applyDic objectForKey:@"id"],ssid, nil];
                NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                                 forKeys:paramsArr];
                NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
                NSString *url  = [NSString stringWithFormat:@"%@%@", webAddress,TEACHER];
                ServerRequest *serverReq = [ServerRequest sharedServerRequest];
                serverReq.delegate = self;
                NSData *resVal   = [serverReq requestSyncWith:kServerPostRequest
                                                     paramDic:pDic
                                                       urlStr:url];
                NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                         encoding:NSUTF8StringEncoding]autorelease];
                NSDictionary *resDic = [resStr JSONFragmentValue];
                if (resDic)
                {
                    NSString *errorid = [resDic objectForKey:@"errorid"];
                    if (errorid.intValue==0)
                    {
                        CLog(@"jsApply Success!");
                        
                        
                        NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
                        Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
                        
                        //发送接受签约消息
                        NSString *message   = [NSString stringWithFormat:@"老师[%@]通过了您的教学助理签约申请.", teacher.name];
                        NSArray *paramsArr  = [NSArray arrayWithObjects:@"type",@"title",@"url",@"text",nil];
                        NSArray *valuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_PUSHCC],@"教学助理签约申请",@"",message,nil];
                        NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                                          forKeys:paramsArr];
                        NSString *jsonMsg   = [pDic JSONFragment];
                        NSData *data        = [jsonMsg dataUsingEncoding:NSUTF8StringEncoding];
                        
                        //发送消息
                        NSString *deviceId  = [applyDic objectForKey:@"deviceId"];
                        CLog(@"deviceIdsdfs:%@", deviceId);
                        SingleMQTT *session = [SingleMQTT shareInstance];
                        [session.session publishData:data
                                             onTopic:deviceId];
                        
                        //刷新界面
                        [self getAssistentsMessage];
                    }
                    else
                        CLog(@"jsApply Failed!");
                }
                else
                    CLog(@"jsApply Failed!");
                
                [MBProgressHUD hideHUDForView:nav.view animated:YES];
            }
            break;
        }
        case 1:     //拒绝
        {
            //删除Cell
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
            
            NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
            NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"id",@"sessid", nil];
            NSArray *valuesArr = [NSArray arrayWithObjects:@"deleteApply",[applyDic objectForKey:@"id"],ssid, nil];
            NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                             forKeys:paramsArr];
            NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
            NSString *url  = [NSString stringWithFormat:@"%@%@", webAddress,TEACHER];
            ServerRequest *serverReq = [ServerRequest sharedServerRequest];
            serverReq.delegate = self;
            NSData *resVal   = [serverReq requestSyncWith:kServerPostRequest
                                                 paramDic:pDic
                                                   urlStr:url];
            NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                     encoding:NSUTF8StringEncoding]autorelease];
            NSDictionary *resDic = [resStr JSONFragmentValue];
            if (resDic)
            {
                NSString *errorid = [resDic objectForKey:@"errorid"];
                if (errorid.intValue==0)
                {
                    CLog(@"deleteApply Success!");
                    
                    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
                    Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
                    
                    //发送接受签约消息
                    NSString *message   = [NSString stringWithFormat:@"老师[%@]拒绝了您的教学助理签约申请.", teacher.name];
                    NSArray *paramsArr  = [NSArray arrayWithObjects:@"type",@"title",@"url",@"text",nil];
                    NSArray *valuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_PUSHCC],@"教学助理签约申请",@"",message,nil];
                    NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                                      forKeys:paramsArr];
                    NSString *jsonMsg   = [pDic JSONFragment];
                    NSData *data        = [jsonMsg dataUsingEncoding:NSUTF8StringEncoding];
                    
                    //发送消息
                    NSString *deviceId  = [applyDic objectForKey:@"deviceId"];
                    CLog(@"deviceIdsdfs:%@", deviceId);
                    SingleMQTT *session = [SingleMQTT shareInstance];
                    [session.session publishData:data
                                         onTopic:deviceId];
                    
                    //刷新界面
                    [self getAssistentsMessage];
                }
                else
                    CLog(@"deleteApply Failed!");
            }
            else
                CLog(@"deleteApply Failed!");
            
            [MBProgressHUD hideHUDForView:nav.view animated:YES];
            break;
        }
        default:
            break;
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    latlyTab = [[UITableView alloc]init];
    latlyTab.delegate   = self;
    latlyTab.dataSource = self;
    latlyTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            latlyTab.frame = [UIView fitCGRect:CGRectMake(0, 44, 320, 480-44-44-44)
                                    isBackView:YES];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            latlyTab.frame = [UIView fitCGRect:CGRectMake(0, 60, 320, 460-44-44-44)
                                    isBackView:YES];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            latlyTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480-44-44)
                                    isBackView:YES];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            latlyTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480)
                                    isBackView:YES];
        }
    }
    [self.view addSubview:latlyTab];
    
    
    UIImage *bgImg = [UIImage imageNamed:@"pp_nodata_bg"];
    bgImgView      = [[UIImageView alloc]initWithImage:bgImg];
    bgImgView.frame= [UIView fitCGRect:CGRectMake(160-50,
                                                  280/2-40+44,
                                                  100,
                                                  80)
                            isBackView:NO];
    [self.view addSubview:bgImgView];
    
    //初始化上拉刷新
    [self initPullView];
    
    latlyTab.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    
    BottomView *bView = [[BottomView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(0, 480-44-120, 320, 120)
                                                                isBackView:NO]];
    [self.view addSubview:bView];
    [bView release];
}

- (void) initPullView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - latlyTab.bounds.size.height, self.view.frame.size.width, latlyTab.bounds.size.height)];
		view.delegate = self;
		[latlyTab addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void) getMessageFromTeacher:(NSNotification *)notice
{
    
}

- (void) getAssistentsMessage
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    [ccDic release];
    ccDic = nil;
    ccDic = [[NSDictionary alloc]init];
    
    [applyArray removeAllObjects];
    [applyArray release];
    applyArray = nil;
    applyArray = [[NSMutableArray alloc]init];
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action", @"viewstatus",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getJxzl", @"1", ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url  = [NSString stringWithFormat:@"%@%@", webAddress,TEACHER];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate = self;
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

- (void) deleteStudentFormChat:(NSString *) studentId
{
    if (![AppDelegate isConnectionAvailable:YES
                                withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"studentId",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"deleteNewMember",studentId,ssid, nil];
    NSDictionary *dic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@", webAdd,TEACHER];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    [request requestASyncWith:kServerPostRequest
                     paramDic:dic
                       urlStr:url];
}

- (void) tapGestureRecongnizer:(id)sender
{
    UIButton *btn = sender;
    switch (btn.tag)
    {
        case 0:   //电话联系他
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [ccDic objectForKey:@"cc_phone"]]]];
            break;
        }
        case 1:   //解约
        {
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
            
            NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
            NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
            NSArray *valuesArr = [NSArray arrayWithObjects:@"applyTermination", ssid, nil];
            NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                             forKeys:paramsArr];
            NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
            NSString *url  = [NSString stringWithFormat:@"%@%@", webAddress,TEACHER];
            ServerRequest *serverReq = [ServerRequest sharedServerRequest];
            serverReq.delegate = self;
            NSData *resVal   = [serverReq requestSyncWith:kServerPostRequest
                                                paramDic:pDic
                                                  urlStr:url];
            NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                     encoding:NSUTF8StringEncoding]autorelease];
            NSDictionary *resDic = [resStr JSONFragmentValue];
            if (resDic)
            {
                NSString *errorid = [resDic objectForKey:@"errorid"];
                if (errorid.intValue==0)
                {
                    CLog(@"applyTermination Success!");
                    
                    //刷新界面
                    [self getAssistentsMessage];
                }
                else
                    CLog(@"applyTermination Failed!");
            }
            else
                CLog(@"applyTermination Failed!");
            
            [MBProgressHUD hideHUDForView:nav.view animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
    [self getAssistentsMessage];
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:latlyTab];
	
}

#pragma mark -
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark - EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
    //	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDatasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (ccDic.count!=0 || applyArray.count!=0)
        bgImgView.hidden = YES;
    else
        bgImgView.hidden = NO;
    
    if (ccDic.count==0)
        return applyArray.count;
    else
        return applyArray.count+1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 54;
    }
    
    return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString    = @"idString";
    
    int index = 0;
    if (indexPath.row == 0)  //显示助理信息
    {
        UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:idString]autorelease];
        if (ccDic.count != 0)
        {
            index = 1;
            
            UIImageView *flgImgView = [[UIImageView alloc]init];
            flgImgView.image = [UIImage imageNamed:@"stp_cc_flag"];
            flgImgView.frame = CGRectMake(5, 0, 40, 40);
            [cell addSubview:flgImgView];
            [flgImgView release];
            
            UILabel *titleLab  = [[UILabel alloc]init];
            titleLab.text  = [ccDic objectForKey:@"cc_name"];
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.font = [UIFont systemFontOfSize:14.f];
            titleLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
            titleLab.frame = CGRectMake(50, 5, 100, 20);
            [cell addSubview:titleLab];
            [titleLab release];
            
            UIImage *phoneImg  = [UIImage imageNamed:@"stp_cc_tel_btn"];
            UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            phoneBtn.tag   = 0;
            [phoneBtn setImage:phoneImg
                      forState:UIControlStateNormal];
            phoneBtn.frame = CGRectMake(50, 27, phoneImg.size.width, phoneImg.size.height);
            [phoneBtn addTarget:self
                         action:@selector(tapGestureRecongnizer:)
               forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:phoneBtn];
            
            
            UIImage *okBtnImg = [UIImage imageNamed:@"dialog_ok_normal_btn"];
            UIButton *okBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            okBtn.tag   = 1;
            [okBtn setTitleColor:[UIColor blackColor]
                        forState:UIControlStateNormal];
            okBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
            okBtn.frame = CGRectMake(cell.frame.size.width-okBtnImg.size.width-10,
                                     54/2-okBtnImg.size.height/2,
                                     okBtnImg.size.width,
                                     okBtnImg.size.height);
            [okBtn setTitle:@"解约"
                   forState:UIControlStateNormal];
            [okBtn setBackgroundImage:[UIImage imageNamed:@"dialog_ok_normal_btn"]
                             forState:UIControlStateNormal];
            [okBtn setBackgroundImage:[UIImage imageNamed:@"dialog_ok_hlight_btn"]
                             forState:UIControlStateHighlighted];
            [okBtn addTarget:self
                      action:@selector(tapGestureRecongnizer:)
            forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:okBtn];
            
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lp_sys_cell_bg"]];
        }
        return cell;
    }
    else                     //显示申请助理消息
    {
        AssistentCell *cell = [[AssistentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idString"];
        cell.delegate = self;
        cell.tag      = indexPath.row-index;
        if (applyArray.count>0)
        {
            [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lt_list_bg"]]];
            NSDictionary *applyDic = [applyArray objectAtIndex:indexPath.row-index];
            cell.applyDic = applyDic;
        }
        
        return cell;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
        return NO;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
//        NSDictionary *dic = [msgArray objectAtIndex:indexPath.row-1];
//        [self deleteStudentFormChat:[(NSString *)[dic objectForKey:@"studentId"] copy]];
//        [msgArray removeObjectAtIndex:indexPath.row-1];
        
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void) imageView:(TTImageView *)imageView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark -
#pragma mark - LatlyViewCellDelegate
- (void) view:(AssistentCell *) view clickedIndex:(int)index
{
    NSDictionary *assistDic = view.applyDic;
    switch (index)
    {
        case 0:          //电话联系
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [assistDic objectForKey:@"cc_phone"]]]];
            break;
        }
        case 1:          //选他
        {
            //提示
            AssistentPopViewController *apVctr  = [[AssistentPopViewController alloc]init];
            apVctr.applyDic = view.applyDic;
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            [nav presentPopupViewController:apVctr animationType:MJPopupViewAnimationFade];
            break;
        }
        default:
            break;
    }
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
    
    [self doneLoadingTableViewData];
    
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
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"getJxzl"])
        {
            
            ccDic = [[resDic objectForKey:@"cc"] copy];
            
            NSArray *array = [resDic objectForKey:@"apply"];
            for (NSDictionary *item in array)
                 [applyArray addObject:item];
            
            [latlyTab reloadData];
        }
        else if ([action isEqualToString:@"deleteNewMember"])
        {
            CLog(@"delete Teacher From Chat Success!");
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
    
    [latlyTab reloadData];
    
    [self doneLoadingTableViewData];
}
@end
