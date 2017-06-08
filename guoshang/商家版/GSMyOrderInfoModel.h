//
//  GSMyOrderInfoModel.h
//  guoshang
//
//  Created by 金联科技 on 16/8/22.
//  Copyright © 2016年 hi. All rights reserved.
//订单详情页

#import <Foundation/Foundation.h>
@class GSPurchaseOrderModel;
@interface GSMyOrderInfoModel : NSObject
@property (nonatomic,strong) NSArray *purchase_goods;
@property (nonatomic,strong) GSPurchaseOrderModel *purchase_order;
@end


@interface GSMyOrderGoodsInfoModel : NSObject
@property (nonatomic,copy) NSString *goods_name;
@property (nonatomic,copy) NSString *goods_thumb;
@property (nonatomic,copy) NSString *goods_img;
@property (nonatomic,copy) NSString *original_img;
@property (nonatomic,copy) NSString *category_id;
@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *goods_num;
@property (nonatomic,copy) NSString *goods_price;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *order_time;
@property (nonatomic,copy) NSString *purchase_order_id;
@property (nonatomic,copy) NSString *state;
@end

@interface GSPurchaseOrderModel : NSObject
@property (nonatomic,copy) NSString *goods_num;
@property (nonatomic,copy) NSString *goods_total_price;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSString *order_state;
@property (nonatomic,copy) NSString *order_state_desc;
@property (nonatomic,copy) NSString *order_time;
@property (nonatomic,copy) NSString *pay_code;
@property (nonatomic,copy) NSString *pay_type;
@property (nonatomic,copy) NSString *shop_id;

@end