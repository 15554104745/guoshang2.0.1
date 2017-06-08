//
//  MyCollcetModel.m
//  guoshang
//
//  Created by 张涛 on 16/3/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyCollcetModel.h"

@implementation MyCollcetModel

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        // 为参数赋值
        self.goods_name = dict[@"goods_name"];
        self.goods_img = dict[@"goods_img"];
        self.goods_id = dict[@"goods_id"];
        self.shop_price = dict[@"shop_price"];
        self.is_exchange = dict[@"is_exchange"];
        self.rec_id = dict[@"rec_id"];
        self.shoplogo = dict[@"shoplogo"];
        self.shop_title = dict[@"shop_title"];
        self.shop_id = dict[@"shop_id"];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end
