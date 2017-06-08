//
//  GSGoodsSpecificationsTotalModel.m
//  guoshang
//
//  Created by Rechied on 2016/11/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsSpecificationsTotalModel.h"

@interface GSGoodsSpecificationsTotalModel ()

@property (strong, nonatomic) NSString *current_fid;

@property (strong, nonatomic) NSMutableDictionary *canUseSpecificationsDictionary;

@end

@implementation GSGoodsSpecificationsTotalModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"attr_goods":@"GSSpecificationsGoodsModel",@"attr_list":@"GSSpecificationsModel"};
}

- (NSMutableDictionary *)canUseSpecificationsDictionary {
    if (!_canUseSpecificationsDictionary) {
        _canUseSpecificationsDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _canUseSpecificationsDictionary;
}

- (NSMutableDictionary *)selectSpecificationsDictionary {
    if (!_selectSpecificationsDictionary) {
        _selectSpecificationsDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _selectSpecificationsDictionary;
}

- (void)addSelectSpecificationsWithF_id:(NSString *)f_id attrbute_id:(NSString *)attrbute_id {
    self.current_fid = f_id;
    if (attrbute_id) {
        [self.selectSpecificationsDictionary setObject:attrbute_id forKey:f_id];
    } else {
        [self.selectSpecificationsDictionary removeObjectForKey:f_id];
    }
    [self resetCanUseSpecifications];
}
- (void)deleteSpecificationsWithF_id:(NSString *)f_id {
    
    self.current_fid = nil;
    [self.selectSpecificationsDictionary removeObjectForKey:f_id];
    
    if (self.selectSpecificationsDictionary.count == 1) {
        [self createAllCanUseSpecificationsWithFid:[[self.selectSpecificationsDictionary allKeys] firstObject]];
    } else {
        [self resetCanUseSpecifications];
    }
}

- (void)createAllCanUseSpecificationsWithFid:(NSString *)f_id {
    
    [self.attr_list enumerateObjectsUsingBlock:^(__kindof GSSpecificationsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.f_id isEqualToString:f_id]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
            [obj.attr_next enumerateObjectsUsingBlock:^(__kindof GSSpecificationsDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tempArray addObject:obj.attrbute_id];
            }];
            [self.canUseSpecificationsDictionary setObject:tempArray forKey:obj.f_id];
            return;
        }
        
    }];
}

- (void)resetCanUseSpecifications {
    NSMutableArray *noContantFidArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.contantGoodsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.attr_list enumerateObjectsUsingBlock:^(__kindof GSSpecificationsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.f_id isEqualToString:self.current_fid]) {
            [noContantFidArray addObject:obj.f_id];
        }
    }];
    
    [self.attr_goods enumerateObjectsUsingBlock:^(__kindof GSSpecificationsGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *BOOLArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self.selectSpecificationsDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull value, BOOL * _Nonnull stop) {
            NSString *attrbute_id = [obj.goods_attribute[key] objectForKey:@"attribute_id"];
            if ([attrbute_id isEqualToString:value]) {
                
                [BOOLArray addObject:@(YES)];
            }
        }];
        if (BOOLArray.count == self.selectSpecificationsDictionary.count) {
            [_contantGoodsArray addObject:obj];
        }
        
    }];
    [noContantFidArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull f_id, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *object_idArray = [[NSMutableArray alloc] initWithCapacity:0];
        [_contantGoodsArray enumerateObjectsUsingBlock:^(GSSpecificationsGoodsModel *  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
            [object_idArray addObject:obj.goods_attribute[f_id][@"attribute_id"]];
        }];
        [self.canUseSpecificationsDictionary setObject:object_idArray forKey:f_id];
    }];
}

- (NSArray *)canUseSpecificationsWithFid:(NSString *)f_id {
    
    return [NSArray arrayWithArray:self.canUseSpecificationsDictionary[f_id]];
    
}


@end
