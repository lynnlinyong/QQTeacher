//
//  SetPersonalInfoViewController.h
//  QQTeacher
//
//  Created by lynn on 14-3-9.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPersonalInfoViewController : UIViewController<UITextViewDelegate>
{
    UIButton *okBtn;
    int      originY;
}

@property (nonatomic, retain) NSString *contentInfo;
@end
