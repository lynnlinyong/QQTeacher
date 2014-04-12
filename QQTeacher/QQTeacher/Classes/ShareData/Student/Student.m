//
//  Student.m
//  QQStudent
//
//  Created by lynn on 14-2-2.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "Student.h"

@implementation Student
@synthesize icon;
@synthesize email;
@synthesize nickName;
@synthesize phoneNumber;
@synthesize grade;
@synthesize gradeId;
@synthesize gender;
@synthesize lltime;
@synthesize longitude;
@synthesize latitude;
@synthesize status;
@synthesize phoneStars;
@synthesize locStars;
@synthesize deviceId;
@synthesize studentId;

- (id) init
{
    self = [super init];
    if (self)
    {
        icon        = [[NSString alloc]init];
        email       = [[NSString alloc]init];
        nickName    = [[NSString alloc]init];
        phoneNumber = [[NSString alloc]init];
        grade       = [[NSString alloc]init];
        gradeId     = [[NSString alloc]init];
        gender      = [[NSString alloc]init];
        lltime      = [[NSString alloc]init];
        longitude   = [[NSString alloc]init];
        latitude    = [[NSString alloc]init];
        status      = [[NSString alloc]init];
        phoneStars  = [[NSString alloc]init];
        locStars    = [[NSString alloc]init];
        
        deviceId    = [[NSString alloc]init];
        studentId   = [[NSString alloc]init];
    }
    
    return self;
}

- (void) dealloc
{
    [icon           release];
    [email          release];
    [nickName       release];
    [phoneNumber    release];
    [grade          release];
    [gradeId        release];
    [gender         release];
    [lltime         release];
    [longitude      release];
    [latitude       release];
    [status         release];
    [phoneStars     release];
    [locStars       release];
    
    [deviceId release];
    [studentId release];
    [super dealloc];
}

- (id) copyWithZone:(NSZone *)zone
{
    Student *sObj = NSCopyObject(self, 0, zone);
    if (sObj)
    {
        sObj.email       = [email copy];
        sObj.nickName    = [nickName copy];
        sObj.phoneNumber = [phoneNumber copy];
        sObj.grade       = [grade copy];
        sObj.gender      = [gender copy];
        sObj.lltime      = [lltime copy];
        sObj.longitude   = [longitude copy];
        sObj.latitude    = [latitude copy];
        sObj.status      = [status copy];
        sObj.phoneStars  = [phoneStars copy];
        sObj.locStars    = [locStars copy];
        sObj.icon        = [icon copy];
        sObj.gradeId     = [gradeId copy];
        sObj.deviceId    = [deviceId copy];
        sObj.studentId   = [studentId copy];
    }
    
    return sObj;
}

- (id) mutableCopyWithZone:(NSZone *)zone
{
    Student *sObj = NSCopyObject(self, 0, zone);
    if (sObj)
    {
        sObj.email       = [email mutableCopy];
        sObj.nickName    = [nickName mutableCopy];
        sObj.phoneNumber = [phoneNumber mutableCopy];
        sObj.grade       = [grade mutableCopy];
        sObj.gender      = [gender mutableCopy];
        sObj.lltime      = [lltime mutableCopy];
        sObj.longitude   = [longitude mutableCopy];
        sObj.latitude    = [latitude mutableCopy];
        sObj.status      = [status mutableCopy];
        sObj.phoneStars  = [phoneStars mutableCopy];
        sObj.locStars    = [locStars mutableCopy];
        sObj.icon        = [icon copy];
        
        sObj.gradeId     = [gradeId copy];
        sObj.deviceId    = [deviceId copy];
        sObj.studentId   = [studentId copy];
    }
    
    return sObj;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.email
                  forKey:@"email"];
    [aCoder encodeObject:self.nickName
                  forKey:@"nickName"];
    [aCoder encodeObject:self.phoneNumber
                  forKey:@"phoneNumber"];
    [aCoder encodeObject:self.grade
                  forKey:@"grade"];
    [aCoder encodeObject:self.gender
                  forKey:@"gender"];
    [aCoder encodeObject:self.lltime
                  forKey:@"lltime"];
    [aCoder encodeObject:self.longitude
                  forKey:@"longitude"];
    [aCoder encodeObject:self.latitude
                  forKey:@"latitude"];
    [aCoder encodeObject:self.status
                  forKey:@"status"];
    [aCoder encodeObject:self.phoneStars
                  forKey:@"phoneStars"];
    [aCoder encodeObject:self.locStars
                  forKey:@"locStars"];
    [aCoder encodeObject:self.icon
                  forKey:@"icon"];
    [aCoder encodeObject:self.gradeId
                  forKey:@"gradeId"];
    [aCoder encodeObject:self.deviceId
                  forKey:@"deviceId"];
    [aCoder encodeObject:self.studentId
                  forKey:@"studentId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        email       = [[aDecoder decodeObjectForKey:@"email"] copy];
        nickName    = [[aDecoder decodeObjectForKey:@"nickName"] copy];
        phoneNumber = [[aDecoder decodeObjectForKey:@"phoneNumber"] copy];
        grade       = [[aDecoder decodeObjectForKey:@"grade"] copy];
        gradeId     = [[aDecoder decodeObjectForKey:@"gradeId"] copy];
        gender      = [[aDecoder decodeObjectForKey:@"gender"] copy];
        lltime      = [[aDecoder decodeObjectForKey:@"lltime"] copy];
        longitude   = [[aDecoder decodeObjectForKey:@"longitude"] copy];
        latitude    = [[aDecoder decodeObjectForKey:@"latitude"] copy];
        status      = [[aDecoder decodeObjectForKey:@"status"] copy];
        phoneStars  = [[aDecoder decodeObjectForKey:@"phoneStars"] copy];
        locStars    = [[aDecoder decodeObjectForKey:@"locStars"] copy];
        icon        = [[aDecoder decodeObjectForKey:@"icon"] copy];
        
        deviceId    = [[aDecoder decodeObjectForKey:@"deviceId"] copy];
        studentId   = [[aDecoder decodeObjectForKey:@"studentId"] copy];
    }
    
    return self;
}

