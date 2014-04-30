//
//  Teacher.m
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher
@synthesize email;
@synthesize name;
@synthesize sex;
@synthesize pf;
@synthesize pfId;
@synthesize comment;
@synthesize idNums;
@synthesize studentCount;
@synthesize mood;
@synthesize headUrl;
@synthesize deviceId;
@synthesize expense;
@synthesize isIos;
@synthesize isOnline;
@synthesize latitude;
@synthesize longitude;
@synthesize phoneNums;
@synthesize info;
@synthesize teacherId;
@synthesize goodCount;
@synthesize badCount;
@synthesize certArray;
@synthesize idOrgName;
@synthesize isId;
@synthesize searchCode;
@synthesize isInfoComplete;
@synthesize phoneStar;
@synthesize locationStar;
@synthesize listenStar;
@synthesize timePeriod;

+ (Teacher *) setTeacherProperty:(NSDictionary *) resDic
{
    Teacher *teacherObj = [[[Teacher alloc]init] autorelease];
    
    NSString *email = [[resDic objectForKey:@"email"] copy];
    if (![email isEqual:[NSNull null]])
        teacherObj.email = email;
    else
        teacherObj.email = @"";
    
    NSString *stuCount  = [[resDic objectForKey:@"TS"] copy];
    if (![stuCount isEqual:[NSNull null]])
        teacherObj.studentCount = stuCount.intValue;
    else
        teacherObj.studentCount = 0;
    
    if ([stuCount isEqual:[NSNull null]])
    {
        stuCount = [[resDic objectForKey:@"students"] copy];
        if ([stuCount isEqual:[NSNull null]])
            teacherObj.studentCount = stuCount.intValue;
        else
            teacherObj.studentCount = 0;
    }
    
    NSString *deviceId   = [[resDic objectForKey:@"deviceId"] copy];
    if (![deviceId isEqual:[NSNull null]])
        teacherObj.deviceId = deviceId;
    else
        teacherObj.deviceId = @"";
    
    NSString *expense      = [[resDic objectForKey:@"expense"] copy];
    if (![expense isEqual:[NSNull null]])
        teacherObj.expense = expense.intValue;
    else
        teacherObj.expense = 0;
    
    NSString *sex = [[resDic objectForKey:@"gender"] copy];
    if (![sex isEqual:[NSNull null]])
        teacherObj.sex = sex.intValue;
    else
        teacherObj.sex = 0;
    
    NSString *url = [[resDic objectForKey:@"icon"] copy];
    if ([url isEqual:[NSNull null]])
        teacherObj.headUrl = @"";
    else
        teacherObj.headUrl = url;
    
    NSString *idNums = [[resDic objectForKey:@"idnumber"] copy];
    if ([idNums isEqual:[NSNull null]])
        teacherObj.idNums = @"";
    else
        teacherObj.idNums = idNums;
    
    NSString *isIos = [[resDic objectForKey:@"ios"] copy];
    if (![isIos isEqual:[NSNull null]])
    {
        if (isIos.intValue==1)
            teacherObj.isIos = YES;
        else
            teacherObj.isIos = NO;
    }
    else
        teacherObj.isIos = NO;
    
    NSString *latitude = [[resDic objectForKey:@"latitude"] copy];
    if ([latitude isEqual:[NSNull null]])
        teacherObj.latitude = @"";
    else
        teacherObj.latitude = latitude;
    
    NSString *longitude  = [[resDic objectForKey:@"longitude"] copy];
    if ([longitude isEqual:[NSNull null]])
        teacherObj.longitude = @"";
    else
        teacherObj.longitude = longitude;
    
    NSString *tmpName    = [[resDic objectForKey:@"name"] copy];
    if (![tmpName isEqual:[NSNull null]])
        teacherObj.name  = tmpName;
    else
        teacherObj.name  = @"";
    
    if (!tmpName)
    {
        NSString *name   = [[resDic objectForKey:@"nickname"] copy];
        if ([name  isEqual:[NSNull null]])
            teacherObj.name = @"";
        else
            teacherObj.name = name;
    }
    
    NSString *isOnline = [[resDic objectForKey:@"online"] copy];
    if (![isOnline isEqual:[NSNull null]])
    {
        if (isOnline.intValue==1)
            teacherObj.isOnline = YES;
        else
            teacherObj.isOnline = NO;
    }
    else
    {
        teacherObj.isOnline = NO;
    }
    
    NSString *phone = [[resDic objectForKey:@"phone"] copy];
    if ([phone isEqual:[NSNull null]])
        teacherObj.phoneNums = @"";
    else
        teacherObj.phoneNums = phone;
    
    NSString *sub  = [[resDic objectForKey:@"subject"] copy];
    if (![sub isEqual:[NSNull null]])
        teacherObj.pfId  = sub.intValue;
    else
        teacherObj.pfId  = 0;
    
    NSString *subject    = [[resDic objectForKey:@"subjectText"] copy];
    if (![subject isEqual:[NSNull null]])
        teacherObj.pf    = subject;
    else
        teacherObj.pf    = @"";
    
    NSString *starCnt    = [[[resDic objectForKey:@"tstars"] retain] copy];
    if ([starCnt  isEqual:[NSNull null]])
        teacherObj.comment   = 0;
    else
        teacherObj.comment   = starCnt.intValue;
    
    if (!starCnt)
    {
        starCnt = [[resDic objectForKey:@"teacher_stars"] copy];
        if ([starCnt isEqual:[NSNull null]])
            teacherObj.comment   = 0;
        else
            teacherObj.comment   = starCnt.intValue;
    }
    
    NSString *info      = [[resDic objectForKey:@"info"] copy];
    if ([info isEqual:[NSNull null]])
        teacherObj.info  = @"";
    else
        teacherObj.info = info;
    
    NSString *comment    = [[resDic objectForKey:@"xunNum"] copy];
    if (![comment isEqual:[NSNull null]])
        teacherObj.badCount = comment.intValue;
    else
        teacherObj.badCount = 0;
    
    comment    = [[resDic objectForKey:@"zanNum"] copy];
    if (![comment  isEqual:[NSNull null]])
        teacherObj.goodCount = comment.intValue;
    else
        teacherObj.goodCount = 0;
    
    teacherObj.certArray = [[resDic objectForKey:@"certificates"] copy];
    
    NSString *isId       = [[resDic objectForKey:@"type_stars"] copy];
    if (![isId  isEqual:[NSNull null]])
    {
        if (isId.intValue == 1)
            teacherObj.isId  = YES;
        else
            teacherObj.isId  = NO;
    }
    else
        teacherObj.isId = NO;
    
    NSString *idOrgName  = [[resDic objectForKey:@"teacher_type_text"] copy];
    if (![idOrgName  isEqual:[NSNull null]])
        teacherObj.idOrgName = idOrgName;
    else
        teacherObj.idOrgName = @"";
    
    NSString *searchcCode = [[resDic objectForKey:@"searchCode"] copy];
    if (![searchcCode isEqual:[NSNull null]])
        teacherObj.searchCode = searchcCode;
    else
        teacherObj.searchCode = @"";
    
    NSString *isComplete = [[resDic objectForKey:@"status"] copy];
    if (![isComplete isEqual:[NSNull null]])
    {
        if (isComplete.intValue==1)
            teacherObj.isInfoComplete = YES;
        else
            teacherObj.isInfoComplete = NO;
    }
    else
        teacherObj.isInfoComplete = NO;
    
    NSString *phoneStar = [[resDic objectForKey:@"phone_stars"] copy];
    if ([phoneStar isEqual:[NSNull null]])
        teacherObj.phoneStar = NO;
    else
    {
        if (phoneStar.intValue==1)
            teacherObj.phoneStar = YES;
        else
            teacherObj.phoneStar = NO;
    }
    
    NSString *locationStar = [[resDic objectForKey:@"location_stars"] copy];
    if ([locationStar isEqual:[NSNull null]])
        teacherObj.locationStar = NO;
    else
    {
        if (locationStar.intValue==1)
            teacherObj.locationStar = YES;
        else
            teacherObj.locationStar = NO;
    }
    
    NSString *listenStar = [[resDic objectForKey:@"pre_listening"] copy];
    if ([listenStar isEqual:[NSNull null]])
        teacherObj.listenStar = NO;
    else
    {
        if (listenStar.intValue==1)
            teacherObj.listenStar = YES;
        else
            teacherObj.listenStar = NO;
    }
    
    teacherObj.timePeriod = [[resDic objectForKey:@"time_period"] copy];
    
    return teacherObj;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        email        = [[NSString alloc]init];
        name         = [[NSString alloc]init];
        sex          = 0;
        pf           = [[NSString alloc]init];
        pfId         = 0;
        comment      = 0;
        idNums       = [[NSString alloc]init];
        studentCount = 0;
        mood         = [[NSString alloc]init];
        headUrl      = [[NSString alloc]init];
        deviceId     = [[NSString alloc]init];
        expense      = 0;
        isIos        = NO;
        isOnline     = NO;
        latitude     = [[NSString alloc]init];
        longitude    = [[NSString alloc]init];
        phoneNums    = [[NSString alloc]init];
        info         = [[NSString alloc]init];
        
        certArray    = [[NSArray alloc]init];
        isId         = NO;
        idOrgName    = [[NSString alloc]init];
        searchCode   = [[NSString alloc]init];
        isInfoComplete = NO;
        
        phoneStar = NO;
        locationStar = NO;
        listenStar   = NO;
        
        timePeriod = [[NSString alloc]init];
    }
    
    return self;
}

