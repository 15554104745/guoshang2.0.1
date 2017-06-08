//
//  GSGoodsSpecificationsTotalModel.h
//  guoshang
//
//  Created by Rechied on 2016/11/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSSpecificationsGoodsModel.h"
#import "GSSingleSpecificationsModel.h"
#import "GSSpecificationsDetailModel.h"
#import "GSSpecificationsModel.h"
@interface GSGoodsSpecificationsTotalModel : NSObject
@property (copy, nonatomic) NSArray *control_arr;
@property (copy, nonatomic) NSArray <__kindof GSSpecificationsGoodsModel *> *attr_goods;
@property (copy, nonatomic) NSArray <__kindof GSSpecificationsModel *>*attr_list;

@property (strong, nonatomic) NSMutableDictionary *selectSpecificationsDictionary;
@property (strong, nonatomic) NSMutableArray *contantGoodsArray;

- (void)addSelectSpecificationsWithF_id:(NSString *)f_id attrbute_id:(NSString *)attrbute_id;
- (void)deleteSpecificationsWithF_id:(NSString *)f_id;
- (NSArray *)canUseSpecificationsWithFid:(NSString *)f_id;
@end
