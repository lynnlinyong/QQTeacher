//
//  WaitMaskView.m
//  QQStudent
//
//  Created by lynn on 14-3-7.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "WaitMaskView.h"

@implementation WaitMaskView
@synthesize userDic;
@synthesize second;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        mainView = [[UIView alloc]init];
        mainView.alpha = 0.7f;
        mainView.frame = [UIScreen getCurrentBounds];
        mainView.backgroundColor = [UIColor grayColor];
        [self addSubview:mainView];
        
        //top
        bgView = [[LBorderView alloc]init];
        bgView.borderWidth  = 1.f;
        bgView.cornerRadius = 3.f;
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.7f;
        bgView.frame = CGRectMake(20, 150, 280, 150);
        [self addSubview:bgView];
        
//        headImgView = [[TTImageView alloc]init];
//        headImgView.delegate = self;
//        headImgView.frame = CGRectMake(40, 160, 60, 60);
//        [self addSubview:headImgView];
        
//        starImgView = [[UIStartsImageView alloc]initWithFrame:CGRectMake(30, 230, 80, 5)];
//        [self addSubview:starImgView];
        nameLab = [[UILabel alloc]init];
        nameLab.font  = [UIFont systemFontOfSize:14.f];
        nameLab.frame = CGRectMake(25, 150+5, 100, 20);
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.textColor = [UIColor whiteColor];
        [self addSubview:nameLab];
        
        totalMoneyLab = [[UILabel alloc]init];
        totalMoneyLab.font  = [UIFont systemFontOfSize:14.f];
        totalMoneyLab.frame = CGRectMake(125, 150+5, 270, 20);
        totalMoneyLab.backgroundColor = [UIColor clearColor];
        totalMoneyLab.textColor = [UIColor whiteColor];
        [self addSubview:totalMoneyLab];
        
        gradeLab = [[UILabel alloc]init];
        gradeLab.font  = [UIFont systemFontOfSize:14.f];
        gradeLab.frame = CGRectMake(25, 150+25, 270, 20);
        gradeLab.backgroundColor = [UIColor clearColor];
        gradeLab.textColor = [UIColor whiteColor];
        [self addSubview:gradeLab];
        
        startDateLab = [[UILabel alloc]init];
        startDateLab.font  = [UIFont systemFontOfSize:14.f];
        startDateLab.frame = CGRectMake(25, 150+45, 270, 20);
        startDateLab.backgroundColor = [UIColor clearColor];
        startDateLab.textColor = [UIColor whiteColor];
        [self addSubview:startDateLab];
        
        posLab = [[UILabel alloc]init];
        posLab.font  = [UIFont systemFontOfSize:14.f];
        posLab.frame = CGRectMake(25, 150+65, 270, 20);
        posLab.backgroundColor = [UIColor clearColor];
        posLab.textColor = [UIColor whiteColor];
        [self addSubview:posLab];
        
        secondLab = [[UILabel alloc]init];
        secondLab.text  = @"正在等待和老师建立沟通...3";
        secondLab.font  = [UIFont systemFontOfSize:14.f];
        secondLab.frame = CGRectMake(90, 280-10, 180, 20);
        secondLab.backgroundColor = [UIColor clearColor];
        secondLab.textColor = [UIColor whiteColor];
        [self addSubview:secondLab];
        
        //bottom
        UIImage *hImg  = [UIImage imageNamed:@"stmp_sinfo_head"];
        sayHeadImgView = [[UIImageView alloc]init];
        sayHeadImgView.image = hImg;
        sayHeadImgView.frame = CGRectMake(20, 330, hImg.size.width, hImg.size.height);
        [self addSubview:sayHeadImgView];
        
        UIImage *bgInfoImg = [UIImage imageNamed:@"stmp_search_info_bg"];
        infoBgView = [[UIImageView alloc]init];
        infoBgView.image = bgInfoImg;
        infoBgView.frame = CGRectMake(60, 310, bgInfoImg.size.width, bgInfoImg.size.height);
        [self addSubview:infoBgView];
        
        infoSecondLab = [[UILabel alloc]init];
        infoSecondLab.backgroundColor = [UIColor clearColor];
        infoSecondLab.font = [UIFont systemFontOfSize:14.f];
        infoSecondLab.text = @"只用了4秒就找到了一个家教老师,太给力了吧!";
        infoSecondLab.frame= CGRectMake(15, 5, bgInfoImg.size.width-15, 20);
        infoSecondLab.numberOfLines = 0;
        infoSecondLab.lineBreakMode = NSLineBreakByWordWrapping;
        infoSecondLab.backgroundColor = [UIColor clearColor];
        [infoBgView addSubview:infoSecondLab];
        
        UIImage *btnImg = [UIImage imageNamed:@"stmp_send_btn"];
        sendFrdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendFrdBtn setImage:btnImg
                    forState:UIControlStateNormal];
        sendFrdBtn.frame = CGRectMake(infoBgView.frame.origin.x+bgInfoImg.size.width-10-btnImg.size.width,
                                      infoBgView.frame.origin.y+bgInfoImg.size.height-10-btnImg.size.height,
                                      btnImg.size.width, btnImg.size.height);
        [sendFrdBtn addTarget:self
                       action:@selector(shareFriend:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendFrdBtn];
        
        curSecond = 3;
        timer  = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(timeOut)
                                               userInfo:nil
                                                repeats:YES];
        [timer fire];
        
        userDic = [[NSDictionary alloc]init];
    }
    return self;
}

