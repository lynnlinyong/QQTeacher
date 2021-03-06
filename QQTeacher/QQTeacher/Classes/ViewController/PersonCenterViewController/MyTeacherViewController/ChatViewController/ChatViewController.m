//
//  ChatViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize student;
@synthesize messages;
@synthesize order;
@synthesize isFromSearchCondition;

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
    
    //初始化录音
    recordAudio = [[RecordAudio alloc]init];
    recordAudio.delegate = self;
    
    //初始化UI
    isNewData = NO;
    [self initUI];
    [self initPullView];
}

- (void) viewDidUnload
{
    recordAudio.delegate = nil;
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"和学生沟通"];
    
    [self initBackBarItem];
    
    //获得聊天记录
    [self getChatRecords];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshNewData:)
                                                 name:@"refreshNewData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showTeacherDetailNotice:)
                                                 name:@"showTeacherDetailNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissComplainNotice:)
                                                 name:@"dismissComplainNotice"
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [listenSwitch removeFromSuperview];
    listenSwitch = nil;
    
    [listenLab removeFromSuperview];
    listenLab = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = nil;
    
    [super viewDidDisappear:animated];
}

- (void) dealloc
{
    [listenLab    release];
    [infoView     release];
    [listenView   release];
    [recordAudio  release];
    [listenSwitch release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Custom Action
- (void) initInfoPopView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(doEmployClicked:)];
    listenView = [[UIView alloc]init];
    listenView.hidden = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            listenView.frame  = [UIView fitCGRect:CGRectMake(10, 44, 300, 40)
                                           isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            listenView.frame  = [UIView fitCGRect:CGRectMake(10, 54, 300, 40)
                                           isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            listenView.frame  = [UIView fitCGRect:CGRectMake(10, 0, 300, 40)
                                           isBackView:NO];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            listenView.frame  = [UIView fitCGRect:CGRectMake(10, 0, 300, 40)
                                           isBackView:NO];
        }
    }
    [listenView addGestureRecognizer:tap];
    [self.view addSubview:listenView];
    [tap release];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cp_chatinfo_bg"]];
    bgView.frame = CGRectMake(0,0, 300, 40);
    [listenView addSubview:bgView];
    [bgView release];
    
    UILabel *employLab  = [[UILabel alloc]init];
    employLab.textColor = [UIColor whiteColor];
    employLab.text = @"打开免费试听按钮,更快和学生达成沟通！";
    employLab.backgroundColor = [UIColor clearColor];
    employLab.frame = CGRectMake(7,10,300,30);
    employLab.numberOfLines = 0;
    employLab.font = [UIFont systemFontOfSize:14.f];
    employLab.lineBreakMode = NSLineBreakByWordWrapping;
    [listenView addSubview:employLab];
    [employLab release];
}

- (void) doTapGestureReg:(UIGestureRecognizer *) reg
{
    infoView.hidden = YES;
}

- (void) doEmployClicked:(UIGestureRecognizer *) reg
{
    listenView.hidden = YES;
}

- (void) initBackBarItem
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
    nav.dataSource = self;
}

+ (void) convertAmrToMp3:(NSString *)audioURL delegate:(id<RecordAudioDelegate>) delegate
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArray = [NSArray arrayWithObjects:@"action",@"audio",@"sessid", nil];
    NSArray *valuesArray = [NSArray arrayWithObjects:@"amrToMp3", audioURL, ssid, nil];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,TEACHER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
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
    [request startSynchronous];
    NSData *resVal = [request responseData];
    if (resVal)
    {
        RecordAudio *audio = [[RecordAudio alloc]init];
        audio.delegate = delegate;
        [audio playMP3:resVal];
    }
}

