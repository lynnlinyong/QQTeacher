//
//  UploadCertificateViewController.h
//  QQTeacher
//
//  Created by Lynn on 14-3-13.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadCertificateViewController : UIViewController<
                                                            UIScrollViewDelegate,
                                                            TTImageViewDelegate,
                                                            ServerRequestDelegate,
                                                            UIImagePickerControllerDelegate,
                                                            UINavigationControllerDelegate,
                                                            VPImageCropperDelegate>
{
    UILabel *indexLab;
    UIScrollView     *scrollView;
    NSMutableArray   *certyImgPathArray;
}

@property (nonatomic, copy) NSMutableArray *certyUrlArray;
@end
