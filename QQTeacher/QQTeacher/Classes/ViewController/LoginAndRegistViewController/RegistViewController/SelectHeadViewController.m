//
//  SelectHeadViewController.m
//  QQTeacher
//
//  Created by lynn on 14-3-10.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SelectHeadViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface SelectHeadViewController ()

@end

@implementation SelectHeadViewController
@synthesize headUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    [headImageView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    self.view.frame = [UIView fitCGRect:CGRectMake(40, 0, 280, 360)
                             isBackView:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    LBorderView *infoView = [[LBorderView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(-1, -1, 282, 362)
                                                                     isBackView:YES]];
    infoView.hidden = NO;
    infoView.borderType   = BorderTypeSolid;
    infoView.dashPattern  = 8;
    infoView.spacePattern = 8;
    infoView.borderWidth  = 1;
    infoView.cornerRadius = 5;
    infoView.alpha        = 0.8;
    infoView.borderColor     = [UIColor blackColor];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView];
    
    headImageView = [[TTImageView alloc]init];
    headImageView.delegate = self;
    headImageView.defaultImage = [UIImage imageNamed:@"s_boy"];
    if (headUrl.length>0)
    {
        headImageView.URL = headUrl;
    }
    headImageView.frame = CGRectMake(51, 20, 180, 180);
    [infoView addSubview:headImageView];
    [infoView release];
    
    UIImage *bgImg  = [UIImage imageNamed:@"normal_btn"];
    UIButton *phontoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phontoBtn.tag = 0;
    [phontoBtn setTitle:@"相册"
              forState:UIControlStateNormal];
    [phontoBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                   forState:UIControlStateNormal];
    [phontoBtn setBackgroundImage:bgImg
                        forState:UIControlStateNormal];
    [phontoBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                        forState:UIControlStateHighlighted];
    phontoBtn.frame = [UIView fitCGRect:CGRectMake(51,
                                                  220,
                                                  180,
                                                  bgImg.size.height)
                            isBackView:NO];
    [phontoBtn addTarget:self
                 action:@selector(doButtonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phontoBtn];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.tag = 1;
    [cameraBtn setTitle:@"照相"
               forState:UIControlStateNormal];
    [cameraBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                    forState:UIControlStateNormal];
    [cameraBtn setBackgroundImage:bgImg
                         forState:UIControlStateNormal];
    [cameraBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                         forState:UIControlStateHighlighted];
    cameraBtn.frame = [UIView fitCGRect:CGRectMake(51,
                                                   220+bgImg.size.height+10,
                                                   180,
                                                   bgImg.size.height)
                             isBackView:NO];
    [cameraBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.tag = 2;
    [cancelBtn setTitle:@"取消"
               forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                    forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:bgImg
                         forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                         forState:UIControlStateHighlighted];
    cancelBtn.frame = [UIView fitCGRect:CGRectMake(51,
                                                   220+2*bgImg.size.height+20,
                                                   180,
                                                   bgImg.size.height)
                             isBackView:NO];
    [cancelBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

#pragma mark - 
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    UIButton *btn = sender;
    switch (btn.tag)
    {
        case 0:       //从相册选择照片
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
        case 1:       //拍照选择照片
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
        case 2:       //取消
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenHeadViewNotice"
                                                                object:self
                                                              userInfo:nil];
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
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,TEACHER];
    
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    NSData *resVal = [request requestSyncWith:kServerPostRequest
                                     paramDic:pDic
                                       urlStr:url];
    assert(resVal);
    NSString *curHeadUrl = @"";
    if (resVal)
    {
        NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                 encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *resDic  = [resStr JSONValue];
        CLog(@"resDic;%@", resDic);
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"uploadfile"])
        {
            NSString *errorid = [[resDic objectForKey:@"errorid"] copy];
            if (errorid.intValue==0)
            {
                curHeadUrl = [resDic objectForKey:@"filepath"];
//                curHeadUrl = [NSString stringWithFormat:@"%@%@", webAdd, curHeadUrl];
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
    headImageView.image = editedImage;
    
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
            
            //隐藏选择头像popUpView
            CLog(@"curHeadURL:%@", CurHeadUrl);
            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:CurHeadUrl,@"HeadUrl", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenHeadViewNotice"
                                                                object:self
                                                              userInfo:userDic];
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