//
//  GSChackOutOrderShopGoodsInfoModel.h
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSChackOutOrderShopGoodsInfoModel : NSObject
@property (copy, nonatomic) NSString *shop_title;
@property (copy, nonatomic) NSString *shoplogo;
@property (copy, nonatomic) NSArray *goods_list;
@property (copy, nonatomic) NSString *shop_id;


@property (copy, nonatomic) NSString *total_integral;
@property (copy, nonatomic) NSString *is_integral;

@property (copy, nonatomic) NSArray *shipping;
@property (copy, nonatomic) NSString *selectShippingID;
@end
