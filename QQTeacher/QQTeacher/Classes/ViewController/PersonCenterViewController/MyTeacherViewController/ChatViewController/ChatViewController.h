//
//  ChatViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : JSMessagesViewController<
                                                        RecordAudioDelegate,
                                                        ASIHTTPRequestDelegate,
                                                        EGORefreshTableHeaderDelegate,
                                                        JSMessagesViewDelegate,
                                                        JSMessagesViewDataSource,CustomNavigationDataSource>
{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    RecordAudio *recordAudio;
    
    LBorderView *infoView;
    
    UILabel     *listenLab;
    UIView      *listenView;
    UISwitch    *listenSwitch;
    BOOL isNewData;
    RecordAudio *audio;
}
@property (nonatomic, assign) BOOL     isFromSearchCondition;
@property (nonatomic, copy)   Order    *order;
@property (nonatomic, copy)   Student  *student;
//@property (nonatomic, retain) UIButton *listenBtn;
//@property (nonatomic, retain) UIButton *employBtn;
@property (retain, nonatomic) NSMutableArray   *messages;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

+ (NSString *) getRecordURL;
+ (void) convertAmrToMp3:(NSString *)audioURL delegate:(id<RecordAudioDelegate>) delegate;
@end
