//
//  SetTimePeriodViewController.h
//  QQTeacher
//
//  Created by Lynn on 14-3-12.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTimePeriodViewController : UIViewController <UIGridViewDelegate>
{
    UIGridView     *gdView;
}

@property (nonatomic, retain) NSMutableArray *setTimesArray;
@end
