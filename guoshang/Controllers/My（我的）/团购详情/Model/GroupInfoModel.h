//
//  GroupInfoModel.h
//  guoshang
//
//  Created by JinLian on 16/9/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rules : NSObject
@property (copy, nonatomic) NSString *amount;
@property (copy, nonatomic) NSString *price;
@end


@interface GroupInfoModel : NSObject


@property (strong, nonatomic) NSArray *rules;

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *shop_info_id;
@property (nonatomic, copy)NSString *start_time;
@property (nonatomic, copy)NSString *end_time;
@property (nonatomic, copy)NSString *max_copies_amount;
@property (nonatomic, copy)NSString *max_user_amount;
@property (nonatomic, copy)NSString *each_amount;
@property (nonatomic, copy)NSString *desc;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *goods_name;

/*
 "create_by" = 1;
 "create_time" = 1473822428;
 description = "\U5c71\U4e1c\U7701\U5730\U65b9";
 "each_amount" = 10;
 "end_time" = "2016-09-21 16:02:00";
 "goods_id" = 19134;
 "goods_name" = 2132;
 id = c043b93d1bd34435b39cf2c57d34bc11;
 "is_display" = y;
 "max_copies_amount" = 500;
 "max_user_amount" = 50;
 rules =         (
 {
 amount = 50;
 price = "2000.00";
 },
 {
 amount = 20;
 price = "2500.00";
 },
 {
 amount = 10;
 price = "3000.00";
 },
 {
 amount = 5;
 price = "4000.00";
 }
 );
 "shop_info_id" = 5422;
 "start_time" = "2016-09-20 16:02:00";
 title = "\U7684\U65f6\U95f4\U662f";
 "update_by" = 1;
 "update_time" = 1473822428;
 */
@end
