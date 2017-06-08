//
//  GSOrderGoodsModel.h
//  guoshang
//
//  Created by Rechied on 16/8/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSOrderGoodsModel : NSObject

@property (copy, nonatomic) NSString *goods_attr_id;
@property (copy, nonatomic) NSString *extension_code;
@property (copy, nonatomic) NSString *shop_id;
@property (copy, nonatomic) NSString *goods_thumb;
@property (copy, nonatomic) NSString *send_number;
@property (copy, nonatomic) NSString *market_price;
@property (copy, nonatomic) NSString *is_real;
@property (copy, nonatomic) NSString *goods_name;
@property (copy, nonatomic) NSString *goods_attr;
@property (copy, nonatomic) NSString *parent_id;
@property (copy, nonatomic) NSString *grouppurchase_id;
@property (copy, nonatomic) NSString *sale_num;
@property (copy, nonatomic) NSString *shop_title;
@property (copy, nonatomic) NSString *shop_phone;
@property (copy, nonatomic) NSString *order_id;
@property (copy, nonatomic) NSString *goods_img;
@property (copy, nonatomic) NSString *product_id;
@property (copy, nonatomic) NSString *is_gift;
@property (copy, nonatomic) NSString *goods_number;
@property (copy, nonatomic) NSString *goods_id;
@property (copy, nonatomic) NSString *goods_price;
@property (copy, nonatomic) NSString *shoplogo;
@property (copy, nonatomic) NSString *collect;
@property (copy, nonatomic) NSString *original_img;
@property (copy, nonatomic) NSString *goods_sn;
@property (copy, nonatomic) NSString *rec_id;
@property (copy, nonatomic) NSString *exchange_integral;
@property (copy, nonatomic) NSString *total_exchange_integral;
- (BOOL)isGuoBiPayType;
@end