- (void) initUI
{
    self.delegate = self;
    self.dataSource = self;
    messages   = [[NSMutableArray alloc]init];

    listenLab = [[UILabel alloc]init];
    listenLab.text  = @"试听";
    listenLab.font  = [UIFont systemFontOfSize:14.f];
    listenLab.frame = CGRectMake(320-110, 9, 40, 25);
    listenLab.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:listenLab];
    
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
    Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    listenSwitch = [[UISwitch alloc]init];
    listenSwitch.on = teacher.listenStar;
    listenSwitch.frame = CGRectMake(320-listenSwitch.frame.size.width,
                                    self.navigationController.navigationBar.frame.size.height/2-listenSwitch.frame.size.height/2,
                                    listenSwitch.frame.size.width, 25);
    [listenSwitch addTarget:self
                     action:@selector(doValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    [self.navigationController.navigationBar addSubview:listenSwitch];
    
    [self initInfoPopView];
}

- (void) doValueChanged:(id)sender
{
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
    Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    teacher.listenStar = listenSwitch.on;
    
    //修改试听状态
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSNumber *listenNum;
    if (teacher.listenStar)
        listenNum = [NSNumber numberWithInt:1];
    else
        listenNum = [NSNumber numberWithInt:0];
    
    //更新个人资料
    NSArray *infosParamsArr = [NSArray arrayWithObjects:@"pre_listening",nil];
    NSArray *infosValuesArr = [NSArray arrayWithObjects:listenNum,nil];
    NSDictionary *infosDic  = [NSDictionary dictionaryWithObjects:infosValuesArr
                                                          forKeys:infosParamsArr];
//    NSString *infosJson = [infosDic JSONFragment];
    NSData *data = [NSJSONSerialization dataWithJSONObject:infosDic
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *infosJson = [[NSString alloc]initWithData:data
                                               encoding:NSUTF8StringEncoding];
    
    NSString *ssid   = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"infos",@"sessid",nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"upinfos",infosJson, ssid, nil];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,TEACHER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    for (int i=0; i<paramsArr.count; i++)
    {
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
    }
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"Content-Type"
                        value:@"text/xml; charset=utf-8"];
    [request startSynchronous];
    NSData *resVal = [request responseData];
    if (resVal)
    {
        CLog(@"upload listen status susscess!");
        
        NSData *teacherData = [NSKeyedArchiver archivedDataWithRootObject:teacher];
        [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                  forKey:TEACHER_INFO];
        
        //发送修改试听状态消息
        NSArray *paramsArr  = [NSArray arrayWithObjects:@"type", @"phone",nil];
        NSArray *valuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_LISTENING_CHANG],teacher.phoneNums, nil];
        NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                          forKeys:paramsArr];
//        NSString *jsonMsg   = [pDic JSONFragment];
//        NSData *data        = [jsonMsg dataUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [NSJSONSerialization dataWithJSONObject:pDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
        
        //发送消息
        SingleMQTT *session = [SingleMQTT shareInstance];
        [session.session publishData:data
                             onTopic:student.deviceId];
    }
    else
    {
        CLog(@"upload listen status failed!");
    }
}

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

- (void) getRecordPage
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    if (self.messages.count>0)
    {
        NSDictionary *item = [messages objectAtIndex:messages.count-1];
        CLog(@"item:%@", item);
        NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"messageId",@"phone",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"getMessages",[item objectForKey:@"messageId"],student.phoneNumber,ssid, nil];
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd, TEACHER];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestAsyncSuccessed:)];
        [request setDidFailSelector:@selector(requestAsyncFailed:)];
        for (int i=0; i<paramsArr.count; i++)
        {
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
        }
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request addRequestHeader:@"Content-Type"
                            value:@"text/xml; charset=utf-8"];
        [request startAsynchronous];
    }
}

