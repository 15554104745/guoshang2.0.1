//
//  GSOrderDetailModel.m
//  guoshang
//
//  Created by Rechied on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSOrderDetailModel.h"

@implementation GSOrderDetailModel

- (BOOL)isGuoBiPayType {
    return (self.extension_code &&[self.extension_code isEqualToString:GuoBi_Pay_Goods]);
}

+ (NSDictionary *)objectClassInArray{
    return @{@"shop_list" : @"GSOrderGoodsListModel"};
}

@end
