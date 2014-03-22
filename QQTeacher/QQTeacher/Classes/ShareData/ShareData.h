//
//  ShareData.g.h
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#ifndef QQStudent_ShareData_h
#define QQStudent_ShareData_h

//测试前缀
#define DEBUG_PREFIX    @"****DEBUG****:"

//第一次启动变量
#define LAUNCHERED      @"LAUNCHERED"

//Web服务器地址变量
#define WEBADDRESS      @"WEBADDRESS"

//Push服务器地址变量
#define PUSHADDRESS     @"PUSHADDRESS"

//每轮最大推送时间
#define PUSHMAXTIME     @"PUSHMAXTIME"

//每页推送间隔
#define PUSHPAGETIME    @"PUSHPAGETIME"

#define LONGITUDE       @"LONGITUDE"

#define LATITUDE        @"LATITUDE"

//Push服务器端口
#define PORT            @"PORT"

//学生接口标识
#define STUDENT         @"student/?"

//教师接口标识
#define TEACHER         @"teacher/?"

//老师信息标识
#define TEACHER_INFO    @"TEACHER_INFO"

//手机系统表示
#define IOS             @"1"

#define SSID            @"SSID"

//帮助电话
#define HELP_PHONE      @"HELP_PHONE"

//软件版本
#define APP_VERSION     @"APP_VERSION"

#define LOGINE_SUCCESS  @"LOGIN_SUCCESS"

//年级列表
#define GRADE_LIST      @"GRADE_LIST"

//科目列表
#define SUBJECT_LIST    @"SUBJECT_LIST"

#define SALARY_LIST     @"SALARY_LIST"

//数据库名
#define DATABASE        @"provinces.db"

//录音名
#define VOICE_NAME      @"/voice.amr"

//上传文件标识
#define UPLOAD_FILE     @"UPLOAD_FILE"

//手机串号ID
#define UUID            @"UUID"

//是否已经抢单
#define IS_ORDER_CONFIRM  @"IS_ORDER_CONFIRM"

//策略服务器地址

//测试服务器
//#define ServerAddress   @"http://app.changingedu.com:8085/Interfaces/app/"

//正式服务器
#define ServerAddress    @"http://app.changingedu.com/Interfaces/app/"

#define     MAP_API_KEY  @"513e60ac02ea80ee24943c1d383dc56c"

//#define     QQ_STUDENT   @"QQ_STUDENT"
#define DEVICE_TOKEN    @"DEVICE_TOKEN"

typedef enum _tagMsgType
{
    PUSH_TYPE_PUSH = 0,
    PUSH_TYPE_APPLY,
    PUSH_TYPE_CONFIRM,
    PUSH_TYPE_TEXT,
    PUSH_TYPE_IMAGE,
    PUSH_TYPE_AUDIO,
    PUSH_TYPE_ORDER_EDIT,
    PUSH_TYPE_ORDER_CONFIRM,
    PUSH_TYPE_ORDER_EDIT_SUCCESS,
    PUSH_TYPE_ORDER_CONFIRM_SUCCESS,
    PUSH_TYPE_PUSHCC,                 //助教消息
    PUSH_TYPE_LISTENING_CHANG,
    PUSH_TYPE_OFFLINE_MSG=9999,       //异地登录
}MsgType;

typedef enum _noticeType
{
    NOTICE_AD=0,    //广告
    NOTICE_GG,      //公告
    NOTICE_MSG      //交互消息
}NoticeType;

//腾讯微博
#define WiressSDKDemoAppKey     @"801443617"
#define WiressSDKDemoAppSecret  @"bb1384bf8d1bdab626b189dfdaeecc44"
#define REDIRECTURI             @"http://app.changingedu.com/"

//sina微博
#define kAppKey                 @"3909842123"
#define kAppSecret              @"9594d445d8ed603f3eb5e9512346ae87"
#define kAppRedirectURL         @"https://api.weibo.com/oauth2/default.html"

//微信
#define WeiXinAppID             @"wx355a19fe08cef22d"
#define WeiXinAppKey            @"e17905ec29ec03142a18cffad8b48944"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif
