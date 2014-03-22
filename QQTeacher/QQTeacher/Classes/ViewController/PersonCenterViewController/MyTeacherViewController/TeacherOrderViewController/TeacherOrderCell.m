//
//  TeacherOrderCell.m
//  QQStudent
//
//  Created by lynn on 14-2-12.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "TeacherOrderCell.h"

@implementation TeacherOrderCell
@synthesize order;
@synthesize delegate;
//@synthesize commentBtn;
//@synthesize commView;

- (void) dealloc
{
    [studyPosLab         release];
    [orderStudyTimeLab   release];
    [orderSalaryLab      release];
    [orderTotalMoneyLab  release];
    [orderPayMoneyLab    release];
    [orderCommentLab     release];
    [commentImgView release];
    
    [orderDateLab   release];
    [bgLabImageView release];
//    [noConfirmLab   release];
    [finishLab      release];
    [spImgView release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withParent:(UIView *) pView
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#686868"];
        self.backgroundView  = bgView;
        
        parentView = pView;
        studyPosLab = [[UILabel alloc]init];
        studyPosLab.textColor       = [UIColor whiteColor];
        studyPosLab.font  = [UIFont systemFontOfSize:12.f];
        studyPosLab.frame = CGRectMake(10, 5, 200, 20);
        studyPosLab.numberOfLines   = 0;
        studyPosLab.backgroundColor = [UIColor clearColor];
        [self addSubview:studyPosLab];
        
        orderStudyTimeLab = [[UILabel alloc]init];
        orderStudyTimeLab.textColor       = [UIColor whiteColor];
        orderStudyTimeLab.font  = [UIFont systemFontOfSize:12.f];
        orderStudyTimeLab.frame = CGRectMake(10, 25, 200, 20);
        orderStudyTimeLab.backgroundColor = [UIColor clearColor];
        [self addSubview:orderStudyTimeLab];
        
        orderSalaryLab = [[UILabel alloc]init];
        orderSalaryLab.textColor       = [UIColor whiteColor];
        orderSalaryLab.font  = [UIFont systemFontOfSize:12.f];
        orderSalaryLab.frame = CGRectMake(10, 45, 200, 20);
        orderSalaryLab.backgroundColor = [UIColor clearColor];
        [self addSubview:orderSalaryLab];
        
        orderTotalMoneyLab = [[UILabel alloc]init];
        orderTotalMoneyLab.textColor       = [UIColor whiteColor];
        orderTotalMoneyLab.font  = [UIFont systemFontOfSize:12.f];
        orderTotalMoneyLab.frame = CGRectMake(10, 65, 200, 20);
        orderTotalMoneyLab.backgroundColor = [UIColor clearColor];
        [self addSubview:orderTotalMoneyLab];
        
        orderPayMoneyLab = [[UILabel alloc]init];
        orderPayMoneyLab.textColor       = [UIColor whiteColor];
        orderPayMoneyLab.font  = [UIFont systemFontOfSize:12.f];
        orderPayMoneyLab.frame = CGRectMake(10, 65, 200, 20);
        orderPayMoneyLab.backgroundColor = [UIColor clearColor];
        [self addSubview:orderPayMoneyLab];
        
        orderCommentLab = [[UILabel alloc]init];
        orderCommentLab.textColor       = [UIColor whiteColor];
        orderCommentLab.font  = [UIFont systemFontOfSize:12.f];
        orderCommentLab.frame = CGRectMake(10, 85, 200, 20);
        orderCommentLab.backgroundColor = [UIColor clearColor];
        [self addSubview:orderCommentLab];
        
        commentImgView = [[UIImageView alloc]init];
        commentImgView.frame = CGRectMake(75, 85, 20, 20);
        [self addSubview:commentImgView];
        
        UIImage *spImg = [UIImage imageNamed:@"mtp_order_splite_line"];
        spImgView = [[UIImageView alloc]init];
        spImgView.image = spImg;
        spImgView.frame = CGRectMake(0, 105,
                                     320, spImg.size.height);
        [self addSubview:spImgView];
        
        orderDateLab = [[UILabel alloc]init];
        orderDateLab.font  = [UIFont systemFontOfSize:12.f];
        orderDateLab.frame = CGRectMake(210, 5, 100, 20);
        orderDateLab.textColor       = [UIColor whiteColor];
        orderDateLab.textAlignment   = NSTextAlignmentCenter;
        orderDateLab.backgroundColor = [UIColor clearColor];
        [self addSubview:orderDateLab];
        
        UIImage *bgImg = [UIImage imageNamed:@"spp_order_status_bg"];
//        noConfirmLab = [[UILabel alloc]init];
//        noConfirmLab.font  = [UIFont systemFontOfSize:12.f];
//        noConfirmLab.frame = CGRectMake(210, 25, bgImg.size.width, bgImg.size.width);
//        noConfirmLab.textColor       = [UIColor whiteColor];
//        noConfirmLab.backgroundColor = [UIColor clearColor];
//        [self addSubview:noConfirmLab];
        
        finishLab = [[UILabel alloc]init];
        finishLab.textColor       = [UIColor whiteColor];
        finishLab.textAlignment = NSTextAlignmentCenter;
        finishLab.font  = [UIFont systemFontOfSize:12.f];
        finishLab.frame = CGRectMake(0, 0, bgImg.size.width, bgImg.size.height);
        finishLab.backgroundColor = [UIColor clearColor];
        
        bgLabImageView = [[UIImageView alloc]init];
        bgLabImageView.image = bgImg;
        bgLabImageView.frame = CGRectMake(230, 30, bgImg.size.width, bgImg.size.height);
        [bgLabImageView addSubview:finishLab];
        [self addSubview:bgLabImageView];
        
        ctrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ctrBtn.tag = 0;
        [ctrBtn setBackgroundImage:[UIImage imageNamed:@"normal_btn"]
                          forState:UIControlStateNormal];
        [ctrBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                          forState:UIControlStateHighlighted];
        [ctrBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"] forState:UIControlStateNormal];
        ctrBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        ctrBtn.frame = CGRectMake(230+2, 30+bgImg.size.height+25, bgImg.size.width-4, bgImg.size.height);
        [ctrBtn addTarget:self
                   action:@selector(doButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ctrBtn];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doGetCommentNotice:)
                                                     name:@"commentOrderNotice"
                                                   object:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) setStudyPos:(NSString *) pos
{
    CGSize size = [pos sizeWithFont:studyPosLab.font constrainedToSize:CGSizeMake(studyPosLab.frame.size.width, MAXFLOAT)
                      lineBreakMode:NSLineBreakByWordWrapping];
    
    int offset = size.height - studyPosLab.frame.size.height;
    
    //根据计算结果重新设置UILabel的尺寸
    [studyPosLab setFrame:CGRectMake(studyPosLab.frame.origin.x,
                                     studyPosLab.frame.origin.y,
                                     studyPosLab.frame.size.width,
                                     size.height)];
    studyPosLab.text = pos;
    
    //其他控件根据上面位置进行调整
    orderStudyTimeLab.frame = CGRectMake(orderStudyTimeLab.frame.origin.x,
                                    orderStudyTimeLab.frame.origin.y+offset,
                                    orderStudyTimeLab.frame.size.width,
                                    orderStudyTimeLab.frame.size.height);
    
    orderSalaryLab.frame = CGRectMake(orderSalaryLab.frame.origin.x,
                                      orderSalaryLab.frame.origin.y+offset,
                                      orderSalaryLab.frame.size.width,
                                      orderSalaryLab.frame.size.height);
    
    orderTotalMoneyLab.frame = CGRectMake(orderTotalMoneyLab.frame.origin.x,
                                          orderTotalMoneyLab.frame.origin.y+offset,
                                          orderTotalMoneyLab.frame.size.width,
                                          orderTotalMoneyLab.frame.size.height);
    
    orderPayMoneyLab.frame = CGRectMake(orderPayMoneyLab.frame.origin.x,
                                        orderPayMoneyLab.frame.origin.y+offset,
                                        orderPayMoneyLab.frame.size.width,
                                        orderPayMoneyLab.frame.size.height);
    
    orderCommentLab.frame = CGRectMake(orderCommentLab.frame.origin.x,
                                        orderCommentLab.frame.origin.y+offset,
                                        orderCommentLab.frame.size.width,
                                        orderCommentLab.frame.size.height);
    
    bgLabImageView.frame = CGRectMake(bgLabImageView.frame.origin.x,
                                 bgLabImageView.frame.origin.y+offset,
                                 bgLabImageView.frame.size.width,
                                 bgLabImageView.frame.size.height);
    
    commentImgView.frame = CGRectMake(commentImgView.frame.origin.x,
                                      commentImgView.frame.origin.y+offset,
                                      commentImgView.frame.size.width,
                                      commentImgView.frame.size.height);
    
    spImgView.frame = CGRectMake(spImgView.frame.origin.x,
                                 spImgView.frame.origin.y+offset,
                                 spImgView.frame.size.width,
                                 spImgView.frame.size.height);
    
    ctrBtn.frame = CGRectMake(ctrBtn.frame.origin.x,
                              ctrBtn.frame.origin.y+offset,
                              ctrBtn.frame.size.width,
                              ctrBtn.frame.size.height);


//    commentBtn.frame = CGRectMake(commentBtn.frame.origin.x,
//                                  commentBtn.frame.origin.y+offset,
//                                  commentBtn.frame.size.width,
//                                  commentBtn.frame.size.height);
    
//    updateBtn.frame  = CGRectMake(updateBtn.frame.origin.x,
//                                  updateBtn.frame.origin.y+offset,
//                                  updateBtn.frame.size.width,
//                                  updateBtn.frame.size.height);
//    
//    freeBtn.frame    = CGRectMake(freeBtn.frame.origin.x,
//                               freeBtn.frame.origin.y+offset,
//                               freeBtn.frame.size.width,
//                               freeBtn.frame.size.height);
//    
//    finishBtn.frame  = CGRectMake(finishBtn.frame.origin.x,
//                                 finishBtn.frame.origin.y+offset,
//                                 finishBtn.frame.size.width,
//                                 finishBtn.frame.size.height);
    
    //cell高度调整
}

- (void) setAutoPosForButton:(BOOL) isAuto
{
//    //自动缩进按钮
//    if (buttonArray)
//    {
//        for (int i=0; i<buttonArray.count; i++)
//        {
//            UIButton *btn = [buttonArray objectAtIndex:i];
//            if (btn.hidden)
//            {
//                CGRect preRect = btn.frame;
//                CGRect curRect;
//                for (int j=i+1; j<buttonArray.count; j++)
//                {
//                    UIButton *nextBtn = [buttonArray objectAtIndex:j];
//                    curRect = nextBtn.frame;
//                    nextBtn.frame = CGRectMake(preRect.origin.x,
//                                               nextBtn.frame.origin.y, nextBtn.frame.size.width, nextBtn.frame.size.height);
//                    preRect = curRect;
//                }
//            }
//        }
//    }
}

- (void) setOrder:(Order *)orderObj
{
    order = nil;
    order = [orderObj copy];
    
    //显示内容
    [self setStudyPos:self.order.orderStudyPos];
    
    orderDateLab.text = self.order.orderAddTimes;
    orderStudyTimeLab.text = [NSString stringWithFormat:@"预计辅导小时数:%@小时", self.order.orderStudyTimes];
    
    if (self.order.everyTimesMoney.intValue==0)
        orderSalaryLab.text = @"课酬标准:师生协商";
    else
        orderSalaryLab.text = [NSString stringWithFormat:@"课酬标准:￥%@/小时", self.order.everyTimesMoney];
    
    
    NSString *totalMoney = [NSString stringWithFormat:@"总金额:￥%@", self.order.totalMoney];
    CGSize size = [totalMoney sizeWithFont:orderTotalMoneyLab.font
                         constrainedToSize:CGSizeMake(orderTotalMoneyLab.frame.size.width, MAXFLOAT)
                      lineBreakMode:NSLineBreakByWordWrapping];
    orderTotalMoneyLab.frame  = CGRectMake(orderTotalMoneyLab.frame.origin.x, orderTotalMoneyLab.frame.origin.y, size.width,
                                         orderTotalMoneyLab.frame.size.height);
    orderTotalMoneyLab.text = totalMoney;
    
    
    orderPayMoneyLab.frame = CGRectMake(orderTotalMoneyLab.frame.origin.x+size.width+5, orderPayMoneyLab.frame.origin.y, size.width+50,
                                        orderPayMoneyLab.frame.size.height);
    orderPayMoneyLab.text = [NSString stringWithFormat:@"消费金额:￥%@", self.order.payMoney];
    
    
    if (self.order.commentAddTimes.intValue == 0)
    {
        orderCommentLab.text  = @"给我的评价:未评价";
        commentImgView.hidden = YES;
    }
    else
    {
        orderCommentLab.text  = @"给我的评价:";
        commentImgView.hidden = NO;
        
        if (self.order.orderCommentStatus==1)
            commentImgView.image = [UIImage imageNamed:@"tdp_good_comment"];
        else
            commentImgView.image = [UIImage imageNamed:@"tdp_bad_comment"];
    }
    CLog(@"orderStatus:%d", order.orderStatus);
    switch (order.orderStatus)
    {
        case NO_EMPLOY:         //未聘用
        {
            //不显示订单
            break;
        }
        case NO_CONFIRM:         //未确认
        {
            //评价老师,修改订单按钮显示
            finishLab.text = @"未确认";
            [ctrBtn setTitle:@"去确认"
                    forState:UIControlStateNormal];
            orderPayMoneyLab.hidden = YES;
            break;
        }
        case CONFIRMED:         //已确认
        {
            finishLab.text = @"未结单";
            orderPayMoneyLab.hidden = YES;
            [ctrBtn setTitle:@"去结单"
                    forState:UIControlStateNormal];
            break;
        }
        case NO_FINISH:         //未结单
        {
            finishLab.font = [UIFont systemFontOfSize:11.f];
            finishLab.text = @"已申请结单";
            orderPayMoneyLab.hidden = YES;
            ctrBtn.hidden  = YES;
            break;
        }
        case FINISH:           //已结单
        {
            finishLab.text    = @"已结单";
            ctrBtn.hidden = YES;
            orderPayMoneyLab.hidden = NO;
            break;
        }
        default:
            break;
    }
    
    //自动缩进按钮
    [self setAutoPosForButton:YES];
}

#pragma mark -
#pragma mark - Custom Action
- (void) doGetCommentNotice:(NSNotification *) notice
{
    NSString *orderId = [notice.userInfo objectForKey:@"OrderID"];
    if ([orderId isEqualToString:order.orderId])
    {
//        commView.hidden   = YES;
//        commentBtn.hidden = YES;
        [self setAutoPosForButton:NO];   //手动评价后缩进
    }
}

- (void) doButtonClicked:(id)sender
{
    UIButton *btn = sender;
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(cell:buttonTag:)])
        {
            [delegate cell:self buttonTag:btn.tag];
        }
    }
}

#pragma mark -
#pragma mark - Touch Event
- (void) tapGesture:(UIGestureRecognizer *) gesture
{
    NSDictionary *tagDic = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"TAG", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentViewNoticeDismiss"
                                                        object:self
                                                      userInfo:tagDic];
}
@end
