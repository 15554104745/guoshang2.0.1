//
//  GSChackOutOrderAddressModel.h
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSChackOutOrderAddressModel : NSObject

@property (copy, nonatomic) NSString *consignee;
@property (copy, nonatomic) NSString *best_time;
@property (copy, nonatomic) NSString *address_name;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *user_id;
@property (copy, nonatomic) NSString *zipcode;
@property (copy, nonatomic) NSString *address_id;
@property (copy, nonatomic) NSString *sign_building;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *tel;
@property (copy, nonatomic) NSString *is_default;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *country;



@property (copy, nonatomic) NSString *province_id;
@property (copy, nonatomic) NSString *city_id;
@property (copy, nonatomic) NSString *district_id;
@property (copy, nonatomic) NSString *address_str;

- (NSString *)getAppendAddress;
- (NSString *)getAppendAddressNoDetailAddress;

- (NSString *)getGoodsDetailAddress;
@end
