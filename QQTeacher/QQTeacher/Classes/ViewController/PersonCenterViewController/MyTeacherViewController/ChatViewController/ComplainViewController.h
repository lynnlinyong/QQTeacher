//
//  ComplainViewController.h
//  QQStudent
//
//  Created by lynn on 14-2-13.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplainViewController : UIViewController<
                                                    UITextFieldDelegate,
                                                    QRadioButtonDelegate,
                                                    ASIHTTPRequestDelegate,
                                                    UITableViewDelegate,
                                                    UITableViewDataSource>
{
    UITableView  *cmpTab;
    NSString     *titleRadioTitle;
    UITextField  *contentView;
}

@property (nonatomic, copy) Student *student;
@end