- (void) dealloc
{
    [email      release];
    [idOrgName  release];
    [searchCode release];
    [info       release];
    [name       release];
    [pf         release];
    [idNums     release];
    [mood       release];
    [headUrl    release];
    [deviceId   release];
    [latitude   release];
    [longitude  release];
    [phoneNums  release];
    [certArray  release];
    [timePeriod release];
    
    [super dealloc];
}

- (id) copyWithZone:(NSZone *)zone
{
    Teacher *tObj = [[[self class]allocWithZone:zone]init];//NSCopyObject(self, 0, zone);
    if (tObj)
    {
        tObj.email     = [email copy];
        tObj.name      = [name copy];
        tObj.sex       = sex;
        tObj.pf        = [pf copy];
        tObj.pfId      = pfId;
        tObj.idNums    = [idNums copy];
        tObj.mood      = [mood copy];
        tObj.headUrl   = [headUrl copy];
        tObj.comment   = comment;
        tObj.studentCount = studentCount;
        tObj.deviceId  = [deviceId copy];
        tObj.expense   = expense;
        tObj.isIos     = isIos;
        tObj.isOnline  = isOnline;
        tObj.latitude  = [latitude copy];
        tObj.longitude = [longitude copy];
        tObj.phoneNums = [phoneNums copy];
        tObj.info      = [info copy];
        tObj.goodCount = goodCount;
        tObj.badCount  = badCount;
        tObj.certArray = [certArray copy];
        
        tObj.isId      = isId;
        tObj.idOrgName = [idOrgName copy];
        tObj.searchCode = [searchCode copy];
        tObj.isInfoComplete = isInfoComplete;
        
        tObj.phoneStar = phoneStar;
        tObj.locationStar = locationStar;
        tObj.listenStar   = listenStar;
        
        tObj.timePeriod = [timePeriod copy];
    }
    
    return tObj;
}

