//
//  UploadCertificateViewController.m
//  QQTeacher
//
//  Created by Lynn on 14-3-13.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import "UploadCertificateViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface UploadCertificateViewController ()

@end

@implementation UploadCertificateViewController
@synthesize certyUrlArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"资质证书"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [indexLab release];
    [scrollView release];
    [certyImgPathArray release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) showCertificate
{
    if (certyImgPathArray.count == 0)
    {
        NSArray *imgViewArray = scrollView.subviews;
        for (UIView *imgView in imgViewArray)
        {
            if ([imgView isKindOfClass:[UIImageView class]])
            {
                [imgView removeFromSuperview];
            }
        }
    }
    
    for (int i=0; i<certyImgPathArray.count; i++)
    {
        scrollView.contentSize = CGSizeMake(320*(i+1), 320);
        
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd, [certyImgPathArray objectAtIndex:i]];
        
        UIImageView *imgView = [[UIImageView alloc]init];
        [imgView setImageWithURL:[NSURL URLWithString:url]
                placeholderImage:[UIImage imageNamed:@"s_boy"]];
        imgView.frame = CGRectMake(320*i+160-320/2,
                                   scrollView.frame.size.height-320,
                                   320, 320);
        [scrollView addSubview:imgView];
    }
    
    indexLab.text = [NSString stringWithFormat:@"%d/%d", certyImgPathArray.count,certyImgPathArray.count];
    
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 320*certyImgPathArray.count, 320) animated:YES];
}

