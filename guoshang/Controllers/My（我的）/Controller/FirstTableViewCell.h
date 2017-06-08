//
//  FirstTableViewCell.h
//  guoshang
//
//  Created by JinLian on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyNewModel.h"

#define FirstTableViewCellNotifaction  @"firstTableViewCell"

@interface FirstTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *group_name;

@property (weak, nonatomic) IBOutlet UILabel *group_price;

@property (weak, nonatomic) IBOutlet UILabel *group_orignPrice;

@property (weak, nonatomic) IBOutlet UILabel *group_time;

@property (weak, nonatomic) IBOutlet UILabel *group_one;

@property (weak, nonatomic) IBOutlet UILabel *group_five;

@property (weak, nonatomic) IBOutlet UILabel *group_ten;

@property (weak, nonatomic) IBOutlet UILabel *group_more;

@property (nonatomic, strong)NSDictionary *dataList;

//剩余时间
@property (nonatomic, strong)NSDictionary *timeArr;
//相册
@property (nonatomic, strong)NSArray *goods_gallery;
//团购规则
@property (nonatomic, strong)NSArray *group_rule;

@property (nonatomic, strong)BuyNewModel *model;

@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, weak)NSTimer *timer;
@property (nonatomic, assign)BOOL  m_isDisplayed;

- (void)loadData:(id)data index:(NSInteger)section;

@end
