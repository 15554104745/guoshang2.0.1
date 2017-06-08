//
//  GSCarRequestManager.h
//  guoshang
//
//  Created by Rechied on 2016/11/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSCarShopModel.h"
#import "GSCarTotalModel.h"
#import "GSHomeRecommendModel.h"

@interface GSCarRequestManager : NSObject

+ (void)getCarGoodsList:(void(^)(NSArray <__kindof GSCarShopModel *>*shop_list, GSCarTotalModel *totalModel, NSError *error))completed;

+ (void)changeCarGoodsCountWithGoods_id:(NSString *)goods_id count:(NSInteger)count_str completed:(void(^)(id responseObject, NSError *error))completed;

+ (void)getRecommendGoodsListWithPage:(NSInteger)page page_size:(NSInteger)page_size completed:(void(^)(NSArray <__kindof GSHomeRecommendModel *>*goodsArray, BOOL noMoreData, NSError *error))completed;

+ (void)deleteCarGoodsWithRec_id:(NSString *)rec_id completed:(void(^)(BOOL isSuccess))completed;

+ (void)changeCarGoodsAttributeWithAttribute_id:(NSString *)attribute_id rec_id:(NSString *)rec_id goods_id:(NSString *)goods_id goods_count:(NSString *)goods_count completed:(void(^)(BOOL success,NSString *message))completed;

+ (void)addGoodsToCarWithGoods_id:(NSString *)goods_id completed:(void(^)(BOOL success))completed;

@end
