//
//  GSOrderGoodsListModel.h
//  guoshang
//
//  Created by Rechied on 16/8/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSOrderShopModel.h"

@interface GSOrderGoodsListModel : NSObject

@property (copy, nonatomic) NSString *shop_logo;
@property (copy, nonatomic) NSString *shop_phone;
@property (copy, nonatomic) NSString *shop_title;
@property (copy, nonatomic) NSArray *goods_list;//GSOrderGoodsModel
@property (copy, nonatomic) NSString *shop_id;

@end
