//
//  GSCarTotalModel.h
//  guoshang
//
//  Created by Rechied on 2016/11/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSCarTotalModel : NSObject

@property (copy, nonatomic) NSString *saving;
@property (copy, nonatomic) NSString *goods_number;
@property (copy, nonatomic) NSString *save_rate;
@property (copy, nonatomic) NSString *virtual_goods_count;
@property (copy, nonatomic) NSString *market_price;
@property (copy, nonatomic) NSString *real_goods_count;
@property (copy, nonatomic) NSString *goods_amount;
@property (copy, nonatomic) NSString *goods_price;

@property (assign, nonatomic) BOOL select_allGoods;
@end
