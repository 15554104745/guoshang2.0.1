//
//  GSTotalCarModel.h
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSTotalCarModel : JSONModel
@property(nonatomic,copy)NSString * goods_price;//总价格
@property(nonatomic,copy)NSString * market_price;//市场价格
@property(nonatomic,copy)NSString * saving;//优惠价格
@property(nonatomic,copy)NSString * save_rate;//优惠百分比
@property(nonatomic,assign)NSNumber * goods_amount;//商品价格
@property(nonatomic,assign)NSNumber * real_goods_count;//商品个数
@property(nonatomic,assign)NSNumber * virtual_goods_count;
@end
