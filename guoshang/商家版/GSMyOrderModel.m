//
//  GSMyOrderModel.m
//  guoshang
//
//  Created by 金联科技 on 16/7/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSMyOrderModel.h"
#import "MJExtension.h"
@implementation GSMyOrderModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"goods_list":[GSMyGoodModel class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"};
}


@end


@implementation GSMyGoodModel

@end
