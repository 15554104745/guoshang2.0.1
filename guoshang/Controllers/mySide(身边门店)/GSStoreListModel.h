//
//  GSStoreListModel.h
//  guoshang
//
//  Created by Rechied on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSStoreListModel : NSObject
@property (copy, nonatomic) NSString *shop_title;
@property (copy, nonatomic) NSString *is_collect;
@property (copy, nonatomic) NSString *shoplogo;
@property (copy, nonatomic) NSString *longitude;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *freight;
@property (copy, nonatomic) NSString *expect_time;
@property (copy, nonatomic) NSString *delivery_amount;
@property (copy, nonatomic) NSString *shopaddress;
@property (copy, nonatomic) NSString *distance;
@property (copy, nonatomic) NSString *latest_activity;
@property (copy, nonatomic) NSString *shop_id;
@property (copy, nonatomic) NSString *shop_phone;
@property (copy, nonatomic) NSString *business_time;
@property (copy, nonatomic) NSString *sale_num;
@end
