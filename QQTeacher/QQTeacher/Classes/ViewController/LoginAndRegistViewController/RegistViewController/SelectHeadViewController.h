//
//  SelectHeadViewController.h
//  QQTeacher
//
//  Created by lynn on 14-3-10.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectHeadViewController : UIViewController<
                                                    UIImagePickerControllerDelegate,
                                                    UINavigationControllerDelegate,
                                                    VPImageCropperDelegate>
{
    UIImageView *headImageView;
}

@property (nonatomic, retain) NSString *headUrl;
@end
