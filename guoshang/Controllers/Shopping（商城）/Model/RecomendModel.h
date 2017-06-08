//
//  RecomendModel.h
//  guoshang
//
//  Created by 张涛 on 16/3/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"

@interface RecomendModel : NSObject

@property(nonatomic,copy)NSString * shop_price;//价格
@property(nonatomic,copy)NSString * name;//商品的名称
@property(nonatomic,copy)NSString * goods_img;//商品图
@property(nonatomic,copy)NSString * goods_thumb;//商品图
@property(nonatomic,copy)NSString * goods_id;//商品id

@end
