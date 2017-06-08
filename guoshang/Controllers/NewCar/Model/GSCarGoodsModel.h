//
//  GSCarGoodsModel.h
//  guoshang
//
//  Created by Rechied on 2016/11/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSCarGoodsModel : NSObject

@property (copy, nonatomic) NSString *is_shipping;
@property (copy, nonatomic) NSString *session_id;
@property (copy, nonatomic) NSString *extension_code;
@property (copy, nonatomic) NSString *goods_attr_id;
@property (copy, nonatomic) NSString *shop_id;
@property (copy, nonatomic) NSString *goods_thumb;
@property (copy, nonatomic) NSString *user_id;
@property (copy, nonatomic) NSString *market_price;
@property (copy, nonatomic) NSString *is_real;
@property (copy, nonatomic) NSString *goods_name;
@property (copy, nonatomic) NSString *goods_attr;
@property (copy, nonatomic) NSString *parent_id;
@property (copy, nonatomic) NSString *rec_type;
@property (copy, nonatomic) NSString *grouppurchase_id;
@property (copy, nonatomic) NSString *d_price;
@property (copy, nonatomic) NSString *shop_title;
@property (copy, nonatomic) NSString *goods_img;
@property (copy, nonatomic) NSString *subtotal_z;
@property (copy, nonatomic) NSString *product_id;
@property (copy, nonatomic) NSString *getShopLogo;
@property (copy, nonatomic) NSString *subtotal;
@property (copy, nonatomic) NSString *purchase_price;
@property (copy, nonatomic) NSString *is_gift;
@property (copy, nonatomic) NSString *goods_price;
@property (copy, nonatomic) NSString *goods_id;
@property (copy, nonatomic) NSString *goods_number;
@property (copy, nonatomic) NSString *shipping_price;
@property (copy, nonatomic) NSString *pid;
@property (copy, nonatomic) NSString *can_handsel;
@property (copy, nonatomic) NSString *attr_names;
@property (copy, nonatomic) NSString *goods_sn;
@property (copy, nonatomic) NSString *rec_id;
@property (copy, nonatomic) NSString *store_number;

@property (assign, nonatomic) BOOL select_goods;
- (NSString *)getGoodsTotalPrice;
@end
