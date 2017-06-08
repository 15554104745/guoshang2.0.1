//
//  TotalModel.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"
#import "BaseModel.h"

@interface TotalModel : BaseModel


@property(nonatomic,copy)NSString * goods_price;//商品总价
@property(nonatomic,copy)NSString * market_price;
@property(nonatomic,copy)NSString * saving;
@property(nonatomic,copy)NSString * save_rate;
@property(nonatomic,copy)NSString *  goods_amount;
@property(nonatomic,copy)NSString * g_price;//国币
@property(nonatomic,copy)NSString * purchase_price;
@property(nonatomic,copy)NSString * shipping_price;//运费
@property(nonatomic,copy)NSString * virtual_goods_count;//商品数量
@property(nonatomic,copy)NSString * z_goods_count;
@property(nonatomic,copy)NSString *total_exchange_integral;
@property(nonatomic,copy)NSString * total_give_integral;//国币数量





@end