//设置学生属性
+ (Student *) setPropertyStudent:(NSDictionary *) studentDic
{
    Student *student = [[[Student alloc]init]autorelease];
    
    NSString *gender = [[studentDic objectForKey:@"gender"] copy];
    if ([gender isEqual:[NSNull null]])
        student.gender = @"";
    else
        student.gender = gender;
    
    NSString *phone = [[studentDic objectForKey:@"phone"] copy];
    if ([phone isEqual:[NSNull null]])
        student.phoneNumber = @"";
    else
        student.phoneNumber = phone;
    
    if (!phone)
    {
        phone = [[studentDic objectForKey:@"student_phone"] copy];
        if ([phone isEqual:[NSNull null]])
            student.phoneNumber = phone;
        else
            student.phoneNumber = phone;
    }
    
    NSString *name = [[studentDic objectForKey:@"nickname"] copy];
    if ([name isEqual:[NSNull null]])
        student.nickName = @"";
    else
        student.nickName = name;
    
    if (!name)
    {
        name = [[studentDic objectForKey:@"name"] copy];
        if ([name isEqual:[NSNull null]])
            student.nickName = @"";
        else
            student.nickName = name;
    }
    
    if (!name)
    {
        name = [[studentDic objectForKey:@"nick"] copy];
        if ([name isEqual:[NSNull null]])
            student.nickName = @"";
        else
            student.nickName = name;
    }
    
    NSString *gradeId = [[studentDic objectForKey:@"grade"] copy];
    if ([gradeId isEqual:[NSNull null]])
        student.gradeId = @"0";
    else
        student.gradeId = gradeId;
    
    NSString *gradeText = [[studentDic objectForKey:@"gradeText"] copy];
    if ([gradeText isEqual:[NSNull null]])
        student.grade = @"";
    else
        student.grade = gradeText;
    
    NSString *deviceId = [[studentDic objectForKey:@"deviceId"] copy];
    if ([deviceId isEqual:[NSNull null]])
        student.deviceId = @"";
    else
        student.deviceId = deviceId;
    
    NSString *studentId = [[studentDic objectForKey:@"studentId"] copy];
    if ([studentId isEqual:[NSNull null]])
        student.studentId = @"";
    else
        student.studentId = studentId;
    
    NSString *latitude = [[studentDic objectForKey:@"latitude"] copy];
    if ([latitude isEqual:[NSNull null]])
        student.latitude = @"";
    else
        student.latitude = latitude;
    
    NSString *longitude = [[studentDic objectForKey:@"longitude"] copy];
    if ([longitude isEqual:[NSNull null]])
        student.longitude = @"";
    else
        student.longitude = longitude;
    
    return student;
}

