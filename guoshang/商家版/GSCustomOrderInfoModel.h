//
//  GSCustomOrderInfoModel.h
//  guoshang
//
//  Created by 金联科技 on 16/8/18.
//  Copyright © 2016年 hi. All rights reserved.
//客户订单详情页MOdel

#import <Foundation/Foundation.h>

@interface GSCustomOrderInfoModel : NSObject
//订单编号
@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSString *order_sn;
//订单日期
@property (nonatomic,copy) NSString *add_time;
//收货人
@property (nonatomic,copy) NSString *consignee;
//电话
@property (nonatomic,copy) NSString *tel;
//配送方式
@property (nonatomic,copy) NSString *shipping_name;
//付款方式
@property (nonatomic,copy) NSString *pay_name;
//收货地址
@property (nonatomic,copy) NSString *strAddress;
//订单付款状态
@property (nonatomic,copy) NSString *order_status;
//应付金额
@property (nonatomic,copy) NSString *order_amount;
//产品列表
@property (nonatomic,strong) NSArray *goods_list;

@end


@interface GSCustomGoodsInfoModel : NSObject
//名称
@property (nonatomic, copy) NSString *goods_name;
//数量
@property (nonatomic, copy) NSString *goods_number;
//以前的价钱
@property (nonatomic, copy) NSString *market_price;
//现价
@property (nonatomic, copy) NSString *goods_price;

@property (nonatomic, copy) NSString *goods_thumb;
//产品ID
@property (nonatomic, copy) NSString *goods_id;
//收藏的人数
@property (nonatomic, copy) NSString *collect;
//销量
@property (nonatomic, copy) NSString *sale_num;
@end
