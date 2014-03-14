//
//  UIView+UIAdaptation.m
//  DeviceShop
//
//  Created by lynn on 13-5-29.
//  Copyright (c) 2013年 lynn. All rights reserved.
//

#import "UIView+UIAdaptation.h"

@implementation UIView (UIAdaptation)

+ (float)currentSize:(BOOL)h
{
    CGRect screen_rect = [UIScreen getCurrentBounds];
    CGSize screen_size = screen_rect.size;
    CLog(@"curScreen:%f,%f", screen_rect.size.width,screen_rect.size.height);
    
    //一般屏幕为1,Retina为2
    CGFloat screen_scale   = [[UIScreen mainScreen]scale];  
    float baseResolution_h = 480 * screen_scale;
    float baseResolution_w = 320 * screen_scale;
    
    float currentResolution_h;
    float currentResolution_w;

    //当前设备的分辨率
    currentResolution_h = screen_size.height * screen_scale;
    currentResolution_w = screen_size.width  * screen_scale;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            
            CLog(@"It's is iphone5 IOS7");
            currentResolution_h += 152;
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            currentResolution_h += 108;
            //ios 7 iphone 4
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            currentResolution_h -= 20;
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
        }
    }
    
    //高度与宽度分辨比例
    if (h)
    {
        return (float)currentResolution_h/baseResolution_h;
    }
    else
    {
        return (float)currentResolution_w/baseResolution_w;
    }
}

+(CGRect)fitCGRect:(CGRect)rect isBackView:(BOOL) isBackView
{ 
    float x = rect.origin.x;
    float y = rect.origin.y;
    float width  = rect.size.width;
    float height = rect.size.height;
    float currentSize_h = [self currentSize:YES];  //高度当前设备与480x320比例
    float currentSize_w = [self currentSize:NO];   //宽度当前设备与480x320比例
    CGRect frame;
    if (!isBackView)
    {
         frame = CGRectMake(x*currentSize_w, y*currentSize_h,
                                  width, height);
    }
    else
    {
         frame = CGRectMake(x*currentSize_w, y*currentSize_h,
                                  width*currentSize_w, height*currentSize_h);
    }
    
    return frame;
}

@end
