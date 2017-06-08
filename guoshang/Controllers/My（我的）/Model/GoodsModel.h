//
//  goodsModel.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/16.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"
#import "GoodsModel.h"

@interface GoodsModel : JSONModel

@property(nonatomic,copy)NSString * shipping_price;//运费
@property(nonatomic,copy)NSString * goods_thumb;//商品图片
@property(nonatomic,copy)NSString * goods_id;//商品ID
@property(nonatomic,copy)NSString * exchange_integral;//兑换金额
@property(nonatomic,copy)NSString * rec_id;// 订单商品信息自增id
@property(nonatomic,copy)NSString *  order_id;///订单商品信息对应的详细信息id
@property(nonatomic,copy)NSString * goods_name;//商品的名称
@property(nonatomic,copy)NSString * goods_sn;//商品货号
@property(nonatomic,copy)NSString * product_id;//产品ID
@property(nonatomic,copy)NSString * goods_number;//订购数量
@property(nonatomic,copy)NSString * market_price; //商品的市场价
@property(nonatomic,copy)NSString * goods_price;//商品的本店价
@property(nonatomic,copy)NSString * send_number;//发货数量
@property(nonatomic,copy)NSString * is_real;//是否是实物
@property(nonatomic,copy)NSString * extension_code;//商品的扩展属性
@property(nonatomic,copy)NSString * is_gift;//是否参加优惠活动
@property(nonatomic,copy)NSString * goods_attr_id;//商品属性ID
@property(nonatomic,copy)NSString * attr_names;//商品规格
@property(nonatomic,copy)NSString * shop_title;//商店名称
@property(nonatomic,copy)NSString * shop_image;//店铺图像
@property(nonatomic,copy)NSString * goods_list;//商品
@property(nonatomic,copy)NSString * is_shipping;//配送方式
@end
