//
//  GSGroupChackOutOrderDetailModel.m
//  guoshang
//
//  Created by Rechied on 16/9/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGroupChackOutOrderDetailModel.h"

@implementation GSGroupChackOutOrderDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id",@"create_price":@"init_price",@"group_description":@"description"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"group_user_list":@"GSGroupChackOutOrderUserModel",@"rule":@"GSGroupRuleModel"};
}

//- (GSChackOutOrderSingleGoodsModel *)getSingleGoodsModel {
//    GSChackOutOrderSingleGoodsModel *singleGoodsModel = [[GSChackOutOrderSingleGoodsModel alloc] init];
//    singleGoodsModel.goods_price = self.group_price;
//    singleGoodsModel.goods_name = self.
//    //group_price
//}

@end
