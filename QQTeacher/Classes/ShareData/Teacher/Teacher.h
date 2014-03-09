//
//  Teacher.h
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Teacher : NSObject<
                            NSCopying,
                            NSMutableCopying,
                            NSCoding>
{
    NSString   *email;      //邮箱
    NSString   *name;       //昵称
    NSString   *searchCode; //搜索码
    int        sex;         //性别
    NSString   *pf;         //专业
    int        pfId;        //专业Id
    int        comment;     //星评
    NSString   *idNums;     //身份证号
    int        studentCount;//辅导学生数
    NSString   *mood;       //心情
    NSString   *headUrl;    //头像地址
    NSString   *deviceId;   //设备号
    int        expense;     //课时薪水
    BOOL       isIos;       //是否是苹果系统
    BOOL       isOnline;    //是否在线
    NSString   *latitude;   //经度
    NSString   *longitude;  //纬度
    NSString   *phoneNums;  //电话号码
    NSString   *info;       //简介
    NSString   *teacherId;  //工号
    int        goodCount;   //好评
    int        badCount;    //差评
    
    NSArray    *certArray;  //证书
    
    BOOL       isId;        //是否认证
    NSString   *idOrgName;  //认证机构
    BOOL       isInfoComplete; //资料是否完善
}

@property (nonatomic, retain) NSString     *email;
@property (nonatomic, retain) NSString     *name;
@property (nonatomic, retain) NSString     *searchCode;
@property (nonatomic, assign) int          sex;
@property (nonatomic, retain) NSString     *pf;
@property (nonatomic, assign) int          pfId;
@property (nonatomic, assign) int          comment;
@property (nonatomic, retain) NSString     *idNums;
@property (nonatomic, assign) int          studentCount;
@property (nonatomic, retain) NSString     *mood;
@property (nonatomic, retain) NSString     *headUrl;
@property (nonatomic, retain) NSString     *deviceId;
@property (nonatomic, assign) int          expense;
@property (nonatomic, assign) BOOL         isIos;
@property (nonatomic, assign) BOOL         isOnline;
@property (nonatomic, retain) NSString     *latitude;
@property (nonatomic, retain) NSString     *longitude;
@property (nonatomic, retain) NSString     *phoneNums;
@property (nonatomic, retain) NSString     *info;
@property (nonatomic, retain) NSString     *teacherId;
@property (nonatomic, assign) int          goodCount;
@property (nonatomic, assign) int          badCount;
@property (nonatomic, retain) NSArray      *certArray;  //证书
@property (nonatomic, assign) BOOL         isId;
@property (nonatomic, retain) NSString     *idOrgName;
@property (nonatomic, assign) BOOL         isInfoComplete;

+ (Teacher *) setTeacherProperty:(NSDictionary *) resDic;
@end
