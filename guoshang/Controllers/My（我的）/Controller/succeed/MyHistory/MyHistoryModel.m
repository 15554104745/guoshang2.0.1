//
//  MyHistoryModel.m
//  guoshang
//
//  Created by 陈赞 on 16/7/31.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyHistoryModel.h"

@implementation MyHistoryModel
- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {

        // 为参数赋值
        self.browse_id = dict[@"browse_id"];
        self.browse_num = dict[@"browse_num"];
        self.first_browse_time = dict[@"first_browse_time"];
        self.goods_id = dict[@"goods_id"];
        self.goods_img = dict[@"goods_img"];
        self.goods_name = dict[@"goods_name"];
        self.isCheck = dict[@"isCheck"];
        self.last_browse_time = dict[@"last_browse_time"];
        self.market_price = dict[@"market_price"];
        self.shop_price = dict[@"shop_price"];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end
