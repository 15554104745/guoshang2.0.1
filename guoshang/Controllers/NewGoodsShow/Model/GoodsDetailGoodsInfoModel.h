//
//  GoodsDetailGoodsInfoModel.h
//  guoshang
//
//  Created by JinLian on 16/9/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GoodsDetailGoodsInfoModel : JSONModel

@property (nonatomic, copy)NSString <Optional>*add_time;
@property (nonatomic, copy)NSString <Optional>*bonus_type_id;
@property (nonatomic, copy)NSString <Optional>*brand_id;
@property (nonatomic, copy)NSString <Optional>*cat_id;
@property (nonatomic, copy)NSString <Optional>*click_count;
@property (nonatomic, copy)NSString <Optional>*exchange_integral;
@property (nonatomic, copy)NSString <Optional>*extension_code;
@property (nonatomic, copy)NSString <Optional>*give_integral;
@property (nonatomic, copy)NSString <Optional>*gmt_end_time;
@property (nonatomic, copy)NSString <Optional>*goods_attr_desc;     //商品参数
@property (nonatomic, copy)NSString <Optional>*goods_brand;
@property (nonatomic, copy)NSString <Optional>*goods_brief;
@property (nonatomic, copy)NSString <Optional>*goods_desc;          //商品图文
@property (nonatomic, copy)NSString <Optional>*goods_id;
@property (nonatomic, copy)NSString <Optional>*goods_img;           //商品图
@property (nonatomic, copy)NSString <Optional>*goods_name;
@property (nonatomic, copy)NSString <Optional>*goods_name_style;
@property (nonatomic, copy)NSString <Optional>*goods_number;
@property (nonatomic, copy)NSString <Optional>*goods_sn;
@property (nonatomic, copy)NSString <Optional>*goods_thumb;
@property (nonatomic, copy)NSString <Optional>*goods_type;
@property (nonatomic, copy)NSString <Optional>*goods_weight;
@property (nonatomic, copy)NSString <Optional>*group_personnel_price;
@property (nonatomic, copy)NSString <Optional>*group_price;
@property (nonatomic, copy)NSString <Optional>*integral;            //赠送国币的数量
@property (nonatomic, copy)NSString <Optional>*is_alone_sale;
@property (nonatomic, copy)NSString <Optional>*keywords;
@property (nonatomic, copy)NSString <Optional>*last_update;
@property (nonatomic, copy)NSString <Optional>*market_price;
@property (nonatomic, copy)NSString <Optional>*measure_unit;
@property (nonatomic, copy)NSString <Optional>*on_exchange;
@property (nonatomic, copy)NSString <Optional>*original_img;
@property (nonatomic, copy)NSString <Optional>*promote_end_date;
@property (nonatomic, copy)NSString <Optional>*promote_price;
@property (nonatomic, copy)NSString <Optional>*promote_price_org;
@property (nonatomic, copy)NSString <Optional>*promote_start_date;
@property (nonatomic, copy)NSString <Optional>*provider_name;
@property (nonatomic, copy)NSString <Optional>*publish_source;
@property (nonatomic, copy)NSString <Optional>*purchase_price;        //进货价
@property (nonatomic, copy)NSString <Optional>*rank_integral;
@property (nonatomic, copy)NSString <Optional>*sale_number;
@property (nonatomic, copy)NSString <Optional>*seller_note;
@property (nonatomic, copy)NSString <Optional>*shipping_price;
@property (nonatomic, copy)NSString <Optional>*shipping_rule;
@property (nonatomic, copy)NSString <Optional>*shipping_template_id;
@property (nonatomic, copy)NSString <Optional>*shop_cat_id;
@property (nonatomic, copy)NSString <Optional>*shop_id;
@property (nonatomic, copy)NSString <Optional>*shop_price;           //卖价国币
@property (nonatomic, copy)NSString <Optional>*shop_price_formated;  //卖价标准
@property (nonatomic, copy)NSString <Optional>*sort_order;
@property (nonatomic, copy)NSString <Optional>*suppliers_id;
@property (nonatomic, copy)NSString <Optional>*warn_number;
@property (nonatomic, assign)BOOL is_best;
@property (nonatomic, assign)BOOL is_check;
@property (nonatomic, assign)BOOL is_delete;
@property (nonatomic, assign)BOOL is_exchange;
@property (nonatomic, assign)BOOL is_give_integral;
@property (nonatomic, assign)BOOL is_group;
@property (nonatomic, assign)BOOL is_hot;
@property (nonatomic, assign)BOOL is_hours_shipping;
@property (nonatomic, assign)BOOL is_new;
@property (nonatomic, assign)BOOL is_on_sale;
@property (nonatomic, assign)BOOL is_promote;               //秒杀
@property (nonatomic, assign)BOOL is_real;
@property (nonatomic, assign)BOOL is_recharge_card_pay;     //是否支持充值卡
@property (nonatomic, assign)BOOL is_shipping;
@property (nonatomic, assign)BOOL iscollect;                //商品是否被收藏
















@end
