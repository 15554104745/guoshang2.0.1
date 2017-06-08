//
//  HomeModel.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"

@interface HomeModel : NSObject

@property(nonatomic,copy)NSString * goods_id;
@property(nonatomic,copy)NSString * promote_price;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * short_name;
@property(nonatomic,copy)NSString * market_price;
@property(nonatomic,copy)NSString * shop_price;
@property(nonatomic,copy)NSString * thumb;
@property(nonatomic,copy)NSString * goods_img;
@property(nonatomic,copy)NSString * image_url;
@property(nonatomic,copy)NSString * cat_id;//分组的广告图id
@property(nonatomic,copy)NSString * ad_image;//分组的广告图的图片
@property(nonatomic,copy)NSArray * goods_list;
//@property(nonatomic,copy)NSArray<Optional> * goods_id;
///商家版首页数据
@property(nonatomic,copy)NSString * color;
@property(nonatomic,copy)NSString * goods_name;//商品名称
@property(nonatomic,copy)NSString * goods_sn;//编号
@property(nonatomic,copy)NSString * purchase_price;//价格
@property(nonatomic,copy)NSString * goods_thumb;//图片
@property(nonatomic,copy)NSString*original_img;
@end