//根据年级列表,名字查询年级ID
+ (NSString *) searchGradeID:(NSString *)gradeName
{
    NSString *result = nil;
    
    NSArray *gradList = [[NSUserDefaults standardUserDefaults] objectForKey:GRADE_LIST];
    if (gradList)
    {
        for (NSDictionary *item in gradList)
        {
            NSString *tGdName = [item objectForKey:@"name"];
            if ([gradeName isEqualToString:tGdName])
            {
                return [[item objectForKey:@"id"] retain];
            }
        }
    }
    else
    {
        [Student getGradeList];
        return [Student searchGradeID:gradeName];
    }
    return result;
}

//根据年级列表,年级ID查询名字
+ (NSString *) searchGradeName:(NSString *) gradeID
{
    NSString *result  = @"";
    NSArray *gradList = [[NSUserDefaults standardUserDefaults] objectForKey:GRADE_LIST];
    if (gradList)
    {
        for (NSDictionary *item in gradList)
        {
            NSString *tGdID = [item objectForKey:@"id"];
            if ([gradeID isEqualToString:tGdID])
            {
                return [[item objectForKey:@"name"] retain];
            }
        }
    }
    else
    {
        [Student getGradeList];
        return [Student searchGradeName:gradeID];
    }
    
    return result;
}

+ (void) getSalarys
{
    NSArray *salaryList = [[NSUserDefaults standardUserDefaults] objectForKey:SALARY_LIST];
//    if (!salaryList)
//    {
        if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
        {
            return;
        }
        
        NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"getkcbzs",ssid, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url = [NSString stringWithFormat:@"%@%@", webAdd, TEACHER];
        ServerRequest *request = [ServerRequest sharedServerRequest];
        NSData   *resVal = [request requestSyncWith:kServerPostRequest
                                           paramDic:pDic
                                             urlStr:url];
        NSString *resStr = [[NSString alloc]initWithData:resVal
                                                encoding:NSUTF8StringEncoding];
        NSDictionary *resDic   = [resStr JSONValue];
        NSArray      *keysArr  = [resDic allKeys];
        NSArray      *valsArr  = [resDic allValues];
        CLog(@"***********Result****************");
        for (int i=0; i<keysArr.count; i++)
        {
            CLog(@"sdfsdfsdfsdfsdfs%@=%@", [keysArr objectAtIndex:i], [valsArr objectAtIndex:i]);
        }
        CLog(@"***********Result****************");
        
        NSNumber *errorid = [resDic objectForKey:@"errorid"];
        if (errorid.intValue == 0)
        {
            NSString *action = [resDic objectForKey:@"action"];
            if ([action isEqualToString:@"getkcbzs"])
            {
                NSArray *potMoney = [[resDic objectForKey:@"kcbzs"] copy];
                [[NSUserDefaults standardUserDefaults] setObject:potMoney
                                                          forKey:SALARY_LIST];
            }
        }
        //重复登录
        else if (errorid.intValue==2)
        {
            //清除sessid,清除登录状态,回到地图页
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SSID];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGINE_SUCCESS];
            [AppDelegate popToMainViewController];
        }
//    }
}

+(NSString *) searchSalaryID:(NSString *) salaryName
{
    NSArray *salaryList = [[NSUserDefaults standardUserDefaults] objectForKey:SALARY_LIST];
    if (salaryList)
    {
        for (NSDictionary *item in salaryList)
        {
            NSString *tGdName = [item objectForKey:@"name"];
            if ([salaryName isEqualToString:tGdName])
            {
                if ([item objectForKey:@"id"])
                    return [item objectForKey:@"id"];
                else
                    return @"";
            }
        }
    }
    else
    {
        [Student getSalarys];
        return [Student searchSalaryID:salaryName];
    }
    
    return nil;
}

+(NSString *) searchSalaryName:(NSString *) salaryID
{
    NSString *result = nil;
    NSArray *salaryList = [[NSUserDefaults standardUserDefaults] objectForKey:SALARY_LIST];
    if (salaryList)
    {
        for (NSDictionary *item in salaryList)
        {
            NSString *tGdid = [item objectForKey:@"id"];
            if ([salaryID isEqualToString:tGdid])
            {
                NSString *name = [item objectForKey:@"name"];
                if (name)
                {
                    if (name.intValue == 0)
                        return @"师生协商";
                    return [[item objectForKey:@"name"] retain];
                }
                else
                    return @"";
            }
        }
    }
    else
    {
        [Student getSalarys];
        return [Student searchSalaryName:salaryID];
    }
    
    return result;
}

