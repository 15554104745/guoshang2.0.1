//
//  GSReimburseModel.m
//  guoshang
//
//  Created by 金联科技 on 16/10/8.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSReimburseModel.h"

@implementation GSReimburseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"goods_list":[GSMyGroupGoodsModel class]};
}
@end
