//
//  GSOrderGoodsModel.m
//  guoshang
//
//  Created by Rechied on 16/8/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSOrderGoodsModel.h"

@implementation GSOrderGoodsModel

- (BOOL)isGuoBiPayType {
    return (self.extension_code &&[self.extension_code isEqualToString:GuoBi_Pay_Goods]);
}

@end
