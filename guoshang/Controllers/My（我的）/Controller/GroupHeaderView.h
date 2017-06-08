//
//  GroupHeaderView.h
//  guoshang
//
//  Created by JinLian on 16/8/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadModel.h"

#define NOTIFICATION_TIME_CELL  @"NotificationTimeCell"

@interface GroupHeaderView : UIView


@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, weak)NSTimer *timer;
@property (nonatomic, retain)HeadModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *group_image;
@property (weak, nonatomic) IBOutlet UILabel *group_name;
@property (weak, nonatomic) IBOutlet UILabel *group_count;
@property (weak, nonatomic) IBOutlet UILabel *group_time;
@property (weak, nonatomic) IBOutlet UILabel *group_shopName;

@property (nonatomic, weak) NSIndexPath *m_indexPath;

@property (nonatomic, assign)BOOL  m_isDisplayed;

- (void)loadData:(id)data index:(NSInteger)section;
@end
