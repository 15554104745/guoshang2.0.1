//
//  GSGoodsDetailModel.h
//  guoshang
//
//  Created by Rechied on 2016/11/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSChackOutOrderAddressModel.h"
#import "GSGoodsDetailGoodsInfoModel.h"
#import "GSGoodsDetialPicturesModel.h"
#import "GSGoodsDetailShopInfoModel.h"

@interface GSGoodsDetailModel : NSObject
@property (strong, nonatomic) GSChackOutOrderAddressModel *address;
@property (strong, nonatomic) GSGoodsDetailShopInfoModel *shop_info;
@property (copy, nonatomic) NSArray *pictures;
@property (copy, nonatomic) NSArray *attribute;
@property (strong, nonatomic) GSGoodsDetailGoodsInfoModel *goodsinfo;

@property (copy, nonatomic) NSString *attribute_name;

- (NSArray *)getAllImageURL;
@end
