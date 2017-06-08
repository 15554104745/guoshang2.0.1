//
//  GSMyOrderInfoModel.m
//  guoshang
//
//  Created by 金联科技 on 16/8/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSMyOrderInfoModel.h"
#import "MJExtension.h"
@implementation GSMyOrderInfoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"purchase_goods":[GSMyOrderGoodsInfoModel class]};
}
@end


@implementation GSMyOrderGoodsInfoModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"};
}

@end
@implementation GSPurchaseOrderModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"};
}

@end