//- (void) isShowListenBtn
//{
//    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
//    {
//        return;
//    }
//    
//    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
//    
//    //判断是否显示试听和聘请
//    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",@"sessid", nil];
//    NSArray *valusArr  = [NSArray arrayWithObjects:@"getListening",student.phoneNumber,ssid, nil];
//    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valusArr
//                                                     forKeys:paramsArr];
//    
//    ServerRequest *request = [ServerRequest sharedServerRequest];
//    request.delegate = self;
//    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
//    NSString *url  = [NSString stringWithFormat:@"%@%@/", webAddress,TEACHER_INFO];
//    NSData *resVal = [request requestSyncWith:kServerPostRequest
//                                     paramDic:pDic
//                                       urlStr:url];
//    if (resVal)
//    {
//        NSString *resStr = [[[NSString alloc]initWithData:resVal
//                                                 encoding:NSUTF8StringEncoding]autorelease];
//        NSDictionary *resDic  = [resStr JSONValue];
//        CLog(@"Listen:%@", resDic);
//        NSString *action = [resDic objectForKey:@"action"];
//        if ([action isEqualToString:@"getListening"])
//        {
//            int isListening = ((NSString *)[resDic objectForKey:@"isListening"]).intValue;
//            if (isListening == 1)
//            {
////                listenBtn.hidden = NO;
//                listenView.hidden = NO;
//            }
//            else
//            {
////                listenBtn.hidden = YES;
//                listenView.hidden = YES;
//            }
//        }
//    }
//    else
//    {
////        listenBtn.hidden = YES;
//        listenView.hidden = YES;
//    }
//}

//- (void) isShowEmployBtn
//{
//    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
//    {
//        return;
//    }
//    
//    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
//    
//    //判断是否显示试听和聘请
//    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",@"sessid", nil];
//    NSArray *valusArr  = [NSArray arrayWithObjects:@"getHire",student.phoneNumber,ssid, nil];
//    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valusArr
//                                                     forKeys:paramsArr];
//    
//    ServerRequest *request = [ServerRequest sharedServerRequest];
//    request.delegate = self;
//    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
//    NSString *url  = [NSString stringWithFormat:@"%@%@/", webAddress,TEACHER_INFO];
//    NSData *resVal = [request requestSyncWith:kServerPostRequest
//                                     paramDic:pDic
//                                       urlStr:url];
//    if (resVal)
//    {
//        NSString *resStr = [[[NSString alloc]initWithData:resVal
//                                                 encoding:NSUTF8StringEncoding]autorelease];
//        CLog(@"Employ:%@", resStr);
//        NSDictionary *resDic  = [resStr JSONValue];
//        NSString *action = [resDic objectForKey:@"action"];
//        if ([action isEqualToString:@"getHire"])
//        {
//            int isHire = ((NSNumber *)[resDic objectForKey:@"isHire"]).intValue;
//            if (isHire == 0)
//            {
//                employBtn.hidden = YES;
//            }
//            else
//            {
//                employBtn.hidden = NO;
//            }
//        }
//    }
//    else
//    {
//        employBtn.hidden = YES;
//    }
//    
//    //聘请按钮隐藏试听按钮后移动
//    if (employBtn.hidden)
//        listenBtn.frame = CGRectMake(employBtn.frame.origin.x,
//                                     employBtn.frame.origin.y,
//                                     listenBtn.frame.size.width,
//                                     listenBtn.frame.size.height);
//}

- (void) getChatRecords
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    isNewData = YES;
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"messageId",@"phone",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getMessages",@"0",student.phoneNumber, ssid, nil];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd, TEACHER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestAsyncSuccessed:)];
    [request setDidFailSelector:@selector(requestAsyncFailed:)];
    for (int i=0; i<paramsArr.count; i++)
    {
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
    }
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"Content-Type"
                        value:@"text/xml; charset=utf-8"];
    [request startAsynchronous];
}

+ (NSString *) getRecordURL
{
    NSArray *paths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                           NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableString  *path       = [[NSMutableString alloc]initWithString:documentsDirectory];
    [path appendString:VOICE_NAME];
    
    return path;
}

- (void) startRecord
{
    [recordAudio stopPlay];
    [recordAudio startRecord];
}

- (void) stopRecord
{
    //写入amr数据文件
    NSURL *url       = [recordAudio stopRecord];
    CLog(@"URL:%@", url);
    NSData *curAudio = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
    NSString *path   = [ChatViewController getRecordURL];
    CLog(@"path:%@", path);
    [curAudio writeToFile:path
               atomically:YES];
}

