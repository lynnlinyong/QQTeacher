//
//  InviteNoticeCell.m
//  QQTeacher
//
//  Created by Lynn on 14-3-18.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import "InviteNoticeCell.h"

@implementation InviteNoticeCell
@synthesize noticeDic;
@synthesize noticeIndex;
@synthesize delegate;
@synthesize timer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        infoLab = [[UILabel alloc]init];
        infoLab.font = [UIFont systemFontOfSize:14.f];
        infoLab.backgroundColor = [UIColor clearColor];
        infoLab.frame = CGRectMake(5, 5, 135, 20);
        infoLab.textColor = [UIColor colorWithHexString:@"#009f66"];
        [self addSubview:infoLab];
        
        moneyLab = [[UILabel alloc]init];
        moneyLab.font = [UIFont systemFontOfSize:16.f];
        moneyLab.backgroundColor = [UIColor clearColor];
        moneyLab.frame = CGRectMake(140, 5, 135, 20);
        moneyLab.textColor = [UIColor redColor];
        [self addSubview:moneyLab];
        
        timesLab = [[UILabel alloc]init];
        timesLab.backgroundColor = [UIColor clearColor];
        timesLab.frame = CGRectMake(5, 25, 270, 20);
        timesLab.font  = [UIFont systemFontOfSize:14.f];
        [self addSubview:timesLab];
        
        
        startDateLab = [[UILabel alloc]init];
        startDateLab.backgroundColor = [UIColor clearColor];
        startDateLab.frame = CGRectMake(5, 45, 270, 20);
        startDateLab.font  = [UIFont systemFontOfSize:14.f];
        [self addSubview:startDateLab];
        
        posLab = [[UILabel alloc]init];
        posLab.backgroundColor = [UIColor clearColor];
        posLab.frame = CGRectMake(5, 65, 270, 20);
        posLab.font  = [UIFont systemFontOfSize:14.f];
        [self addSubview:posLab];
        
        
        distanceLab = [[UILabel alloc]init];
        distanceLab.backgroundColor = [UIColor clearColor];
        distanceLab.frame = CGRectMake(5, 85, 270, 20);
        distanceLab.font  = [UIFont systemFontOfSize:14.f];
        distanceLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
        [self addSubview:distanceLab];
        
        UILabel *secondStartLab = [[UILabel alloc]init];
        secondStartLab.text = @"还剩";
        secondStartLab.backgroundColor = [UIColor clearColor];
        secondStartLab.frame = CGRectMake(320-70, 85, 40, 20);
        secondStartLab.font  = [UIFont systemFontOfSize:14.f];
        secondStartLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
        [self addSubview:secondStartLab];
        [secondStartLab release];
        
        secondeLab = [[UILabel alloc]init];
        secondeLab.textAlignment = NSTextAlignmentCenter;
        secondeLab.backgroundColor = [UIColor clearColor];
        secondeLab.frame = CGRectMake(320-43, 85, 20, 20);
        secondeLab.font  = [UIFont systemFontOfSize:14.f];
        secondeLab.textColor = [UIColor redColor];
        [self addSubview:secondeLab];
        
        UILabel *secondEndLab = [[UILabel alloc]init];
        secondEndLab.text = @"秒";
        secondEndLab.backgroundColor = [UIColor clearColor];
        secondEndLab.frame = CGRectMake(320-25, 85, 15, 20);
        secondEndLab.font  = [UIFont systemFontOfSize:14.f];
        secondEndLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
        [self addSubview:secondEndLab];
        [secondEndLab release];
        
        UIImage *confirmImg = [UIImage imageNamed:@"mtp_confirm_btn"];
        confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn setImage:confirmImg forState:UIControlStateNormal];
        [confirmBtn addTarget:self
                       action:@selector(doButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.frame = CGRectMake(320-10-confirmImg.size.width, 20,
                                      confirmImg.size.width,confirmImg.size.height);
        [self addSubview:confirmBtn];
        
        [self setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mtp_invite_notice_bg"]]];
        
        isPlay = NO;
    }
    return self;
}

- (void) dealloc
{
    [timer stopTimer];
    
    [infoLab release];
    [moneyLab release];
    [timesLab release];
    [startDateLab release];
    [posLab release];
    [distanceLab release];
    [secondeLab release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setNoticeDic:(NSDictionary *) inviteDic  index:(NSInteger) index
{
    infoLab.text = [NSString stringWithFormat:@"%@ %@ %@", [inviteDic objectForKey:@"nickname"],
                    [inviteDic objectForKey:@"grade"],
                    [Student searchGenderName:[inviteDic objectForKey:@"gender"]]];
    
    NSString *totalMoney = [inviteDic objectForKey:@"tamount"];
    if (totalMoney.intValue==0)
    {
        moneyLab.text = @"金额师生协商";

    }
    else
    {
        moneyLab.text = [NSString stringWithFormat:@"￥%@", [inviteDic objectForKey:@"tamount"]];
    }

    timesLab.text = [NSString stringWithFormat:@"预计辅导小时数:%@", [inviteDic objectForKey:@"yjfdnum"]];
    
    startDateLab.text = [NSString stringWithFormat:@"开课日期:%@", [inviteDic objectForKey:@"sd"]];
    
    posLab.text = [NSString stringWithFormat:@"授课地址:%@", [inviteDic objectForKey:@"iaddress"]];
    
    //计算距离
    NSData *teacherData  = [[NSUserDefaults standardUserDefaults] valueForKey:TEACHER_INFO];
    Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    NSString *distLatitude = [inviteDic objectForKey:@"latitude"];
    NSString *distLongtitude = [inviteDic objectForKey:@"longitude"];
    
    CLLocation* orig=[[[CLLocation alloc] initWithLatitude:[teacher.latitude doubleValue]  longitude:[teacher.longitude doubleValue]] autorelease];
    CLLocation* dist=[[[CLLocation alloc] initWithLatitude:[distLatitude doubleValue] longitude:[distLongtitude doubleValue] ] autorelease];
    
    CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
    distanceLab.text = [NSString stringWithFormat:@"距离:%0.2fkm", kilometers];
    
    secondeLab.text = [NSString stringWithFormat:@"60"];
    
    NSString *audio = [inviteDic objectForKey:@"audio"];
    NSString *text  = [inviteDic objectForKey:@"otherText"];
    if ((audio.length!=0)||(text.length!=0))
    {
        audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *audioImg  = [UIImage imageNamed:@"mtp_audio_play_btn"];
        [audioBtn setImage:audioImg forState:UIControlStateNormal];
        [audioBtn addTarget:self
                     action:@selector(doAudioBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
        audioBtn.frame = CGRectMake(160-audioImg.size.width/2, 120-audioImg.size.height-2,
                                    audioImg.size.width, audioImg.size.height);
        [self addSubview:audioBtn];
    }
    
    noticeIndex = index;
    
    noticeDic = [inviteDic copy];
}

- (void) setTimer:(ThreadTimer *)tmpTimer
{
    timer = tmpTimer;
    timer.delegate = self;
}

#pragma mark -
#pragma mark - ThreadTimerDelegate
- (void) secondResponse:(ThreadTimer *)tmpTimer
{
    if (tmpTimer.totalSeconds == 0)
    {
        secondeLab.text = [NSString stringWithFormat:@"%lu", (long)tmpTimer.totalSeconds];
        //timeOut删除Notice cell.
        if (delegate)
        {
            if ([delegate respondsToSelector:@selector(timeOut:)])
            {
                [delegate timeOut:self];
            }
        }
        
        return;
    }
    secondeLab.text = [NSString stringWithFormat:@"%lu", (long)tmpTimer.totalSeconds];
}

#pragma mark -
#pragma mark - RecordAudioDelegate
-(void)RecordStatus:(int)status
{
    switch (status)
    {
        case 0:    //播放中
        {
            isPlay = YES;
            [audioBtn setImage:[UIImage imageNamed:@"mtp_audio_pause_btn"]
                      forState:UIControlStateNormal];
            break;
        }
        case 1:    //完成
        {
            isPlay = NO;
            [audioBtn setImage:[UIImage imageNamed:@"mtp_audio_play_btn"]
                      forState:UIControlStateNormal];
            break;
        }
        case 2:    //出错
        {
            isPlay = NO;
            [audioBtn setImage:[UIImage imageNamed:@"mtp_audio_play_btn"]
                      forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - Control Event
- (void) doAudioBtnClicked:(id)sender
{
    if (isPlay == YES)
    {
        //停止播放
        [audioPlay stopPlay];
        [audioPlay release];
        return;
    }
    
    NSString *audio = [noticeDic objectForKey:@"audio"];
    if (audio.length!=0)
    {
        [ChatViewController convertAmrToMp3:audio delegate:self];
    }
    else
    {
        NSString *otherTxt = [noticeDic objectForKey:@"otherText"];
        NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"text",@"mp3",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"speakUri",otherTxt,@"1", ssid, nil];
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
}

- (void) doButtonClicked:(id)sender
{
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(clickView:)])
        {
            [delegate clickView:self];
        }
    }
}

#pragma mark -
#pragma mark ServerRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //播放声音
    NSString *soundPath = [[ChatViewController getRecordURL] retain];
    NSData *soundData   = [NSData dataWithContentsOfFile:soundPath];
    
    audioPlay = [[RecordAudio alloc]init];
    audioPlay.delegate = self;
    [audioPlay playMP3:soundData];
}
@end
