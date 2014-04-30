//
//  LatlyViewCell.h
//  QQStudent
//
//  Created by lynn on 14-3-1.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AssistentCell;
@protocol AssistentCellDelegate <NSObject>

- (void) view:(AssistentCell *) view clickedIndex:(int) index;

@end

@interface AssistentCell : UITableViewCell
{
    UIImageView *headImgView;
    UILabel *timeLab;
    UILabel *infoLab;
    UILabel *nameLab;
}

@property (nonatomic, assign) id<AssistentCellDelegate> delegate;
@property (nonatomic, copy) NSDictionary *applyDic;
@property (nonatomic, retain) UIImageView *headImgView;
@end
