//
//  MainViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTTSession.h"

@interface MainViewController : UIViewController<
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
    
    BOOL  isLocation;
}

@property (nonatomic, retain) MAMapView *mapView;

+ (CustomNavigationViewController *) getNavigationViewController;

+ (void) getWebServerAddress;

+ (NSString *) getPort:(NSString *) str;

+ (void) setNavTitle:(NSString *) title;

+ (void) setNavBackButton:(UIViewController *) delegate parentVctr:(UIViewController *)parentVctr;

+ (NSString *) getPushAddress:(NSString *) str;

- (void) addInviteNotice:(NSDictionary *)dic;
@end
