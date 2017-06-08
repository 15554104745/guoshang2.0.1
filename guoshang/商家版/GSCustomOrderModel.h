//
//  GSCustomOrderModel.h
//  guoshang
//
//  Created by 金联科技 on 16/7/27.
//  Copyright © 2016年 hi. All rights reserved.
//客户订单列表Model


#import <Foundation/Foundation.h>

@interface GSCustomOrderModel : NSObject

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *consignee;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *o_status;
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, strong) NSArray *goods_list;  //里面是GoodsModel

@end
@interface GSCustomGoodsModel : NSObject

@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *goods_number;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *integral;
@property (nonatomic, copy) NSString *exchange_integral;

@end



