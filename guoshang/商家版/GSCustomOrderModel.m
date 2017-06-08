//
//  GSCustomOrderModel.m
//  guoshang
//
//  Created by 金联科技 on 16/7/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCustomOrderModel.h"
#import "MJExtension.h"

@implementation GSCustomOrderModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"goods_list":[GSCustomGoodsModel class]};
}

@end
@implementation GSCustomGoodsModel

@end
