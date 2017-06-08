//
//  GSChackOutOrderTotalModel.h
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSChackOutOrderTotalModel : NSObject

@property (copy, nonatomic) NSString *total_give_integral;
@property (copy, nonatomic) NSString *shipping_price;
@property (copy, nonatomic) NSString *z_goods_count;
@property (copy, nonatomic) NSString *total_exchange_integral;
@property (copy, nonatomic) NSString *purchase_price;
@property (copy, nonatomic) NSString *real_goods_count;
@property (copy, nonatomic) NSString *market_price;
@property (copy, nonatomic) NSString *saving;
@property (copy, nonatomic) NSString *goods_price;
@property (copy, nonatomic) NSString *save_rate;
@property (copy, nonatomic) NSString *virtual_goods_count;
@property (copy, nonatomic) NSString *goods_amount;
@property (copy, nonatomic) NSString *order_amount;
@property (copy, nonatomic) NSString *total_goods_num;

@property (copy, nonatomic) NSString *Deliver;



@property (assign, nonatomic) GSChackOutOrderType chackOutOrderType;

@end