- (void) dealloc
{
    [timer invalidate];
    timer = nil;
    
    [userDic release];
    
    delegate = nil;
    
    [mainView      release];
    [bgView        release];
    [nameLab       release];
    [gradeLab      release];
    [totalMoneyLab release];
    [posLab release];
    [startDateLab release];
    
    [sayHeadImgView release];
    [infoBgView release];
    [infoSecondLab release];
    [super dealloc];
}

- (void) setUserDic:(NSDictionary *)dic
{
    [userDic release];
    userDic = nil;
    
    userDic = [dic copy];
    NSDictionary *inviteDic = [userDic objectForKey:@"inviteDic"];
    
    nameLab.text = [inviteDic objectForKey:@"nickname"];
    
    NSString *totalMoney = [inviteDic objectForKey:@"tamount"];
    if (totalMoney.intValue==0)
        totalMoneyLab.text = @"金额师生协商";
    else
        totalMoneyLab.text = [NSString stringWithFormat:@"￥%@", [inviteDic objectForKey:@"tamount"]];
    
    gradeLab.text = [inviteDic objectForKey:@"grade"];
    
    startDateLab.text = [NSString stringWithFormat:@"开课时间:%@",[inviteDic objectForKey:@"sd"]];
    
    posLab.text = [NSString stringWithFormat:@"授课地址:%@",[inviteDic objectForKey:@"iaddress"]];
    
    NSString *secondStr = [NSString stringWithFormat:@"只用了%@秒就找到了个家教老师,太给力了吧!", second];
    CGSize size = [secondStr sizeWithFont:infoSecondLab.font constrainedToSize:CGSizeMake(infoSecondLab.frame.size.width, MAXFLOAT)
                            lineBreakMode:NSLineBreakByWordWrapping];
    infoSecondLab.text  = secondStr;
    infoSecondLab.frame = CGRectMake(infoSecondLab.frame.origin.x, infoSecondLab.frame.origin.y, size.width, size.height);
    
    //自适应
//    [self setAutoSayContent];
}

//- (void) setAutoSayContent
//{
//    float offset = 0;
//    CGSize size = [tObj.info sizeWithFont:sayLab.font constrainedToSize:CGSizeMake(sayLab.frame.size.width, MAXFLOAT)
//                            lineBreakMode:NSLineBreakByWordWrapping];
//    if (size.height>sayImgView.frame.size.height)
//    {
//        offset = size.height - sayImgView.frame.size.height+5;
//    }
//    sayLab.frame = CGRectMake(sayLab.frame.origin.x, sayLab.frame.origin.y+offset/5, size.width, size.height);
//    sayImgView.frame = CGRectMake(sayImgView.frame.origin.x, sayImgView.frame.origin.y,
//                                  sayImgView.frame.size.width, sayImgView.frame.size.height+offset);
//    
//    secondLab.frame  = CGRectMake(secondLab.frame.origin.x,   secondLab.frame.origin.y+offset,
//                                  secondLab.frame.size.width, secondLab.frame.size.height);
//    
//    float sayLabPos = sayImgView.frame.origin.y+sayImgView.frame.size.height;
//    float bgViewPos = bgView.frame.origin.y+bgView.frame.size.height;
//    if (sayLabPos>bgViewPos)
//    {
//        offset = sayLabPos - bgViewPos;
//        bgView.frame = CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y,
//                                  bgView.frame.size.width, bgView.frame.size.height+offset);
//        
//        
//        sayHeadImgView.frame = CGRectMake(sayHeadImgView.frame.origin.x, sayHeadImgView.frame.origin.y+offset,
//                                          sayHeadImgView.frame.size.width, sayHeadImgView.frame.size.height);
//        infoBgView.frame  = CGRectMake(infoBgView.frame.origin.x, infoBgView.frame.origin.y+offset,
//                                       infoBgView.frame.size.width, infoBgView.frame.size.height);
//    }
//}

- (void)timeOut
{
    curSecond--;
    if (curSecond==0)
    {
        secondLab.text  = @"正在等待和老师建立沟通...0";
        if (delegate)
        {
            if ([delegate respondsToSelector:@selector(timeOutView:)])
                [delegate timeOutView:self];
        }
        
        [timer invalidate];
        timer = nil;
    }
    else
    {
        secondLab.text  = [NSString stringWithFormat:@"正在等待和老师建立沟通...%d", curSecond];
    }
}

- (void) shareFriend:(id)sender
{
    [timer invalidate];
    timer = nil;
    CLog(@"shareFriendClicked:");
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(shareClicked:)])
            [delegate shareClicked:self];
    }
}
@end
