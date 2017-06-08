//
//  GSCarShopModel.m
//  guoshang
//
//  Created by Rechied on 2016/11/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCarShopModel.h"
#import "GSCarGoodsModel.h"

@implementation GSCarShopModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goods_list":@"GSCarGoodsModel"};
}

- (NSMutableArray *)goods_list_select {
    if (!_goods_list_select) {
        _goods_list_select = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _goods_list_select;
}

- (void)setSelect_shop:(BOOL)select_shop {
    _select_shop = select_shop;
    if (select_shop) {
       [self resetGoodsSelect:select_shop]; 
    }
}

- (void)resetGoodsSelect:(BOOL)select {
    
    [self.goods_list enumerateObjectsUsingBlock:^(GSCarGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.select_goods = select;
    }];
    if (!select) {
        [self.goods_list_select removeAllObjects];
    } else {
        self.goods_list_select = [[NSMutableArray alloc] initWithArray:self.goods_list];
    }
}


/**
 获取当前店铺已选中商品的总价

 @return 当前店铺所有已选择商品的总价
 */
- (NSString *)getShopTotalPrice {
    
    CGFloat totalPrice = 0;
    
    for (GSCarGoodsModel *goodsModel in self.goods_list) {
        if (goodsModel.select_goods) {
            totalPrice += [[goodsModel getGoodsTotalPrice] floatValue];
        }
    }
    return [NSString stringWithFormat:@"%.2f",totalPrice];
}

- (NSInteger)getShopSelectGoodsCount {
    NSInteger goodsCount = 0;
    for (GSCarGoodsModel *goodsModel in self.goods_list) {
        
        if (goodsModel.select_goods) {
            goodsCount += [goodsModel.goods_number integerValue];
        }
    }
    return goodsCount;
}
@end