-(void)RecordStatus:(int)status
{
    if (status==0)
    {
        //播放中
    }
    else if(status==1)
    {
        //完成

    }
    else if(status==2)
    {
        //出错
        CLog(@"播放出错");
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopVoiceAnimation"
                                                        object:nil];
}


- (void) sendVoiceFile:(int) voiceTimes
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    //上传语音文件
    NSString *path = [ChatViewController getRecordURL];
    
    //获得时间戳
    NSDate *dateNow  = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"edittime",@"uptype",@"sessid",UPLOAD_FILE, nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"uploadfile",
                          timeSp,@"audio",ssid,[NSDictionary dictionaryWithObjectsAndKeys:path,@"file", nil],nil];
    
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,TEACHER];
    
    //上传录音文件
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    for (int i=0; i<paramsArr.count; i++)
    {
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
    }
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"Content-Type"
                        value:@"text/xml; charset=utf-8"];
    [request startSynchronous];
    NSData *resVal = [request responseData];
    if (resVal )
    {
        NSDictionary *resDic   = [NSJSONSerialization JSONObjectWithData:resVal
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"uploadfile"])
        {
            path = [resDic objectForKey:@"filepath"];
            CLog(@"filePath:%@", path);
            
            NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
            Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
            
            NSDate *dateNow  = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
            
            NSArray *paramsArr  = [NSArray arrayWithObjects:@"type", @"phone", @"nickname", @"sound",@"stime",@"time",@"taPhone",@"deviceId",nil];
            NSArray *valuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_AUDIO],teacher.phoneNums,teacher.name,path,[NSNumber numberWithInt:voiceTimes],timeSp,student.phoneNumber,[SingleMQTT getCurrentDevTopic], nil];
            NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                              forKeys:paramsArr];
            //发送消息
//            NSString *jsonMsg   = [pDic JSONFragment];
//            NSData *data        = [jsonMsg dataUsingEncoding:NSUTF8StringEncoding];
            NSData *data = [NSJSONSerialization dataWithJSONObject:pDic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
            NSString *jsonMsg   = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            SingleMQTT *session = [SingleMQTT shareInstance];
            [session.session publishData:data
                                 onTopic:student.deviceId];
            
            NSDictionary *ccResDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"AssistentData"];
            if (![ccResDic isEqual:[NSNull null]])
            {
                NSDictionary *ccDic = [ccResDic objectForKey:@"cc"];
                if (ccDic.count!=0)
                {
                    NSArray *ccParamsArr  = [NSArray arrayWithObjects:@"type", @"phone", @"nickname", @"sound",@"stime",@"time",@"taPhone",@"deviceId",@"toPhone",nil];
                    NSArray *ccValuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_AUDIO],teacher.phoneNums,teacher.name,path,[NSNumber numberWithInt:voiceTimes],timeSp,[ccDic objectForKey:@"cc_phone"],[SingleMQTT getCurrentDevTopic],student.phoneNumber,nil];
                    NSDictionary *ccPDic  = [NSDictionary dictionaryWithObjects:ccValuesArr
                                                                        forKeys:ccParamsArr];
//                    NSString *ccJsonMsg = [ccPDic JSONFragment];
//                    NSData *ccData      = [ccJsonMsg dataUsingEncoding:NSUTF8StringEncoding];
                    NSData *ccData = [NSJSONSerialization dataWithJSONObject:ccPDic
                                                                     options:NSJSONWritingPrettyPrinted
                                                                       error:nil];
                    CLog(@"ccPic:%@, deviceId:%@", ccPDic, [ccDic objectForKey:@"deviceId"]);
                    [session.session publishData:ccData onTopic:[ccDic objectForKey:@"deviceId"]];
                }
            }
            //消息上传服务器
            [self uploadMessageToServer:jsonMsg];
            
            //播放声音
            if((self.messages.count - 1) % 2)
                [JSMessageSoundEffect playMessageSentSound];
            else
                [JSMessageSoundEffect playMessageReceivedSound];
        }
    }
    else
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"上传文件失败"
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
}

