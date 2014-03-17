//
//  OrderFinishViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-14.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFinishViewController : UIViewController<
                                                    UITextFieldDelegate,
                                                    UIGridViewDelegate,
                                                    MBProgressHUDDelegate,
                                                    UITableViewDelegate,
                                                    UITableViewDataSource,
                                                    ServerRequestDelegate>
{
    UIGridView    *finishOrderTab;
    UILabel       *payLab;
    UILabel       *backMoneyLab;
    
    MBProgressHUD *HUD;
    
    UITextField   *payFld;
    
    CGFloat       offset;
    UIButton *okBtn;
}

@property (nonatomic, copy) Order *order;
@end