+ (void) getGradeList
{
    NSArray *gradList = [[NSUserDefaults standardUserDefaults] objectForKey:GRADE_LIST];
//    if (!gradList)
//    {
        if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
        {
            return;
        }
        
        NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"getgrade",ssid, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd, TEACHER];
        ServerRequest *request = [ServerRequest sharedServerRequest];
        NSData *resVal = [request requestSyncWith:kServerPostRequest
                                         paramDic:pDic
                                           urlStr:url];
        NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                 encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *resDic   = [resStr JSONValue];
        NSArray      *keysArr  = [resDic allKeys];
        NSArray      *valsArr  = [resDic allValues];
        CLog(@"***********Result****************");
        for (int i=0; i<keysArr.count; i++)
        {
            CLog(@"%@=%@", [keysArr objectAtIndex:i], [valsArr objectAtIndex:i]);
        }
        CLog(@"***********Result****************");
        
        NSNumber *errorid = [resDic objectForKey:@"errorid"];
        if (errorid.intValue == 0)
        {
            NSArray *gradList = [[resDic objectForKey:@"grades"] copy];
            [[NSUserDefaults standardUserDefaults] setObject:gradList
                                                      forKey:GRADE_LIST];
        }
//    }
}

//根据性别ID,查询性别
+ (NSString *) searchGenderName:(NSString *) genderId
{
    NSString *result = @"";
    
    if ([genderId isEqualToString:@"1"])
        result = @"男";
    else
        result = @"女";
    
    return result;
}

//根据性别, 查询ID
+ (NSString *) searchGenderID:(NSString *) genderName
{
    NSString *result = @"";
    
    if ([genderName isEqualToString:@"男"])
        result = @"1";
    else if ([genderName isEqualToString:@"不限"])
        result = @"0";
    else
        result = @"2";
    
    
    return result;
}

+ (void) getSubjects
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSArray *subArr   = [[NSUserDefaults standardUserDefaults] objectForKey:SUBJECT_LIST];
//    if (!subArr)
//    {
        NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"getsubjects",ssid, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd, TEACHER];
        ServerRequest *request = [ServerRequest sharedServerRequest];
        NSData   *resVal = [request requestSyncWith:kServerPostRequest
                                           paramDic:pDic
                                             urlStr:url];
        NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                 encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *resDic   = [resStr JSONValue];
        NSArray      *keysArr  = [resDic allKeys];
        NSArray      *valsArr  = [resDic allValues];
        CLog(@"***********Result****************");
        for (int i=0; i<keysArr.count; i++)
        {
            CLog(@"%@=%@", [keysArr objectAtIndex:i], [valsArr objectAtIndex:i]);
        }
        CLog(@"***********Result****************");
        
        
        NSNumber *errorid = [resDic objectForKey:@"errorid"];
        if (errorid.intValue == 0)
        {
            subArr = [[resDic objectForKey:@"subjects"] copy];
            
            //保存科目列表
            [[NSUserDefaults standardUserDefaults] setObject:subArr
                                                      forKey:SUBJECT_LIST];
        }
        else
        {   
            //重复登录
            if (errorid.intValue==2)
            {
                //清除sessid,清除登录状态,回到地图页
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SSID];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGINE_SUCCESS];
                [AppDelegate popToMainViewController];
            }
        }
//    }
}

//根据年级列表,名字查询ID
+(NSString *) searchSubjectID:(NSString *) subjectName
{
    NSString *result = nil;
    NSArray *subList = [[NSUserDefaults standardUserDefaults] objectForKey:SUBJECT_LIST];
    if (subList)
    {
        for (NSDictionary *item in subList)
        {
            NSString *tGdName = [item objectForKey:@"name"];
            if ([subjectName isEqualToString:tGdName])
            {
                if ([item objectForKey:@"id"])
                    return [[item objectForKey:@"id"] retain];
                else
                    return @"";
            }
        }
    }
    else
    {
        [Student getSubjects];
        return [Student searchSubjectID:subjectName];
    }
    
    return result;
}

//根据年级列表,ID查询名字
+(NSString *) searchSubjectName:(NSString *) subjectId
{
    NSString *result  = @"";
    NSArray *gradList = [[NSUserDefaults standardUserDefaults] objectForKey:SUBJECT_LIST];
    if (gradList)
    {
        for (NSDictionary *item in gradList)
        {
            NSString *tGdID = [item objectForKey:@"id"];
            if ([subjectId isEqualToString:tGdID])
            {
                if ([item objectForKey:@"name"])
                    return [item objectForKey:@"name"];
                else
                    return @"";
            }
        }
    }
    else
    {
        [Student getSubjects];
        return [Student searchSubjectName:subjectId];
    }
    
    return result;
}
@end