- (void) initUI
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    
    UIImage *cmpImg  = [UIImage imageNamed:@"sp_share_btn_normal"];
    UIButton *cmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cmpBtn.tag = 0;
    [cmpBtn setTitle:@"完成"
              forState:UIControlStateNormal];
    cmpBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [cmpBtn setBackgroundImage:cmpImg
                        forState:UIControlStateNormal];
    [cmpBtn setBackgroundImage:[UIImage imageNamed:@"sp_share_btn_hlight"]
                        forState:UIControlStateHighlighted];
    cmpBtn.frame = CGRectMake(0, 0,
                                cmpImg.size.width-10,
                                cmpImg.size.height-5);
    [cmpBtn addTarget:self
                 action:@selector(doButtonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cmpBtn];
    
    indexLab = [[UILabel alloc]init];
    indexLab.backgroundColor = [UIColor clearColor];
    indexLab.font = [UIFont systemFontOfSize:14.f];
    indexLab.text = @"0/0";
    indexLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
    indexLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:indexLab];
    
    certyImgPathArray = [[NSMutableArray alloc]init];
    if (![certyUrlArray isEqual:[NSNull null]])
        certyImgPathArray = [certyUrlArray mutableCopy];
    
    //底部操作按钮
    UIImage *cameraImg = [UIImage imageNamed:@"stp_cert_camera_btn"];
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.tag = 1;
    [cameraBtn setImage:cameraImg forState:UIControlStateNormal];
    
    [cameraBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    
    UIImage *photoImg  = [UIImage imageNamed:@"stp_cert_photo_btn"];
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.tag = 2;
    [photoBtn setImage:photoImg forState:UIControlStateNormal];

    [photoBtn addTarget:self
                 action:@selector(doButtonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
    UIImage *delImg = [UIImage imageNamed:@"stp_cert_del_btn"];
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.tag = 3;
    [deleteBtn setImage:delImg forState:UIControlStateNormal];
    [deleteBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            indexLab.frame= [UIView fitCGRect:CGRectMake(120, 10+44+20, 80, 20)
                                   isBackView:NO];
            scrollView.frame = [UIView fitCGRect:CGRectMake(0, 44+20+10+30, 320, 320)
                                      isBackView:NO];
            cameraBtn.frame = [UIView fitCGRect:CGRectMake(100, 480-30-20-cameraImg.size.height,
                                                           cameraImg.size.width, cameraImg.size.height)
                                     isBackView:NO];
            photoBtn.frame = [UIView fitCGRect:CGRectMake(100+cameraImg.size.width, 480-30-20-cameraImg.size.height,
                                                          photoImg.size.width, photoImg.size.height)
                                    isBackView:NO];
            deleteBtn.frame = [UIView fitCGRect:CGRectMake(100+cameraImg.size.width+photoImg.size.width,
                                                           480-30-20-cameraImg.size.height, delImg.size.width, delImg.size.height)
                                     isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            indexLab.frame= [UIView fitCGRect:CGRectMake(120, 10+44+20, 80, 20)
                                   isBackView:NO];
            scrollView.frame = [UIView fitCGRect:CGRectMake(0, 44+20+10+30, 320, 320)
                                      isBackView:NO];
            cameraBtn.frame = [UIView fitCGRect:CGRectMake(100, 480-30-20-cameraImg.size.height,
                                                           cameraImg.size.width, cameraImg.size.height)
                                     isBackView:NO];
            photoBtn.frame = [UIView fitCGRect:CGRectMake(100+cameraImg.size.width, 480-30-20-cameraImg.size.height,
                                                          photoImg.size.width, photoImg.size.height)
                                    isBackView:NO];
            deleteBtn.frame = [UIView fitCGRect:CGRectMake(100+cameraImg.size.width+photoImg.size.width,
                                                           480-30-20-cameraImg.size.height, delImg.size.width, delImg.size.height)
                                     isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            indexLab.frame= [UIView fitCGRect:CGRectMake(120, 10, 80, 20)
                                   isBackView:NO];
            scrollView.frame = [UIView fitCGRect:CGRectMake(0, 40, 320, 320) isBackView:NO];
            cameraBtn.frame = [UIView fitCGRect:CGRectMake(100, 480-44-20-cameraImg.size.height,
                                                           cameraImg.size.width, cameraImg.size.height)
                                     isBackView:NO];
            photoBtn.frame = [UIView fitCGRect:CGRectMake(100+cameraImg.size.width, 480-44-20-cameraImg.size.height,
                                                          photoImg.size.width, photoImg.size.height)
                                    isBackView:NO];
            deleteBtn.frame = [UIView fitCGRect:CGRectMake(100+cameraImg.size.width+photoImg.size.width,
                                                           480-44-20-cameraImg.size.height, delImg.size.width, delImg.size.height)
                                     isBackView:NO];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            indexLab.frame= [UIView fitCGRect:CGRectMake(120, 10, 80, 20)
                                   isBackView:NO];
            scrollView.frame = [UIView fitCGRect:CGRectMake(0, 40, 320, 320) isBackView:NO];
            cameraBtn.frame = [UIView fitCGRect:CGRectMake(100, 480-44-20-cameraImg.size.height,
                                                           cameraImg.size.width, cameraImg.size.height)
                                     isBackView:NO];
            photoBtn.frame = [UIView fitCGRect:CGRectMake(100+cameraImg.size.width, 480-44-20-cameraImg.size.height,
                                                          photoImg.size.width, photoImg.size.height)
                                    isBackView:NO];
            deleteBtn.frame = [UIView fitCGRect:CGRectMake(100+cameraImg.size.width+photoImg.size.width,
                                                           480-44-20-cameraImg.size.height, delImg.size.width, delImg.size.height)
                                     isBackView:NO];
        }
    }
    [self.view addSubview:scrollView];
    
    [self showCertificate];
    
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)sView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((sView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    indexLab.text = [NSString stringWithFormat:@"%d/%lu", page+1,(unsigned long)certyImgPathArray.count];
}

#pragma mark - 
#pragma mark - Control Action
- (void) doButtonClicked:(id) sender
{
    UIButton *btn = sender;
    switch (btn.tag)
    {
        case 0:      //完成
        {
            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:certyImgPathArray,
                                                                               @"CertyUrlArray", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setCertitionNotice"
                                                                object:self
                                                              userInfo:userDic];
            
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            [nav popViewControllerAnimated:YES];
            break;
        }
        case 1:      //照相
        {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
                [nav presentViewController:controller
                                  animated:YES
                                completion:^(void){
                                    CLog(@"Picker View Controller is presented");
                                }];
            }
            break;
        }
        case 2:      //相册
        {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
                [nav presentViewController:controller
                                  animated:YES
                                completion:^(void){
                                    CLog(@"Picker View Controller is presented");
                                }];
            }
            break;
        }
        case 3:      //删除
        {
            CGFloat pageWidth = self.view.frame.size.width;
            int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            [certyImgPathArray removeObjectAtIndex:page];
            [self showCertificate];
            break;
        }
        default:
            break;
    }
}

- (NSString *) savePhotosToLocal:(UIImage *) headImg
{
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/head.jpg"];
    BOOL isSucc = [UIImageJPEGRepresentation(headImg, 1.0) writeToFile:jpgPath
                                                            atomically:YES];
    if (isSucc)
    {
        CLog(@"write png to local success!");
    }
    else
    {
        CLog(@"write png to local failed!");
    }
    
    return jpgPath;
}

- (NSString *) uploadHeadToServer:(NSString *) headPath
{
    //获得时间戳
    NSDate *dateNow  = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    
    //上传头像
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"edittime",@"uptype",@"sessid",UPLOAD_FILE, nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"uploadfile",
                          timeSp,@"image",ssid,[NSDictionary dictionaryWithObjectsAndKeys:headPath,@"file", nil],nil];

    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,TEACHER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    for (int i=0; i<paramsArr.count; i++)
    {
        if ([[paramsArr objectAtIndex:i] isEqual:UPLOAD_FILE])
        {
            NSDictionary *fileDic = [valuesArr objectAtIndex:i];
            NSString *fileParam   = [[fileDic allKeys] objectAtIndex:0];
            NSString *filePath    = [[fileDic allValues]objectAtIndex:0];
            [request setFile:filePath forKey:fileParam];
            continue;
        }
        
        [request setPostValue:[valuesArr objectAtIndex:i]
                       forKey:[paramsArr objectAtIndex:i]];
    }
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"Content-Type"
                        value:@"text/xml; charset=utf-8"];
    [request startSynchronous];
    NSData *resVal = [request responseData];
    assert(resVal);
    NSString *curHeadUrl = @"";
    if (resVal )
    {
        NSDictionary *resDic   = [NSJSONSerialization JSONObjectWithData:resVal
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];
        CLog(@"resDic;%@", resDic);
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"uploadfile"])
        {
            NSString *errorid = [[resDic objectForKey:@"errorid"] copy];
            if (errorid.intValue==0)
            {
                curHeadUrl = [resDic objectForKey:@"filepath"];
            }
            else
            {
                NSString *errorMsg = [resDic objectForKey:@"message"];
                [self showAlertWithTitle:@"提示"
                                     tag:0
                                 message:[NSString stringWithFormat:@"错误码%@,%@",errorid,errorMsg]
                                delegate:[MainViewController getNavigationViewController]
                       otherButtonTitles:@"确定",nil];
            }
        }
    }
    else
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"上传文件失败"
                        delegate:[MainViewController getNavigationViewController]
               otherButtonTitles:@"确定",nil];
    }
    
    return curHeadUrl;
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    __block NSString *CurHeadUrl = nil;
    
    //保存头像到本地
    NSString *path = [self savePhotosToLocal:editedImage];
    
    //显示上传等待
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
    
    //线程上传头像
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CurHeadUrl = [[self uploadHeadToServer:path] copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //隐藏刷新等待
            [MBProgressHUD hideHUDForView:nav.view animated:YES];
            [certyImgPathArray addObject:CurHeadUrl];
            
            //显示证书
            [self showCertificate];
        });
    });
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
    
    [CurHeadUrl release];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        
        // 裁剪
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, nav.view.frame.size.width, nav.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [nav presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
@end