#pragma mark -
#pragma mark - UILongPressButtonDelegate
- (void) longPressButton:(UILongPressButton *)btn status:(ButtonStatus)status
{
    switch (status)
    {
        case LONG_PRESS_BUTTON_DOWN:
        {
            //显示动画
            [SVProgressHUD showWithStatus:@""];
            [self startRecord];
            break;
        }
        case LONG_PRESS_BUTTON_SHORT:
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"录音时间太短"
                            delegate:self
                   otherButtonTitles:@"确定",nil];
            
            //停止动画
            [SVProgressHUD dismiss];
            [self stopRecord];
            break;
        }
        case LONG_PRESS_BUTTON_LONG:
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"录音时间太长"
                            delegate:self
                   otherButtonTitles:@"确定",nil];
            //停止动画
            [SVProgressHUD dismiss];
            [self stopRecord];
            break;
        }
        case LONG_PRESS_BUTTON_UP:
        {
            //停止动画
            [SVProgressHUD dismiss];
            [self stopRecord];
            
            //发送语音文件
            CLog(@"times:%d", [btn getVoiceTimes]);
            [self sendVoiceFile:[btn getVoiceTimes]];
            break;
        }
        default:
            break;
    }
}
- (void) doBackBtnClicked:(id)sender
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav popViewControllerAnimated:YES];
}

//- (void) doButtonClicked:(id)sender
//{
//    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
//    {
//        return;
//    }
//    
//    UIButton *btn = sender;
//    switch (btn.tag)
//    {
//        case 0:      //试听
//        {
//            NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
//            NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",@"sessid", nil];
//            NSArray *valueArr  = [NSArray arrayWithObjects:@"setListening",student.phoneNumber,ssid,nil];
//            NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valueArr
//                                                             forKeys:paramsArr];
//            ServerRequest *request = [ServerRequest sharedServerRequest];
//            request.delegate       = self;
//            NSString *webAddress   = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
//            NSString *url  = [NSString stringWithFormat:@"%@%@", webAddress,TEACHER_INFO];
//            [request requestASyncWith:kServerPostRequest
//                             paramDic:pDic
//                               urlStr:url];
//            break;
//        }
//        case 1:      //聘请
//        {
//            //跳转到
//            if (order)
//            {
//                CustomNavigationViewController *nav     = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
//                UpdateOrderViewController *upVctr = [[UpdateOrderViewController alloc]init];
//                upVctr.isEmploy = YES;
//                upVctr.order = order;
//                [nav pushViewController:upVctr
//                               animated:YES];
//                [upVctr release];
//            }
//            else
//            {
//            }
//            break;
//        }
//        case 2:
//        {
//            break;
//        }
//        default:
//            break;
//    }
//}

- (void) updateMessageZT
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    isNewData = NO;
    
    //获得时间戳
    NSDate *dateNow    = [NSDate date];
    NSString *timeSp   = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",
                          @"sendTime",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"updateMessageZT",student.phoneNumber,
                          timeSp,ssid,nil];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,TEACHER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    for (int i=0; i<paramsArr.count; i++)
    {
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
    }
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"Content-Type"
                        value:@"text/xml; charset=utf-8"];
    [request startSynchronous];
    NSData *resVal = [request responseData];
    if (resVal )
    {
        NSDictionary *resDic   = [NSJSONSerialization JSONObjectWithData:resVal
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];
        NSNumber *errorid = [resDic objectForKey:@"errorid"];
        if (errorid.intValue == 0)
        {
            NSString *action = [resDic objectForKey:@"action"];
            if ([action isEqualToString:@"submitMessage"])
            {
                CLog(@"Upload Message Success!");
                [self getChatRecords];
            }
        }
        else
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"上传信息失败"
                            delegate:self
                   otherButtonTitles:@"确定",nil];
        }
    }
}

