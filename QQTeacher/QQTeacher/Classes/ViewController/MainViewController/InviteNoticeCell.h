//
//  InviteNoticeCell.h
//  QQTeacher
//
//  Created by Lynn on 14-3-18.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InviteNoticeCell;
@protocol InviteNoticeCellDelegate <NSObject>
- (void) timeOut:(InviteNoticeCell *) cell;
- (void) clickView:(InviteNoticeCell *) cell;
@end

@interface InviteNoticeCell : UITableViewCell <ThreadTimerDelegate,RecordAudioDelegate>
{
    UILabel *infoLab;
    UILabel *moneyLab;
    UILabel *timesLab;
    UILabel *startDateLab;
    UILabel *posLab;
    UILabel *distanceLab;
    UILabel *secondeLab;
    UIButton *confirmBtn;
    
    NSUInteger noticeIndex;
    
    ThreadTimer *timer;
    
    BOOL isPlay;
    UIButton *audioBtn;
    RecordAudio *audioPlay;
}

@property (nonatomic, copy) NSDictionary *noticeDic;
@property (nonatomic, assign) NSUInteger noticeIndex;
@property (nonatomic, retain) ThreadTimer *timer;
@property (nonatomic, assign) id<InviteNoticeCellDelegate> delegate;
- (void) setNoticeDic:(NSDictionary *) inviteDic  index:(NSInteger) index;
@end
