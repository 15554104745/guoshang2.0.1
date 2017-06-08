//
//  GSMyOrderModel.h
//  guoshang
//
//  Created by 金联科技 on 16/7/27.
//  Copyright © 2016年 hi. All rights reserved.
//订单列表

#import <Foundation/Foundation.h>
#import "GSShopModel.h"
@interface GSMyOrderModel : NSObject
@property (nonatomic,copy) NSString *shop_id; 
@property (nonatomic,copy) NSString *pay_type;
@property (nonatomic,copy) NSString *pay_code;
@property (nonatomic,copy) NSString *order_time;
@property (nonatomic,copy) NSString *order_state;
@property (nonatomic,copy) NSString *goods_total_price;
@property (nonatomic,copy) NSString *goods_num;
@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSArray *goods_list;
@property (nonatomic,strong) GSShopModel *supplier;
@property (copy, nonatomic) NSString *ID;
@end


@interface GSMyGoodModel : NSObject


@property (nonatomic,copy) NSString *category_id;

@property (nonatomic,copy) NSString *goods_id;

@property (nonatomic,copy) NSString *goods_num;

@property (nonatomic,copy) NSString *goods_price;

@property (nonatomic,copy) NSString *order_time;

@property (nonatomic,copy) NSString *purchase_order_id;

@property (nonatomic,copy) NSString *state;

@property (nonatomic,copy) NSString *goods_name;

@property (nonatomic,copy) NSString *goods_img;

@end
