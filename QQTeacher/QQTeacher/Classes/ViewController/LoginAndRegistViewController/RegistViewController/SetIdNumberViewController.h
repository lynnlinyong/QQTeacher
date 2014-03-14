//
//  SetIdNumberViewController.h
//  QQTeacher
//
//  Created by lynn on 14-3-9.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetIdNumberViewController : UIViewController<UITextFieldDelegate>
{
    UITextField   *idNumsFld;
    UIButton *okBtn;
    float originY;
}

@property (nonatomic, retain) NSString *idNums;
@end
