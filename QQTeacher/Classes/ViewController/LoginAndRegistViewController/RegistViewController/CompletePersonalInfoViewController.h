//
//  CompletePersonalInfoViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-2.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletePersonalInfoViewController : UIViewController<
ServerRequestDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UILabel    *nameValLab;
    UILabel    *sexValLab;
    UILabel    *subValLab;
    UILabel    *idNumLab;
    UILabel    *salaryLab;
    UILabel    *myInfoLab;
    
    
    UITableView *upTab;
    UIButton *finishBtn;
}

@end
