//
//  GSCustomOrderInfoModel.m
//  guoshang
//
//  Created by 金联科技 on 16/8/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCustomOrderInfoModel.h"

#import "MJExtension.h"
@implementation GSCustomOrderInfoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"goods_list":[GSCustomGoodsInfoModel class]};
}
@end

@implementation GSCustomGoodsInfoModel

@end
