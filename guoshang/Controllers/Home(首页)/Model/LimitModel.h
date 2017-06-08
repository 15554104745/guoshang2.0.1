//
//  LimitModel.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/30.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JSONModel.h"

@interface LimitModel : NSObject
@property(nonatomic,copy)NSString * promote_price;//抢购价
@property(nonatomic,copy)NSString * goods_id;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * shop_price;//商城原价
@property(nonatomic,copy)NSString * thumb;//图片
@property(nonatomic,copy)NSString * formated_promote_start_date_year;//开始时间年
@property(nonatomic,copy)NSString * formated_promote_start_date_month;//开始时间月
@property(nonatomic,copy)NSString * formated_promote_start_date_day;//开始时间天
@property(nonatomic,copy)NSString * formated_promote_start_date_hour;//开始时间小时
@property(nonatomic,copy)NSString * formated_promote_start_date_minute;//分钟
@property(nonatomic,copy)NSString * formated_promote_start_date_second;//秒
@property(nonatomic,copy)NSString * formated_promote_end_date_year;//
@property(nonatomic,copy)NSString * formated_promote_end_date_month;//
@property(nonatomic,copy)NSString * formated_promote_end_date_day;//
@property(nonatomic,copy)NSString * formated_promote_end_date_hour;//
@property(nonatomic,copy)NSString * formated_promote_end_date_minute;//
@property(nonatomic,copy)NSString * formated_promote_end_date_second;//
@property(nonatomic,copy)NSString * promote_end_date;//结束时间戳
@property(nonatomic,copy)NSString * promote_start_date;//开始时间戳
@property(nonatomic,copy)NSString * promote_status;//抢购状态

@property (copy, nonatomic) NSString *goods_style_name;

@property (copy, nonatomic) NSString *market_price;

@property (copy, nonatomic) NSString *short_name;
@property (copy, nonatomic) NSString *brief;

@property (copy, nonatomic) NSString *short_style_name;

@property (copy, nonatomic) NSString *goods_img;

@property (copy, nonatomic) NSString *brand_name;

@property (copy, nonatomic) NSString *pictures;

@end