- (void) uploadMessageToServer:(NSString *) msg
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    isNewData = YES;
    
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"message",
                                                   @"phone",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"submitMessage",msg,
                                                   student.phoneNumber,ssid,nil];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,TEACHER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    for (int i=0; i<paramsArr.count; i++)
    {
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
    }
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"Content-Type"
                        value:@"text/xml; charset=utf-8"];
    [request startSynchronous];
    NSData *resVal = [request responseData];
    if (resVal )
    {
        NSDictionary *resDic   = [NSJSONSerialization JSONObjectWithData:resVal
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];
        NSNumber *errorid = [resDic objectForKey:@"errorid"];
        if (errorid.intValue == 0)
        {
            NSString *action = [resDic objectForKey:@"action"];
            if ([action isEqualToString:@"submitMessage"])
            {
                CLog(@"Upload Message Success!");
                [self getChatRecords];
            }
        }
        else
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"上传信息失败"
                            delegate:self
                   otherButtonTitles:@"确定",nil];
        }
    }
}

#pragma mark -
#pragma mark - Notice
- (void) showTeacherDetailNotice:(NSNotification *) notice
{
}

- (void) dismissComplainNotice:(NSNotification *) notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) refreshNewData:(NSNotification *) notice
{
    NSMutableDictionary *msgDic = [notice.userInfo mutableCopy];
    [msgDic setObject:@"0" forKey:@"messageId"];
    [msgDic setObject:[NSNumber numberWithBool:NO]
             forKey:@"isRead"];
    [messages insertObject:msgDic atIndex:0];
    
    //刷新界面
    [self finishSend];
    
    //消息查看更新
    [self updateMessageZT];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    //获得聊天记录
    [self getRecordPage];
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate
- (void) buttonPressed:(UIButton *)sender 
{
    switch (sender.tag)
    {
        case 0:       //投诉
        {
            ComplainViewController *cVctr = [[ComplainViewController alloc]init];
            cVctr.student = student;
            [self presentPopupViewController:cVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 1:       //电话
        {
            //检测老师端是否允许接听电话
            [self checkStudentPhone];
            break;
        }
        case 2:       //声音
        {
            
            break;
        }
        default:
            break;
    }
}

- (void) checkStudentPhone
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"student_phone",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"callPhone",student.phoneNumber, ssid, nil];
    
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,TEACHER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    for (int i=0; i<paramsArr.count; i++)
    {
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
    }
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"Content-Type"
                        value:@"text/xml; charset=utf-8"];
    [request startSynchronous];
    NSData *resVal = [request responseData];
    if (resVal )
    {
        NSDictionary *resDic   = [NSJSONSerialization JSONObjectWithData:resVal
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];
        NSString *errorid = [resDic objectForKey:@"errorid"];
        if (errorid.integerValue==0)
        {
            //拨打电话
            NSString *phone = [NSString stringWithFormat:@"tel://%@", student.phoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        }
        else
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"老师不允许拨打电话"
                            delegate:self
                   otherButtonTitles:@"确定",nil];
        }
    }
    
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
    Teacher *teacher     = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    NSDate *dateNow  = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    
    NSArray *paramsArr  = [NSArray arrayWithObjects:@"type", @"phone", @"nickname", @"icon",@"text",@"time",@"taPhone",@"deviceId",nil];
    NSArray *valuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_TEXT],teacher.phoneNums,teacher.name,teacher.headUrl,text,timeSp,student.phoneNumber,[SingleMQTT getCurrentDevTopic], nil];
    NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                      forKeys:paramsArr];
    
    //发送消息
