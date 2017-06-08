//
//  GSGroupWillCreateModel.h
//  guoshang
//
//  Created by Rechied on 16/9/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSGroupModelRuleModel.h"

@interface GSGroupWillCreateModel : NSObject

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *group_description;
@property (copy, nonatomic) NSString *each_amount;
@property (copy, nonatomic) NSString *goods_name;
@property (copy, nonatomic) NSString *goods_thumb;
@property (copy, nonatomic) NSString *valid;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *shop_info_id;
@property (copy, nonatomic) NSString *goods_id;
@property (copy, nonatomic) NSString *max_user_amount;
@property (copy, nonatomic) NSArray *rule;
@property (copy, nonatomic) NSString *max_copies_amount;
@property (copy, nonatomic) NSString *shop_price;

@end
