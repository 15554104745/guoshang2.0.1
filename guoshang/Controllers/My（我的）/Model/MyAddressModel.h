//
//  MyAddressModel.h
//  guoshang
//
//  Created by 张涛 on 16/3/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAddressModel : NSObject

@property (copy, nonatomic) NSString * consignee;
@property (copy, nonatomic) NSString * tel;
@property (copy, nonatomic) NSString * province;
@property (copy, nonatomic) NSString * city;
@property (copy, nonatomic) NSString * district;
@property (copy, nonatomic) NSString * address;
@property (copy, nonatomic) NSString * allAddress;
@property (copy, nonatomic) NSString * address_id;
@property (copy, nonatomic) NSString * province_id;
@property (copy, nonatomic) NSString * city_id;
@property (copy, nonatomic) NSString * district_id;
@property (copy, nonatomic) NSNumber * is_default;
//地址
@property (copy, nonatomic) NSString * region_id;
@property (copy, nonatomic) NSString * region_name;


@end
