//
//  GSChackOutDetailModel.h
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSChackOutOrderTotalModel.h"
#import "GSChackOutOrderAddressModel.h"
#import "GSChackOutOrderSingleGoodsModel.h"
#import "GSChackOutOrderShopGoodsInfoModel.h"

@interface GSChackOutDetailModel : NSObject

@property (strong, nonatomic) GSChackOutOrderAddressModel *address;
@property (copy, nonatomic) NSArray *shop_goods_info;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSArray *goods_list;
@property (strong, nonatomic) GSChackOutOrderTotalModel *total;

- (NSDictionary *)getTotalShopIDAndTotalShippingID;

- (GSChackOutOrderSingleGoodsModel *)getSingleGoodsModelWithIndexPath:(NSIndexPath *)indexPath;

@end
