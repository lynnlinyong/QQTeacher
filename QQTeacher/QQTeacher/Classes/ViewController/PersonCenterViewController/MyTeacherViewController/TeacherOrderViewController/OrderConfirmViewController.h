//
//  OrderConfirmViewController.h
//  QQTeacher
//
//  Created by Lynn on 14-3-16.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConfirmViewController : UIViewController<UIGridViewDelegate>
{
    UIGridView *gdView;
}

@property (nonatomic, copy) Order *order;
@end
