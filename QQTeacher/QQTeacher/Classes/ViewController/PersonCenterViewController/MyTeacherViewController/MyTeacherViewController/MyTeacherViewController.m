//
//  MyTeacherViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "MyTeacherViewController.h"

@interface MyTeacherViewController ()
@property (nonatomic, retain) NSMutableArray *retractableControllers;
@end

@implementation MyTeacherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"家教";
        self.tabBarItem.image = [UIImage imageNamed:@"user_1_1"];
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            self.tableView.frame = [UIView fitCGRect:CGRectMake(0, 44, 320, 480-44-44-44)
                                          isBackView:YES];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            self.tableView.frame = [UIView fitCGRect:CGRectMake(0, 64, 320, 460-44-44-44)
                                          isBackView:YES];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            self.tableView.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480-44-44)
                                          isBackView:YES];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            self.tableView.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480)
                                          isBackView:YES];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissComplainNotice:)
                                                 name:@"dismissComplainNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doCommentOrderNotice:)
                                                 name:@"commentOrderNotice"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshOrders:)
                                                 name:@"refreshOrders"
                                               object:nil];
    
    [self getOrderStudents];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MainViewController setNavTitle:@"个人中心"];
    self.navigationController.navigationBarHidden = YES;
    
    //初始化上拉刷新
    [self initPullView];
    
    UIImage *bgImg = [UIImage imageNamed:@"pp_nodata_bg"];
    bgImgView      = [[UIImageView alloc]initWithImage:bgImg];
    bgImgView.frame= [UIView fitCGRect:CGRectMake(160-50,
                                                  280/2-40+44,
                                                  100,
                                                  80)
                            isBackView:NO];
    [self.view addSubview:bgImgView];
    
    //获得订单列表
    self.retractableControllers = [[NSMutableArray alloc]init];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
    _refreshHeaderView    = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [bgImgView release];
    _refreshHeaderView = nil;
    [studentArray release];
    [super dealloc];
}


#pragma mark -
#pragma mark - Notice
- (void) dismissComplainNotice:(NSNotification *) notice
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) refreshOrders:(NSNotification *) notice
{
    [self reloadTableViewDataSource];
}

- (void) doCommentOrderNotice:(NSNotification *) notice
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSNumber *index    = [notice.userInfo objectForKey:@"Index"];
    NSString *orderId  = [notice.userInfo objectForKey:@"OrderID"];
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"orderid",@"value",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"setEvaluate", orderId, index, ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate   = self;
    [request requestASyncWith:kServerPostRequest
                     paramDic:pDic
                       urlStr:url];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initPullView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void) reloadUI
{
    [self.retractableControllers removeAllObjects];
    for (NSDictionary *item in studentArray)
    {
        TeacherOrderSectionController *sVctr = [[TeacherOrderSectionController alloc] initWithViewController:self];
        
        sVctr.teacherOrderDic = [item copy];
        sVctr.ordersArr       = [item objectForKey:@"orders"];
        [self.retractableControllers addObject:sVctr];
        [sVctr release];
    }
    [self.tableView reloadData];
}

- (void) getOrderStudents
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    if ([AppDelegate isInView:@"MyTeacherViewController"])
    {
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
    }
    
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"caches_time",@"sessid",nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getOrders",@"", ssid, nil];
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
#pragma mark - UITableViewDelegate and UITableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.retractableControllers.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!iPhone5)
//    {
//        self.tableView.frame = [UIView fitCGRect:CGRectMake(0, 64, 320, 460-44-44-44)
//                                      isBackView:NO];
//    }
//    else
//    {
//        self.tableView.frame = [UIView fitCGRect:CGRectMake(0, 44, 320, 480-44-44-44)
//                                      isBackView:YES];
//    }
    
    if (indexPath.row == 0) //老师Cell
    {
        return 80;
    }
    else                    //订单Cell
    {
        GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
        return [sectionController heightForRow:indexPath.row];
    }

    return 105;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:section];
    NSInteger count = sectionController.numberOfRow;
    if (count>0)
        bgImgView.hidden = YES;
    else
    {
        bgImgView.hidden = NO;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    MyTeacherCell *cell = nil;
    if (indexPath.row == 0)
    {
        cell = (MyTeacherCell *)[sectionController cellForRow:indexPath.row];
        cell.delegate = self;
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mtp_tcell_bg"]];
        
        return cell;
    }

    return [sectionController cellForRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //发送隐藏消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentViewNoticeDismiss"
                                                        object:nil
                                                      userInfo:nil];
    
    GCRetractableSectionController* sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    return [sectionController didSelectCellAtRow:indexPath.row];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    
    //刷新订单数据
    [self getOrderStudents];
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
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
#pragma mark - MFMessageComposeViewDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:NO];
    
    switch ( result )
    {
        case MessageComposeResultCancelled:
        {
            break;
        }
        case MessageComposeResultFailed:
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"发送取消"
                            delegate:self
                   otherButtonTitles:@"确定", nil];
            break;
        }
        case MessageComposeResultSent:
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"发送失败"
                            delegate:self
                   otherButtonTitles:@"确定", nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - MyTeacherCellDelegate
- (void) tableViewCell:(MyTeacherCell *)cell ClickedButton:(int)index
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    switch (index)
    {
        case 0:
        {
            break;
        }
        case 1:     //沟通
        {
            ChatViewController *cVctr = [[ChatViewController alloc]init];
            cVctr.student    = cell.order.student;
            [nav pushViewController:cVctr animated:YES];
            [cVctr release];
            break;
        }
        case 2:     //投诉
        {
            CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
            
            ComplainViewController *cpVctr = [[ComplainViewController alloc]init];
            cpVctr.student = cell.order.student;
            [nav presentPopupViewController:cpVctr
                               animationType:MJPopupViewAnimationFade];
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
    [self doneLoadingTableViewData];
    
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
    [self doneLoadingTableViewData];
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
    
    NSData   *resVal = [request responseData];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic   = [resStr JSONFragmentValue];
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
        if ([action isEqualToString:@"getOrders"])
        {
            studentArray = [[resDic objectForKey:@"students"] copy];
            
            //初始化UI
            [self reloadUI];
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
