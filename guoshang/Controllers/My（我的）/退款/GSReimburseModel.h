//
//  GSReimburseModel.h
//  guoshang
//
//  Created by 金联科技 on 16/10/8.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSMyGroupGoodsModel.h"
@interface GSReimburseModel : NSObject

@property (nonatomic,strong) NSString *add_time;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *adminnote;
@property (nonatomic,strong) NSString *consignee;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSArray *goods_list;

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *order_amount;
@property (nonatomic,strong) NSString *return_order_sn;
@property (nonatomic,strong) NSString *order_sn;
@property (nonatomic,strong) NSString *shop_id;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *total_fee;
@property (nonatomic,strong) NSString *updated_at;
@property (nonatomic,strong) NSString *usernote;

@end
