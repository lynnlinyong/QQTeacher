//
//  NSString+Regex.h
//  QQTeacher
//
//  Created by Lynn on 14-4-25.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;

//邮箱
+ (BOOL) validateEmail:(NSString *)email;


//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
@end
