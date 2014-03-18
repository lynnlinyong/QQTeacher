//
//  SettingViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _tagUpdateType
{
    EmailUpdate=0,
    PhoneUpdate,
    OtherUpdate
}UpdateType;

@interface SettingViewController : UIViewController<
                                                    TTImageViewDelegate,
                                                    ServerRequestDelegate,
                                                    UITableViewDataSource,
                                                    UITableViewDelegate,
                                                    CustomNavigationDataSource>
{
    UITableView   *setTab;
    
    UISwitch      *phoneSw;
    UISwitch      *locSw;
    UISwitch      *listenSw;
    
    UILabel       *emailValLab;
    UILabel       *phoneValLab;
    UILabel       *gradeValLab;
    UILabel       *accountValLab;
    UILabel       *salaryValLab;
    UILabel       *infoValue;
    UILabel *assitentLab;
    NoticeNumberView *numView;
    NSDictionary  *ccResDic;
    
    Teacher       *teacher;
    NSString      *headUrl;
    
    BOOL       isSetTimeStatus;
    NSMutableArray *setTimeArray;
    TTImageView   *headImgView;
    
    UpdateType    updateType;
}

@end
