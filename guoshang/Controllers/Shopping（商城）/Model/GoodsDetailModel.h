//
//  GoodsDetailModel.h
//  guoshang
//
//  Created by 张涛 on 16/3/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"

@interface GoodsDetailModel : JSONModel

@property(nonatomic,copy)NSString * shipping_price;//运费
@property(nonatomic,copy)NSString * cat_id;//商品分类id
@property(nonatomic,copy)NSString * goods_id;//商品ID
@property(nonatomic,copy)NSString * attr_id;//属性ID
@property(nonatomic,copy)NSString * rec_id;//属性ID
@property(nonatomic,copy)NSString * goods_name;//商品的名称
@property(nonatomic,copy)NSString * market_price; //商品的市场价标价
@property(nonatomic,copy)NSString * goods_price;//商品的本店价
@property(nonatomic,copy)NSString * send_number;//发货数量
@property(nonatomic,copy)NSNumber * is_exchange;//商品的类型
@property(nonatomic,copy)NSNumber * is_give_integral;//是否为特卖
@property(nonatomic,copy)NSString * is_gift;//是否参加优惠活动
@property(nonatomic,copy)NSString * goods_attr_id;//商品属性ID
@property(nonatomic,copy)NSString * goods_brief;//商品描述
@property(nonatomic,copy)NSString * shop_price_formated;//卖价标准
@property(nonatomic,copy)NSString * shop_price;//卖价国币
@property(nonatomic,copy)NSString * d_price;//赠送国币
@property(nonatomic,copy)NSString * goods_img;//商品图
@property(nonatomic,copy)NSString * goods_desc;//商品图文
@property(nonatomic,copy)NSString * goods_attr_desc;//商品参数
@property(nonatomic,assign)BOOL iscollect;//商品是否被收藏
@property(nonatomic,copy)NSString * purchase_price;//进货价
@property(nonatomic,copy)NSString *is_promote; //秒杀
@property(nonatomic,copy)NSString *promote_price;
@property(nonatomic,copy)NSString *integral; //赠送国币的数量
@property(nonatomic,copy)NSString *is_recharge_card_pay;//是否支持充值卡
//@property(nonatomic,copy)NSString *shop_price;

@end
