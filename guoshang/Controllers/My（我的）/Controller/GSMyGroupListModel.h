//
//  GSMyGroupListModel.h
//  guoshang
//
//  Created by Rechied on 16/9/6.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSMyGroupGoodsModel.h"

@interface GSMyGroupListModel : NSObject


@property (copy, nonatomic) NSString *group_list_description;
@property (copy, nonatomic) NSString *real_name;
@property (copy, nonatomic) NSString *store_name;
@property (copy, nonatomic) NSString *group_price;
@property (copy, nonatomic) NSString *group_purchase_number;
@property (copy, nonatomic) NSString *start_tamp;
@property (copy, nonatomic) NSString *remain_time;
@property (copy, nonatomic) NSString *start_time;
@property (copy, nonatomic) NSString *end_tamp;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *user_name;
@property (copy, nonatomic) NSString *group_id;
@property (copy, nonatomic) NSString *end_time;

@property (copy, nonatomic) NSString *user_num;
@property (copy, nonatomic) NSString *status;

@property (strong, nonatomic) GSMyGroupGoodsModel *goods_data;

@end
