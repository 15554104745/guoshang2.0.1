//
//  GSGroupOrderModel.m
//  guoshang
//
//  Created by 金联科技 on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGroupOrderModel.h"
#import "MJExtension.h"
@implementation GSGroupOrderModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"descrip" : @"description",
             @"price" : @"init_price",
             };
}
@end
