//
//  CompletePersonalInfoViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-2.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletePersonalInfoViewController : UIViewController<
                                                                ServerRequestDelegate,
                                                                UITableViewDelegate,
                                                                UITableViewDataSource,
                                                                UIActionSheetDelegate>
{
    UILabel    *nameValLab;
    UILabel    *sexValLab;
    UILabel    *subValLab;
    UILabel    *idNumLab;
    UILabel    *salaryLab;
    UILabel    *myInfoLab;
    UILabel    *uploadStatusLab;
    UILabel    *emailValLab;
    UILabel    *phoneValLab;
    UILabel    *setTimeStatusLab;
    BOOL       isSetTimeStatus;
    NSMutableArray *setTimeArray;
    
    UITableView *upTab;
    UIButton *finishBtn;
    
    NSString *headUrl;
}
@end
