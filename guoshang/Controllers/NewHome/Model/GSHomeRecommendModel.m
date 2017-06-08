//
//  GSHomeRecommendModel.m
//  guoshang
//
//  Created by Rechied on 16/8/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSHomeRecommendModel.h"

@implementation GSHomeRecommendModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"goods_id":@"id",@"ID":@"goods_id",@"thumb":@"goods_thumb",@"thumb":@"thumb"};
}

- (NSString *)getShowPrice {
    if (self.promote_price && ![self.promote_price isEqualToString:@""]) {
        return self.promote_price;
    } else {
        return self.shop_price;
    }
}
@end