//    NSString *jsonMsg   = [pDic JSONFragment];
//    NSData *data        = [jsonMsg dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSJSONSerialization dataWithJSONObject:pDic
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *jsonMsg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    SingleMQTT *session = [SingleMQTT shareInstance];
    [session.session publishData:data
                         onTopic:student.deviceId];
    
    //检测是否存在助理,有给助理发一份
    NSDictionary *ccResDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"AssistentData"];
    if (![ccResDic isEqual:[NSNull null]])
    {
        NSDictionary *ccDic = [ccResDic objectForKey:@"cc"];
        if (ccDic.count!=0)
        {
            NSArray *ccParamsArr  = [NSArray arrayWithObjects:@"type", @"phone", @"nickname", @"icon",@"text",@"time",@"taPhone",@"deviceId",@"toPhone",nil];
            NSArray *ccValuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_TEXT],teacher.phoneNums,teacher.name,teacher.headUrl,text,timeSp,[ccDic objectForKey:@"cc_phone"],[SingleMQTT getCurrentDevTopic],student.phoneNumber,nil];
            NSDictionary *ccPDic  = [NSDictionary dictionaryWithObjects:ccValuesArr
                                                              forKeys:ccParamsArr];
//            NSString *ccJsonMsg = [ccPDic JSONFragment];
//            NSData *ccData      = [ccJsonMsg dataUsingEncoding:NSUTF8StringEncoding];
            NSData *ccData = [NSJSONSerialization dataWithJSONObject:ccPDic
                                                             options:NSJSONWritingPrettyPrinted
                                                               error:nil];
            CLog(@"ccPic:%@, deviceId:%@", ccPDic, [ccDic objectForKey:@"deviceId"]);
            [session.session publishData:ccData onTopic:[ccDic objectForKey:@"deviceId"]];
        }
    }
    //消息上传服务器
    [self uploadMessageToServer:jsonMsg];
    
    //播放声音
    [JSMessageSoundEffect playMessageSentSound];
    
    [self finishSend];
}

- (void) clickedMessageForRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (self.messages.count>0)
    {
        long index = self.messages.count-1-indexPath.row;
        NSMutableDictionary *item = [[messages objectAtIndex:index] mutableCopy];
        [item setObject:[NSNumber numberWithBool:YES] forKey:@"isRead"];
        [messages setObject:item atIndexedSubscript:index];
        
        NSString *soundPath= [[item objectForKey:@"sound"] retain];
        if (soundPath)
        {
            //下载播放
//            NSString *downPath = [[self getRecordURL] retain];
//            NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
//            soundPath = [NSString stringWithFormat:@"%@%@", webAdd, soundPath];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
               
                //amr转换mp3文件
                [ChatViewController convertAmrToMp3:soundPath delegate:self];
            
//                //下载音频文件
//                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:soundPath]];
//                request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:indexPath.row],@"TAG", nil];
//                [request setDelegate:self];
//                [request setDownloadProgressDelegate:self];
//                [request setDownloadDestinationPath:downPath];
//                [request startAsynchronous];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //更新UI
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:indexPath.row],@"TAG", nil];
                    
                    //停止动画
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopVoiceAnimation"
                                                                        object:nil
                                                                      userInfo:dic];
                    
                    //显示动画
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"startVoiceAnimation"
                                                                        object:nil
                                                                      userInfo:dic];
                });
                
            });
            
        }
        
        [self finishSend];
    }
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messages.count>0)
    {
        NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
        Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
        
        NSDictionary *item = [messages objectAtIndex:self.messages.count-indexPath.row-1];
        NSString *phone    = [item objectForKey:@"phone"];
        if ([teacher.phoneNums isEqualToString:phone])
        {
            return JSBubbleMessageTypeOutgoing;
        }
        else
        {
            return JSBubbleMessageTypeIncoming;
        }
    }
    return JSBubbleMessageTypeOutgoing;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleSquare;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyCustom;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    return JSAvatarStyleText;
}

- (JSAvatarStyle) outgoingAvatarStyle
{
    return JSAvatarStyleText;
}

- (JSAvatarStyle) incomingAvatarStyle
{
    return JSAvatarStyleText;
}

