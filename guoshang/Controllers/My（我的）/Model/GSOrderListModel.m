//
//  GSOrderListModel.m
//  guoshang
//
//  Created by 金联科技 on 16/8/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSOrderListModel.h"
#import "MJExtension.h"
#import "GoodsModel.h"
@implementation GSOrderListModel


+ (NSDictionary *)mj_objectClassInArray{
    return @{@"order_goods_list":[GSOrderGoodsList class]};
}


@end




@implementation GSOrderGoodsList

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"goods_list":[GoodsModel class]};
}
@end

