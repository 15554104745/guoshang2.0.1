//
//  GSGoodsDetailGoodsInfoModel.m
//  guoshang
//
//  Created by Rechied on 2016/11/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetailGoodsInfoModel.h"

@implementation GSGoodsDetailGoodsInfoModel
- (NSString *)getShowPrice {
    if (self.promote_price && ![self.promote_price isEqualToString:@""]) {
        return self.promote_price;
    } else {
        return self.shop_price;
    }
}
@end