#pragma mark - Messages view data source
- (MsgType) msgTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messages.count>0)
    {
        long index = self.messages.count-1-indexPath.row;
        NSDictionary *dic = [self.messages objectAtIndex:index];
        if ([dic objectForKey:@"text"])
        {
            CLog(@"The Message is Text");
            return PUSH_TYPE_TEXT;
        }
        else if ([dic objectForKey:@"sound"])
        {
            CLog(@"The Message is Sound");
            return PUSH_TYPE_AUDIO;
        }
    }
    
    return PUSH_TYPE_TEXT;
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messages.count>0)
    {
        long index = self.messages.count-1-indexPath.row;
        NSDictionary *dic = [self.messages objectAtIndex:index];
        if ([dic objectForKey:@"text"])
        {
            NSDictionary *dic = [self.messages objectAtIndex:self.messages.count-indexPath.row-1];
            CLog(@"Dic:%@", dic);
            CLog(@"text:%@", [dic objectForKey:@"text"]);
            return [dic objectForKey:@"text"];
        }
        else if ([dic objectForKey:@"sound"])
        {
            
            NSDictionary *dic = [self.messages objectAtIndex:self.messages.count-indexPath.row-1];
            CLog(@"Dic:%@", dic);
            CLog(@"stime:%@", [dic objectForKey:@"stime"]);
            return [dic objectForKey:@"stime"];
        }
    }
    
    return nil;
}

- (BOOL) isReadVoice:(NSIndexPath *) indexPath
{
    if (self.messages.count>0)
    {
        long index = self.messages.count-1-indexPath.row;
        NSDictionary *dic = [self.messages objectAtIndex:index];
        if ([dic objectForKey:@"text"])
        {
            return YES;
        }
        else if ([dic objectForKey:@"sound"])
        {
            NSNumber *isReadNum = [dic objectForKey:@"isRead"];
            BOOL isRead = [isReadNum boolValue];
            return isRead;
        }
    }
    
    return NO;
}

//- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.timestamps objectAtIndex:indexPath.row];
//}

- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//- (UIImage *)avatarImageForIncomingMessage
//{
//    return nil;//[UIImage imageNamed:@"demo-avatar-woz"];
//}
//

//- (NSString *)avatarImagePathForOutgoingMessage
//{
//    return tObj.headUrl;
//}

//- (BOOL) isHaveOrg
//{
//    return tObj.isId;
//}

//- (UIImage *)avatarImageForOutgoingMessage
//{
//    return [UIImage imageNamed:@"demo-avatar-jobs"];
//}

- (NSString *) avatarNameForOutgoingMessage
{
    return @"我";
}

- (NSString *)avatarNameForIncomingMessage
{
    CLog(@"studentName:%@", student.nickName);
    return student.nickName;
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
#pragma mark ServerRequest Delegate
- (void) requestAsyncFailed:(ASIHTTPRequest *)request
{
    //聊天记录刷新完成
    [self doneLoadingTableViewData];
    
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
    //聊天记录刷新完成
    [self doneLoadingTableViewData];
    
    NSData   *resVal = [request responseData];
    if (resVal )
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
        
        NSNumber *errorid = [resDic objectForKey:@"errorid"];
        if (errorid.intValue == 0)
        {
            NSString *action = [resDic objectForKey:@"action"];
            if ([action isEqualToString:@"setListening"])
            {
                [self showAlertWithTitle:@"提示"
                                     tag:0
                                 message:@"您申请了试听课程,我们将以短信告知老师"
                                delegate:self
                       otherButtonTitles:@"确定",nil];
            }
            else if ([action isEqualToString:@"getMessages"])
            {
                NSArray *array = [resDic objectForKey:@"messages"];
                if (array)
                {
                    if (isNewData)
                        [messages removeAllObjects];
                    
                    for (int i=0; i<array.count; i++)
                    {
                        NSMutableDictionary *item = [[array objectAtIndex:i] mutableCopy];
                        if ([item objectForKey:@"sound"])
                        {
                            [item setObject:[NSNumber numberWithBool:YES]
                                     forKey:@"isRead"];
                        }
                        [messages addObject:item];
                        CLog(@"sdhfushdfItem:%@", item);
                        CLog(@"shdfsfhsudfhsufh:%d", [messages indexOfObject:item]);
                    }
                }
                
                //刷新界面
                [self finishSend];
                
                //消息查看更新
                [self updateMessageZT];
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
}

@end
