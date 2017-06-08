//
//  GoodsDetailShopInfoModel.h
//  guoshang
//
//  Created by JinLian on 16/9/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GoodsDetailShopInfoModel : JSONModel

@property (nonatomic, copy)NSString *collect_num;
@property (nonatomic, copy)NSString *goods_num;
@property (nonatomic, copy)NSString * is_collect;
@property (nonatomic, assign)NSInteger new_num;
@property (nonatomic, copy)NSString *shop_id;
@property (nonatomic, copy)NSString <Optional>*shop_title;
@property (nonatomic, copy)NSString <Optional>*shoplogo;


@end
