//
//  GSOrderTotalModel.h
//  guoshang
//
//  Created by 金联科技 on 16/8/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSOrderTotalModel : NSObject
@property (nonatomic,copy) NSString *goods_amount;
@property (nonatomic,copy) NSString *goods_number;
@property (nonatomic,copy) NSString *order_amount;
@property (nonatomic,copy) NSString *shipping_fee;
@property (nonatomic,copy) NSString *is_exchange_order;
@property (nonatomic,copy) NSString *total_exchange_integral;
@end
