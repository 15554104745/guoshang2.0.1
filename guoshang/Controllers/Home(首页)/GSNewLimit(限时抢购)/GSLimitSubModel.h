//
//  GSLimitSubModel.h
//  guoshang
//
//  Created by 时礼法 on 16/11/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSLimitSubModel : NSObject

@property(nonatomic,copy)NSString * start_time;//开始时间
@property(nonatomic,copy)NSString * end_time; //结束时间
@property(nonatomic,copy)NSString * format_price;
@property(nonatomic,copy)NSString * goods_id;//商城ID
@property(nonatomic,copy)NSString * goods_img;//商品图片
@property(nonatomic,copy)NSString * goods_name;//商品名称
@property(nonatomic,copy)NSString * goods_number;
@property(nonatomic,copy)NSString * market_price;
@property(nonatomic,copy)NSString * promote_end_date;
@property(nonatomic,copy)NSString * promote_start_date;
@property(nonatomic,copy)NSString * shop_price;
@property(nonatomic,copy)NSString * promote_status;//抢购状态
@property(nonatomic,copy)NSString * sold_percent; //已售百分比


@end
