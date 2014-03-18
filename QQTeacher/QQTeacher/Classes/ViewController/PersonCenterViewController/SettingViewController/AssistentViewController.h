//
//  AssistentViewController.h
//  QQTeacher
//
//  Created by Lynn on 14-3-17.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomView : UIView
{
    UIImageView *titleImgView;
    UIImageView *lightImgView;
    UILabel *firstLab;
    UILabel *secondLab;
    UILabel *thirdLab;
}
@end

@interface AssistentViewController : UIViewController<
                                                    MBProgressHUDDelegate,
                                                    AssistentCellDelegate,
                                                    TTImageViewDelegate,
                                                    ServerRequestDelegate,
                                                    EGORefreshTableHeaderDelegate,
                                                    UITableViewDelegate,
                                                    UITableViewDataSource>
{
    UITableView     *latlyTab;
    NSDictionary    *ccDic;
    NSMutableArray  *applyArray;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    UIImageView   *bgImgView;
    
    NSMutableArray *headArray;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
