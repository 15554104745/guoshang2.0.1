
//
//  GSCarRequestManager.m
//  guoshang
//
//  Created by Rechied on 2016/11/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCarRequestManager.h"
#import "RequestManager.h"


@implementation GSCarRequestManager

+ (void)getCarGoodsList:(void(^)(NSArray <__kindof GSCarShopModel *>*shop_list, GSCarTotalModel *totalModel, NSError *error))completed {
    
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Cart/index") parameters:[@{@"user_id":UserId} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        
        if (responseObject && [responseObject[@"status"] isEqualToString:@"20000"]) {
            if (completed) {
                NSArray *shop_list = [GSCarShopModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"shop_list"]];
                GSCarTotalModel *totalModel = [GSCarTotalModel mj_objectWithKeyValues:responseObject[@"result"][@"total"]];
                completed(shop_list, totalModel, nil);
            }
        } else {
            
            if (completed) {
                completed(nil , nil, error);
            }
        }
    }];
}


+ (void)changeCarGoodsCountWithGoods_id:(NSString *)goods_id count:(NSInteger)count_str completed:(void(^)(id responseObject, NSError *error))completed {
    
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Cart/new_update_goods_cart") parameters:[@{@"user_id":UserId,@"rec_id":[NSString stringWithFormat:@"%@",goods_id],@"num":[NSString stringWithFormat:@"%zi",count_str]} addSaltParamsDictionary] completed:completed];
}

+ (void)getRecommendGoodsListWithPage:(NSInteger)page page_size:(NSInteger)page_size completed:(void(^)(NSArray <__kindof GSHomeRecommendModel *>*goodsArray, BOOL noMoreData, NSError *error))completed {
    
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Index/get_recommend_goods") parameters:@{@"last":@(page),@"amount":@(page_size)} completed:^(id responseObject, NSError *error) {
        if (completed) {
            if (!error) {
                NSArray *goodsArray = [GSHomeRecommendModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                completed(goodsArray, goodsArray.count < page_size, nil);
            } else {
                completed(nil, NO, error);
            }
        }
        
    }];
}

+ (void)deleteCarGoodsWithRec_id:(NSString *)rec_id completed:(void (^)(BOOL))completed {
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Cart/drop_cart_goods") parameters:[@{@"user_id":UserId,@"rec_id":rec_id} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
            if (completed) {
                if ([responseObject[@"status"] integerValue] == 0) {
                    completed(YES);
                } else {
                    completed(NO);
                }
            }
    }];
}

+ (void)changeCarGoodsAttributeWithAttribute_id:(NSString *)attribute_id rec_id:(NSString *)rec_id goods_id:(NSString *)goods_id goods_count:(NSString *)goods_count completed:(void(^)(BOOL success,NSString *message))completed {
    
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Cart/update_attr") parameters:[@{@"rec_id":rec_id,@"goods_id":goods_id,@"attr_id":attribute_id,@"user_id":UserId} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"status"] integerValue] == 20000) {
            completed(YES, responseObject[@"message"]);
        } else {
            completed(NO, responseObject[@"message"]);
        }
    }];
}

+ (void)addGoodsToCarWithGoods_id:(NSString *)goods_id completed:(void(^)(BOOL success))completed {
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Cart/new_add_cart") parameters:[@{@"user_id":UserId,@"goods_id":goods_id,@"num":@(1)} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        if (responseObject) {
            if ([responseObject[@"status"] integerValue] == 0) {
                completed(YES);
            } else {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                completed(NO);
            }
        }
    }];
}
@end