- (id) mutableCopyWithZone:(NSZone *)zone
{
    Teacher *tObj = [[[self class]allocWithZone:zone]init];//NSCopyObject(self, 0, zone);
    if (tObj)
    {
        tObj.email   = [email copy];
        tObj.name    = [name copy];
        tObj.sex     = sex;
        tObj.pf      = [pf copy];
        tObj.pfId    = pfId;
        tObj.idNums  = [idNums copy];
        tObj.mood    = [mood copy];
        tObj.headUrl = [headUrl copy];
        tObj.comment = comment;
        tObj.studentCount = studentCount;
        tObj.deviceId = [deviceId copy];
        tObj.expense  = expense;
        tObj.isIos    = isIos;
        tObj.isOnline = isOnline;
        tObj.latitude = [latitude copy];
        tObj.longitude = [longitude copy];
        tObj.phoneNums = [phoneNums copy];
        tObj.info = [info copy];
        tObj.goodCount = goodCount;
        tObj.badCount  = badCount;
        tObj.certArray = [certArray copy];
        
        tObj.isId      = isId;
        tObj.idOrgName = [idOrgName copy];
        tObj.searchCode = [searchCode copy];
        tObj.isInfoComplete = isInfoComplete;
        
        tObj.phoneStar = phoneStar;
        tObj.locationStar = locationStar;
        tObj.listenStar   = listenStar;
        
        tObj.timePeriod = [timePeriod copy];
    }
    
    return tObj;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.email
                  forKey:@"email"];
    [aCoder encodeObject:self.name
                  forKey:@"name"];
    [aCoder encodeObject:self.searchCode
                  forKey:@"searchCode"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.sex]
                  forKey:@"sex"];
    [aCoder encodeObject:self.pf
                  forKey:@"pf"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.pfId]
                  forKey:@"pfId"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.comment]
                  forKey:@"comment"];
    [aCoder encodeObject:self.idNums
                  forKey:@"idNums"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.studentCount]
                  forKey:@"studentCount"];
    [aCoder encodeObject:self.mood
                  forKey:@"mood"];
    [aCoder encodeObject:self.headUrl
                  forKey:@"headUrl"];
    [aCoder encodeObject:self.deviceId
                  forKey:@"deviceId"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.expense]
                  forKey:@"expense"];
    [aCoder encodeBool:self.isIos
                forKey:@"isIos"];
    [aCoder encodeBool:self.isOnline
                forKey:@"isOnline"];
    [aCoder encodeObject:self.latitude
                  forKey:@"latitude"];
    [aCoder encodeObject:self.longitude
                  forKey:@"longitude"];
    [aCoder encodeObject:self.phoneNums
                  forKey:@"phoneNums"];
    [aCoder encodeObject:self.info
                  forKey:@"info"];
    [aCoder encodeObject:self.teacherId
                  forKey:@"teacherId"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.goodCount]
                  forKey:@"goodCount"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.badCount]
                  forKey:@"badCount"];
    [aCoder encodeObject:self.certArray
                  forKey:@"certArray"];
    [aCoder encodeBool:self.isId
                forKey:@"isId"];
    [aCoder encodeObject:self.idOrgName
                  forKey:@"idOrgName"];
    [aCoder encodeBool:self.isInfoComplete
                  forKey:@"isInfoComplete"];
    
    [aCoder encodeBool:self.phoneStar
                forKey:@"phoneStar"];
    [aCoder encodeBool:self.listenStar
                forKey:@"listenStar"];
    [aCoder encodeBool:self.locationStar
                forKey:@"locationStar"];
    
    [aCoder encodeObject:self.timePeriod
                  forKey:@"timePeriod"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        email       = [[aDecoder decodeObjectForKey:@"email"] copy];
        name        = [[aDecoder decodeObjectForKey:@"name"] copy];
        searchCode  = [[aDecoder decodeObjectForKey:@"searchCode"] copy];
        sex         = ((NSNumber *)[aDecoder decodeObjectForKey:@"sex"]).intValue;
        pf          = [[aDecoder decodeObjectForKey:@"pf"] copy];
        pfId        = ((NSNumber *) [aDecoder decodeObjectForKey:@"pfId"]).intValue;
        comment     = ((NSNumber *)[aDecoder decodeObjectForKey:@"comment"]).intValue;
        idNums      = [[aDecoder decodeObjectForKey:@"idNums"] copy];
        studentCount= ((NSNumber *)[aDecoder decodeObjectForKey:@"studentCount"]).intValue;
        mood        = [[aDecoder decodeObjectForKey:@"mood"] copy];
        headUrl     = [[aDecoder decodeObjectForKey:@"headUrl"] copy];
        deviceId    = [[aDecoder decodeObjectForKey:@"deviceId"] copy];
        expense     = ((NSNumber *)[aDecoder decodeObjectForKey:@"expense"]).intValue;
        isIos       = [aDecoder decodeBoolForKey:@"isIos"];
        isOnline    = [aDecoder decodeBoolForKey:@"isOnline"];
        latitude    = [[aDecoder decodeObjectForKey:@"latitude"] copy];
        longitude   = [[aDecoder decodeObjectForKey:@"longitude"] copy];
        phoneNums   = [[aDecoder decodeObjectForKey:@"phoneNums"] copy];
        info        = [[aDecoder decodeObjectForKey:@"info"] copy];
        teacherId   = [[aDecoder decodeObjectForKey:@"teacherId"] copy];
        goodCount   = ((NSNumber *)[aDecoder decodeObjectForKey:@"goodCount"]).intValue;
        badCount    = ((NSNumber *)[aDecoder decodeObjectForKey:@"badCount"]).intValue;
        certArray   = [[aDecoder decodeObjectForKey:@"certArray"] copy];
        isId        = [aDecoder decodeBoolForKey:@"isId"];
        idOrgName   = [[aDecoder decodeObjectForKey:@"idOrgName"] copy];
        isInfoComplete = [aDecoder decodeBoolForKey:@"isInfoComplete"];
        
        phoneStar    = [aDecoder decodeBoolForKey:@"phoneStar"];
        locationStar = [aDecoder decodeBoolForKey:@"locationStar"];
        listenStar   = [aDecoder decodeBoolForKey:@"listenStar"];
        
        timePeriod   = [[aDecoder decodeObjectForKey:@"timePeriod"] copy];
    }
    
    return self;
}

@end
