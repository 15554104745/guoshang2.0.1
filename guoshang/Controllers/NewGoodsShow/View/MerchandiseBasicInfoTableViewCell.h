//
//  MerchandiseBasicInfoTableViewCell.h
//  Demo
//
//  Created by suntao on 16/8/4.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailGoodsInfoModel.h"

extern NSString *const kMerchandiseBasicInfoTableViewCellIdentifier;

typedef void(^MerchandiseBasicInfoBlock)(NSInteger index);

@interface MerchandiseBasicInfoTableViewCell : UITableViewCell

@property (copy, nonatomic) MerchandiseBasicInfoBlock block;

@property (weak, nonatomic) IBOutlet UIImageView *guobiImageView;

@property (weak, nonatomic) IBOutlet UILabel *goods_name;

@property (weak, nonatomic) IBOutlet UILabel *goods_desc;

@property (weak, nonatomic) IBOutlet UILabel *goods_price;

@property (weak, nonatomic) IBOutlet UILabel *goods_originalprice;

@property (weak, nonatomic) IBOutlet UILabel *goods_hadsell;

@property (strong, nonatomic) GoodsDetailGoodsInfoModel *model;
//@property (copy, nonatomic) NSString *endTime;    // 活动结束时间
//original
//@property (assign, nonatomic) BOOL isEnd;   // 活动是否结束

// 更新活动结束时间
//- (void)updateActivityDateWithComponent:(NSDateComponents *)component;

@end
