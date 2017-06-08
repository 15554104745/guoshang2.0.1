//
//  GSChackOutDetailModel.m
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChackOutDetailModel.h"
#import "GSChackOutOrderShippingModel.h"

@implementation GSChackOutDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"shop_goods_info" : @"GSChackOutOrderShopGoodsInfoModel",
                  @"goods_list" : @"GSChackOutOrderSingleGoodsModel"};
}


- (NSDictionary *)getTotalShopIDAndTotalShippingID {
    __block NSMutableString *totalShippingString = [[NSMutableString alloc] initWithCapacity:0];
    __block NSMutableString *totalShopString = [[NSMutableString alloc] initWithCapacity:0];
    
    [self.shop_goods_info enumerateObjectsUsingBlock:^(GSChackOutOrderShopGoodsInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {\
        
        if (obj.selectShippingID && ![obj.selectShippingID isEqualToString:@""]) {
            [totalShippingString appendString:obj.selectShippingID];
            [totalShippingString appendString:@"#"];
        } else {
            if (obj.shipping.count > 0) {
                GSChackOutOrderShippingModel *shippingModel = obj.shipping[0];
                if (shippingModel.shipping_id) {
                    [totalShippingString appendString:shippingModel.shipping_id];
                    [totalShippingString appendString:@"#"];
                }
            }
        }
        
        if (obj.shop_id) {
            [totalShopString appendString:obj.shop_id];
            [totalShopString appendString:@"#"];
        }
        
    }];
    
    NSDictionary *dic = @{@"shop_id":[[NSString alloc] initWithString:totalShopString],@"shipping_id":[[NSString alloc] initWithString:totalShippingString]};
    return [dic copy];
    
}


- (GSChackOutOrderSingleGoodsModel *)getSingleGoodsModelWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.shop_goods_info.count) {
        GSChackOutOrderShopGoodsInfoModel *shopInfo = self.shop_goods_info[indexPath.section];
        if (indexPath.row < shopInfo.goods_list.count) {
            return shopInfo.goods_list[indexPath.row];
        }
    }
    return nil;
}

@end
