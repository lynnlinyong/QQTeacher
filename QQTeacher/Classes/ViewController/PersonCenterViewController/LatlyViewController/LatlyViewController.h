//
//  LatlyViewController.h
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LatlyViewController : UIViewController<
                                                MBProgressHUDDelegate,
                                                LatlyViewCellDelegate,
                                                TTImageViewDelegate,
                                                ServerRequestDelegate,
                                                EGORefreshTableHeaderDelegate,
                                                UITableViewDelegate,
                                                UITableViewDataSource>
{
    UITableView     *latlyTab;
    NSDictionary    *sysDic;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    UIImageView *bgImgView;
    
    NSMutableArray *headArray;
}

@property (nonatomic, copy) NSMutableArray  *msgArray;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
