//
//  TeacherOrderSectionController.m
//  QQStudent
//
//  Created by lynn on 14-2-12.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "TeacherOrderSectionController.h"

@interface TeacherOrderSectionController ()
@end

@implementation TeacherOrderSectionController
@synthesize ordersArr;
@synthesize teacherOrderDic;

- (Teacher *) packageTeacher:(NSDictionary *) dic
{
    Teacher *tObj = [Teacher setTeacherProperty:dic];
    
    NSString *expense = [[dic objectForKey:@"teacher_expense"] copy];
    if (expense)
        tObj.expense  = expense.integerValue;
    else
        tObj.expense  = 0;
    
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url = [dic objectForKey:@"teacher_icon"];
    if (url)
        tObj.headUrl  = [NSString stringWithFormat:@"%@%@",webAdd,url];
    else
        tObj.headUrl  = @"";
    
    NSString *idNums  = [[dic objectForKey:@"teacher_idnumber"] copy];
    if (idNums)
        tObj.idNums   = idNums;
    else
        tObj.idNums   = @"";
    
    NSString *info = [[dic objectForKey:@"teacher_info"] copy];
    if (info)
        tObj.info  = info;
    else
        tObj.info  = @"";
    
    NSString *name = [[dic objectForKey:@"teacher_name"]  copy];
    if (name)
        tObj.name = name;
    else
        tObj.name = @"";
    
    NSString *phone = [[dic objectForKey:@"teacher_phone"] copy];
    if (phone)
        tObj.phoneNums = phone;
    else
        tObj.phoneNums = @"";
    
    NSString *comment = [dic objectForKey:@"teacher_stars"];
    if (comment)
        tObj.comment  = comment.integerValue;
    else
        tObj.comment  = 0;

    NSString *pf  = [[dic objectForKey:@"teacher_subjectText"] copy];
    if (pf)
        tObj.pf = pf;
    else
        tObj.pf = @"";
    
    NSString *isId= [[dic objectForKey:@"type_stars"] copy];
    if (isId)
    {
        if (isId.integerValue==1)
            tObj.isId = YES;
        else
            tObj.isId = NO;
    }
    
    NSString *orgName = [[dic objectForKey:@"teacher_type_text"] copy];
    if (orgName)
        tObj.idOrgName = orgName;
    else
        tObj.idOrgName = @"";
    
    return tObj;
}

- (NSUInteger)contentNumberOfRow
{
    return [self.ordersArr count];
}

- (void)didSelectContentCellAtRow:(NSUInteger)row
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (float)heightForRow:(NSUInteger)row
{
//    if (row != 0)   //代表订单Cell
//    {
//        NSDictionary *orderDic = [self.ordersArr objectAtIndex:row-1];
//        Order *order  = [Order setOrderProperty:orderDic];
//        
//        NSDictionary *studentDic = [teacherOrderDic objectForKey:@"student"];
//        order.student = [Student setPropertyStudent:studentDic];
//    
////        if (order.orderStatus==FINISH)
////        {
////            return 65;
////        }
//    }
    
    if (!iPhone5)
        return 115;
    else
        return 125;
}

- (UITableViewCell *) cellForRow:(NSUInteger)row
{
    static NSString *idString    = @"idString";
    if (row == 0)   //代表老师
    {        
        NSDictionary *studentDic = [teacherOrderDic objectForKey:@"student"];
        
        //获得最近订单
        Order *order   = nil;
        Student *student = [Student setPropertyStudent:studentDic];
        if (ordersArr.count>0)
        {
            order  = [Order setOrderProperty:teacherOrderDic];
            order.student = [student copy];
        }
        else
        {
            order = [[Order alloc]init];
            order.student = student;
        }
        CLog(@"sdfjsdfjisdfjsi:student:%@", student.nickName);
        MyTeacherCell *cell = [[[MyTeacherCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:idString]autorelease];
        cell.order    = order;
        return cell;
    }
    else            //代表订单
    {
        NSDictionary *orderDic = [self.ordersArr objectAtIndex:row-1];
        Order *order  = [Order setOrderProperty:orderDic];
    
        NSDictionary *studentDic = [teacherOrderDic objectForKey:@"student"];
        order.student = [Student setPropertyStudent:studentDic];

        TeacherOrderCell *cell = [[[TeacherOrderCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:idString
                                                              withParent:self.tableView]autorelease];
        cell.delegate       = self;
        cell.order          = order;
//        cell.commView.idStr = [order.orderId retain];
        
        return cell;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Getters
- (void)dealloc
{
    [self.ordersArr release];
    [super dealloc];
}

#pragma mark -
#pragma mark - TeacherOrderCellDelegate
- (void) cell:(TeacherOrderCell *)cell buttonTag:(NSInteger)tag
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    
    //根据订单状态,结单还是确认
    switch (cell.order.orderStatus)
    {
        case NO_CONFIRM:     //未确认,去确认
        {
            OrderConfirmViewController *orderConfirmVctr = [[OrderConfirmViewController alloc]init];
            orderConfirmVctr.order = cell.order;
            [nav presentPopupViewController:orderConfirmVctr animationType:MJPopupViewAnimationFade];
            break;
        }
        case CONFIRMED:
        case NO_FINISH:      //未结单,去结单
        {
            OrderFinishViewController *orderFinishVctr = [[OrderFinishViewController alloc]init];
            orderFinishVctr.order = cell.order;
            [nav pushViewController:orderFinishVctr animated:YES];
            [orderFinishVctr release];
            break;
        }
        default:
            break;
    }
}
@end
