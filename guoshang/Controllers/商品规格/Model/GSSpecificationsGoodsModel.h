//
//  GSSpecificationsGoodsModel.h
//  guoshang
//
//  Created by Rechied on 2016/11/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSSingleSpecificationsModel.h"

@interface GSSpecificationsGoodsModel : NSObject
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *shipping_price;
@property (copy, nonatomic) NSString *is_promote;
@property (copy, nonatomic) NSString *is_exchange;
//@property (copy, nonatomic) NSArray <__kindof GSSingleSpecificationsModel *>*goods_attribute;
@property (copy, nonatomic) NSDictionary *goods_attribute;
@property (copy, nonatomic) NSString *goods_number;
@property (copy, nonatomic) NSString *object_ids;
@property (copy, nonatomic) NSString *object_names;
@property (copy, nonatomic) NSString *promote_end_date;
@property (copy, nonatomic) NSString *purchase_price;
@property (copy, nonatomic) NSString *promote_price;
@property (copy, nonatomic) NSString *market_price;
@property (copy, nonatomic) NSString *promote_start_date;
@property (copy, nonatomic) NSString *is_del;
@property (copy, nonatomic) NSString *exchange_integral;
@property (copy, nonatomic) NSString *goods_id;
@property (copy, nonatomic) NSString *attribute_key;
@property (copy, nonatomic) NSString *goods_attr_id;
@property (copy, nonatomic) NSString *shop_price;

@end
