//
//  GSCarGoodsModel.m
//  guoshang
//
//  Created by Rechied on 2016/11/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCarGoodsModel.h"

@implementation GSCarGoodsModel

- (NSString *)getGoodsTotalPrice {
    float price = [[self.goods_price stringByReplacingOccurrencesOfString:@"￥" withString:@""] floatValue];
    
    return [NSString stringWithFormat:@"%.2f",price * [self.goods_number floatValue]];
}

@end
