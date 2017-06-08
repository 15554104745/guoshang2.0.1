//
//  GSCarShopModel.h
//  guoshang
//
//  Created by Rechied on 2016/11/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSCarShopModel : NSObject
@property (copy, nonatomic) NSString*shop_id;
@property (copy, nonatomic) NSArray *goods_list;
@property (copy, nonatomic) NSString *shop_title;

@property (strong, nonatomic) NSMutableArray *goods_list_select;
@property (assign, nonatomic) BOOL select_shop;


- (void)resetGoodsSelect:(BOOL)select;
- (NSString *)getShopTotalPrice;
- (NSInteger)getShopSelectGoodsCount;
@end
