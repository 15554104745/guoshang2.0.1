//
//  GSChackOutOrderShopGoodsInfoModel.m
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChackOutOrderShopGoodsInfoModel.h"

@implementation GSChackOutOrderShopGoodsInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goods_list" : @"GSChackOutOrderSingleGoodsModel",
               @"shipping" : @"GSChackOutOrderShippingModel"};
}

@end
