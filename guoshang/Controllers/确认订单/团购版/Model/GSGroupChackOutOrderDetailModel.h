//
//  GSGroupChackOutOrderDetailModel.h
//  guoshang
//
//  Created by Rechied on 16/9/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSGroupChackOutOrderGoodsInfoModel.h"
#import "GSGroupRuleModel.h"
#import "GSGroupChackOutOrderUserModel.h"
#import "GSChackOutOrderAddressModel.h"
#import "GSChackOutOrderSingleGoodsModel.h"

@interface GSGroupChackOutOrderDetailModel : NSObject

@property (strong, nonatomic) GSChackOutOrderAddressModel *address;

@property (copy, nonatomic) NSString *group_price;
@property (copy, nonatomic) NSString *max_user_amount;
@property (copy, nonatomic) NSString *audit_state;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSArray *group_user_list;
@property (copy, nonatomic) NSString *end_time;
@property (copy, nonatomic) NSString *remain_time;
@property (copy, nonatomic) NSString *create_price;
@property (copy, nonatomic) NSString *order_description;
@property (copy, nonatomic) NSString *total_purchases;
@property (copy, nonatomic) NSString *final_copies_amount;
@property (copy, nonatomic) NSString *group_purchase_number;
@property (strong, nonatomic) GSGroupChackOutOrderGoodsInfoModel *goods_info;
@property (copy, nonatomic) NSString *tag;
@property (copy, nonatomic) NSString *start_time_date;
@property (copy, nonatomic) NSString *grouppurchase_tmp_id;
@property (copy, nonatomic) NSString *user_num;
@property (copy, nonatomic) NSString *buy_num;
@property (copy, nonatomic) NSString *store_name;
@property (copy, nonatomic) NSString *max_copies_amount;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *each_amount;
@property (copy, nonatomic) NSString *goods_id;
@property (copy, nonatomic) NSString *final_user_amount;
@property (copy, nonatomic) NSString *shop_price;
@property (copy, nonatomic) NSArray *rule;
@property (copy, nonatomic) NSString *sponsor_id;
@property (copy, nonatomic) NSString *market_price;
@property (copy, nonatomic) NSString *start_time;
@property (copy, nonatomic) NSString *final_price;
@property (copy, nonatomic) NSString *shop_info_id;
@property (copy, nonatomic) NSString *is_buy;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *end_time_date;

//- (GSChackOutOrderSingleGoodsModel *)getSingleGoodsModel;
@end
