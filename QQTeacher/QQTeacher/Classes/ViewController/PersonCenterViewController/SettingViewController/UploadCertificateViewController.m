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
    [certyImgArray release];
    [certyImgPathArray release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) showCertificate
{
    if (certyImgArray.count == 0)
    {
        NSArray *imgViewArray = scrollView.subviews;
        for (UIView *imgView in imgViewArray)
        {
            if ([imgView isKindOfClass:[UIImageView class]])
            {
                [imgView removeFromSuperview];
                imgView = nil;
            }
        }
    }
    
    for (int i=0; i<certyImgArray.count; i++)
    {
        scrollView.contentSize = CGSizeMake(320*(i+1), 320);
        
        UIImage *image = [certyImgArray objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.image = image;
        CLog(@"size:%f,%f", image.size.width, image.size.height);
        imgView.frame = CGRectMake(320*i+160-image.size.width/4,
                                   scrollView.frame.size.height-image.size.height/2,
                                   320, 320);
        [scrollView addSubview:imgView];
        [imgView release];
    }
    
    indexLab.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)certyImgArray.count,(unsigned long)certyImgArray.count];
    
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 320*certyImgArray.count, 320) animated:YES];
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
    indexLab.frame= [UIView fitCGRect:CGRectMake(120, 10, 80, 20)
                           isBackView:NO];
    [self.view addSubview:indexLab];
    
    
    certyImgArray = [[NSMutableArray alloc]init];
    certyImgPathArray = [[NSMutableArray alloc]init];
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.frame = CGRectMake(0, 40, 320, 320);
    [self.view addSubview:scrollView];
    
    //底部操作按钮
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cameraBtn.tag = 1;
    [cameraBtn setTitle:@"照相" forState:UIControlStateNormal];
    cameraBtn.frame = [UIView fitCGRect:CGRectMake(100, 480-44-50, 40, 30) isBackView:NO];
    [cameraBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoBtn.tag = 2;
    [photoBtn setTitle:@"相册" forState:UIControlStateNormal];
    photoBtn.frame = [UIView fitCGRect:CGRectMake(140, 480-44-50, 40, 30)
                            isBackView:NO];
    [photoBtn addTarget:self
                 action:@selector(doButtonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteBtn.tag = 3;
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.frame = [UIView fitCGRect:CGRectMake(180, 480-44-50, 40, 30) isBackView:NO];
    [deleteBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)sView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((sView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    indexLab.text = [NSString stringWithFormat:@"%d/%lu", page+1,(unsigned long)certyImgArray.count];
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
            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:certyImgPathArray,@"CertyUrlArray", nil];
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
            [certyImgArray removeObjectAtIndex:page];
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
                curHeadUrl = [NSString stringWithFormat:@"%@%@", webAdd, curHeadUrl];
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
    
    //添加证书
    [certyImgArray addObject:editedImage];
    [self showCertificate];
    
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