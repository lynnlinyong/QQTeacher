//
//  MainViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTTSession.h"

typedef enum _tagPopInfoType {
    kWaitPopInfoType = 0,   //稍等
    kNoResponseType,        //未响应
    kFailedReponseType      //抢单失败
}PopInfoType;

@interface MainViewBottomInfoView : UIView
{
    UIImageView *bgView;
}
@end

@class MainViewPopInfoView;
@protocol MainViewPopInfoViewWaitDelegate <NSObject>

- (void) mainViewPopInfoWaitViewTimeOut:(MainViewPopInfoView *) view;

@end
@interface MainViewPopInfoView : UIView
{
    PopInfoType type;
    UIImageView *popInfoView;
    NSTimer *timer;
}
@property (nonatomic, assign) id<MainViewPopInfoViewWaitDelegate> delegate;
- (void) stopTimer;
- (id) initWithFrame:(CGRect)frame type:(PopInfoType) type;
@end

@interface MainViewController : UIViewController<
                                                MainViewPopInfoViewWaitDelegate,
                                                RecordAudioDelegate,
                                                InviteNoticeCellDelegate,
                                                WaitMaskViewDelegate,
                                                UITableViewDelegate,
                                                UITableViewDataSource,
                                                CustomNavigationDataSource,
                                                TeacherPropertyViewDelegate,
                                                ServerRequestDelegate,
                                                AMapSearchDelegate,
                                                MAMapViewDelegate>
{
    NSString        *appurl;
    NSMutableArray  *studentArray;
    NSMutableArray  *annArray;
    AMapSearchAPI   *search;
    CalloutMapAnnotation *_calloutMapAnnotation;
    CustomPointAnnotation *meAnn;
    UITableView     *noticeTab;
    CLLocation      *originPoint;
    
    MainViewPopInfoView *popInfoView;
    MainViewBottomInfoView *bottomView;
    
    BOOL  isLocation;
}

@property (nonatomic, retain) MAMapView *mapView;

+ (CustomNavigationViewController *) getNavigationViewController;

+ (void) getWebServerAddress;

+ (NSString *) getPort:(NSString *) str;

+ (void) setNavTitle:(NSString *) title;

+ (NSString *) getPushAddress:(NSString *) str;

- (void) addInviteNotice:(NSDictionary *)dic;
@end
