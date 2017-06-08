//
//  GSCarModel.h
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSCarModel : NSObject
@property(nonatomic,copy)NSString * rec_id;//ID自动增长
@property(nonatomic,copy)NSString * shop_id;//用户ID
//@property(nonatomic,copy)NSString * session_id;//如果该用户退出,该Session_id对应的购物车中所有记录都将被删除
@property(nonatomic,copy)NSString * goods_id;//商品的ID
@property(nonatomic,copy)NSString * goods_sn;//商品的货号
//@property(nonatomic,copy)NSString * product_id;//产品ID
@property(nonatomic,copy)NSString * goods_name;//产品名字
@property(nonatomic,copy)NSString * market_price;//商品的本店价
@property(nonatomic,copy)NSString * goods_price;//商品实际价格
@property(nonatomic,copy)NSString * goods_number;//商品的数量
@property(nonatomic,copy)NSString * goods_attr;//采购价
@property(nonatomic,copy)NSString * goods_attr_id;
@property(nonatomic,copy)NSString * add_time;
@property(nonatomic,copy)NSString * subtotal_z;
@property(nonatomic,copy)NSString * subtotal;
@property(nonatomic,copy)NSString * goods_thumb;//商品图片
@property(nonatomic,copy)NSString * shipping_price;//运费
@property(nonatomic,copy)NSString * attr_names;//规格
@property(nonatomic,copy)NSString * shop;//门店信息
@property(nonatomic,copy)NSString * goods_img;
@property(nonatomic,copy)NSString * shop_title;//门店信息
@property(nonatomic,copy)NSString * getShopLogo;//门店信息
@property(nonatomic,assign)BOOL isSelect;

+(instancetype)ModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
