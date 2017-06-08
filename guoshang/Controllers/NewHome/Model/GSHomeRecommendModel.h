//
//  GSHomeRecommendModel.h
//  guoshang
//
//  Created by Rechied on 16/8/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSHomeRecommendModel : NSObject
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *goods_id;
@property (copy, nonatomic) NSString *thumb;
@property (copy, nonatomic) NSString *short_style_name;
@property (copy, nonatomic) NSString *brief;
@property (copy, nonatomic) NSString *brand_name;
@property (copy, nonatomic) NSString *short_name;
@property (copy, nonatomic) NSString *goods_img;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *promote_price;
@property (copy, nonatomic) NSString *market_price;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *shop_price;
@property (copy, nonatomic) NSString *sale_num;
@property (copy, nonatomic) NSString *original_img;

- (NSString *)getShowPrice;
@end
