//
//  OrderFinishViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-14.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFinishViewController : UIViewController<
                                                    MBProgressHUDDelegate,
                                                    UITableViewDelegate,
                                                    UITableViewDataSource,
                                                    ServerRequestDelegate>
{
    UITableView *finishOrderTab;
    UILabel     *payLab;
    UILabel     *backMoneyLab;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, copy) Order *order;
@end
