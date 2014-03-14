//
//  SplashViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

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
    
    [self initUI];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    uiPctr  = nil;
    uiSView = nil;
}

- (void) dealloc
{
    [img2 release];
    [img3 release];
    [uiPctr  release];
    [uiSView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    uiSView = [[UIScrollView alloc]init];
    uiSView.delegate = self;
    uiSView.pagingEnabled = YES;
    uiSView.scrollEnabled = YES;
    CGRect rect   = [UIScreen getCurrentBounds];
    uiSView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    uiSView.contentSize = CGSizeMake(rect.size.width*2, rect.size.height);
    
    UIImageView *img1 = [[UIImageView alloc]init];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    img1.image = [UIImage imageNamed:@"yd2-568h"];
#elif
    img1.image = [UIImage imageNamed:@"yd2"];
#endif
    img1.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480)
                        isBackView:YES];
    [uiSView addSubview:img1];
    
    img2 = [[UIImageView alloc]init];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    img2.image = [UIImage imageNamed:@"yd4-568h"];
#elif
    img2.image = [UIImage imageNamed:@"yd4"];
#endif
    img2.frame = [UIView fitCGRect:CGRectMake(320, 0, 320, 480)
                        isBackView:YES];
    [uiSView addSubview:img2];
    
    img3 = [[UIImageView alloc]init];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    img3.image = [UIImage imageNamed:@"yd3-568h"];
#elif
    img3.image = [UIImage imageNamed:@"yd3"];
#endif
    img3.frame = [UIView fitCGRect:CGRectMake(320, 0, 320, 480)
                        isBackView:YES];
    [uiSView addSubview:img3];
    [self.view addSubview:uiSView];
    [img1 release];
    
    uiPctr = [[UIPageControl alloc]init];
    uiPctr.currentPage   = 0;
    uiPctr.numberOfPages = 2;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            uiPctr.frame = [UIView fitCGRect:CGRectMake(110, 400, 100, 10)
                                  isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            uiPctr.frame = [UIView fitCGRect:CGRectMake(110, 400, 100, 10)
                                  isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            uiPctr.frame = [UIView fitCGRect:CGRectMake(110, 420, 100, 10)
                                  isBackView:NO];
            
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            uiPctr.frame = [UIView fitCGRect:CGRectMake(110, 420, 100, 10)
                                  isBackView:NO];
        }
    }
    [uiPctr addTarget:self
               action:@selector(doValueChanged:)
     forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:uiPctr];
}

- (void) doValueChanged:(id)sender
{
    long page = uiPctr.currentPage;
    [uiSView setContentOffset:CGPointMake(320*page, 0)];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    uiPctr.currentPage = page;
    
    if (page==1)
    {
        //播放动画
        [UIView animateWithDuration:1.5 animations:^{
            img3.alpha = 0.0;
        }];
    }
    
    //进入主界面
    CGFloat offset = scrollView.contentOffset.x-(uiPctr.numberOfPages-1)*pageWidth;
    if ((page == 1) && (offset > 20))
    {
        MainViewController *mainVctr = [[MainViewController alloc]init];
        CustomNavigationViewController *nav = [[[CustomNavigationViewController alloc]initWithRootViewController:mainVctr]autorelease];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.window.rootViewController = nav;
    }
}
@end
