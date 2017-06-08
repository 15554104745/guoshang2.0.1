//
//  GSGoodsDetailGoodsInfoModel.h
//  guoshang
//
//  Created by Rechied on 2016/11/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSGoodsDetailGoodsInfoModel : NSObject

@property (copy, nonatomic) NSString *seller_note;
@property (copy, nonatomic) NSString *bonus_type_id;
@property (copy, nonatomic) NSString *warn_number;
@property (copy, nonatomic) NSString *is_shipping;
@property (copy, nonatomic) NSString *iscollect;
@property (copy, nonatomic) NSString *is_promote;
@property (copy, nonatomic) NSString *purchase_price;
@property (copy, nonatomic) NSString *measure_unit;
@property (copy, nonatomic) NSString *give_integral;
@property (copy, nonatomic) NSString *original_img;
@property (copy, nonatomic) NSString *integral;
@property (copy, nonatomic) NSString *goods_brand;
@property (copy, nonatomic) NSString *is_real;
@property (copy, nonatomic) NSString *goods_type;
@property (copy, nonatomic) NSString *promote_start_date;
@property (copy, nonatomic) NSString *goods_number;
@property (copy, nonatomic) NSString *is_new;
@property (copy, nonatomic) NSString *shop_cat_id;
@property (copy, nonatomic) NSString *sale_number;
@property (copy, nonatomic) NSString *suppliers_id;
@property (copy, nonatomic) NSString *provider_name;
@property (copy, nonatomic) NSString *goods_desc;
@property (copy, nonatomic) NSString *is_exchange;
@property (copy, nonatomic) NSString *cat_id;
@property (copy, nonatomic) NSString *goods_attr_desc;
@property (copy, nonatomic) NSString *is_best;
@property (copy, nonatomic) NSString *shop_price;
@property (copy, nonatomic) NSString *gmt_end_time;
@property (copy, nonatomic) NSString *goods_sn;
@property (copy, nonatomic) NSString *is_check;
@property (copy, nonatomic) NSString *goods_brief;
@property (copy, nonatomic) NSString *is_hot;
@property (copy, nonatomic) NSString *add_time;
@property (copy, nonatomic) NSString *is_group;
@property (copy, nonatomic) NSString *goods_id;
@property (copy, nonatomic) NSString *goods_weight;
@property (copy, nonatomic) NSString *promote_end_date;
@property (copy, nonatomic) NSString *market_price;
@property (copy, nonatomic) NSString *exchange_integral;
@property (copy, nonatomic) NSString *click_count;
@property (copy, nonatomic) NSString *goods_thumb;
@property (copy, nonatomic) NSString *is_delete;
@property (copy, nonatomic) NSString *extension_code;
@property (copy, nonatomic) NSString *sort_order;
@property (copy, nonatomic) NSString *is_hours_shipping;
@property (copy, nonatomic) NSString *publish_source;
@property (copy, nonatomic) NSString *promote_price;
@property (copy, nonatomic) NSString *promote_price_org;
@property (copy, nonatomic) NSString *shipping_price;
@property (copy, nonatomic) NSString *is_on_sale;
@property (copy, nonatomic) NSString *goods_name;
@property (copy, nonatomic) NSString *is_give_integral;
@property (copy, nonatomic) NSString *on_exchange;
@property (copy, nonatomic) NSString *is_recharge_card_pay;
@property (copy, nonatomic) NSString *goods_name_style;
@property (copy, nonatomic) NSString *keywords;
@property (copy, nonatomic) NSString *rank_integral;
@property (copy, nonatomic) NSString *last_update;
@property (copy, nonatomic) NSString *shop_id;
@property (copy, nonatomic) NSString *group_personnel_price;
@property (copy, nonatomic) NSString *shop_price_formated;
@property (copy, nonatomic) NSString *shipping_template_id;
@property (copy, nonatomic) NSString *goods_img;
@property (copy, nonatomic) NSString *group_price;
@property (copy, nonatomic) NSString *is_alone_sale;
@property (copy, nonatomic) NSString *brand_id;

@property (copy, nonatomic) NSString *goods_sales;
@property (copy, nonatomic) NSString *favorable_rate;

- (NSString *)getShowPrice;
@end
