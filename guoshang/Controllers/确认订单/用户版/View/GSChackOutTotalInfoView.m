//
//  GSChackOutTotalInfoView.m
//  guoshang
//
//  Created by Rechied on 16/9/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChackOutTotalInfoView.h"

@implementation GSChackOutTotalInfoView

- (void)setTotalModel:(GSChackOutOrderTotalModel *)totalModel {
    _totalModel = totalModel;
    NSString *totalPriceStr = nil;
    NSString *shippingStr = nil;
    if (totalModel.chackOutOrderType == GSChackOutOrderTypeGuoBi) {
        self.guoBiIconImageView.hidden = NO;
        totalPriceStr = [NSString stringWithFormat:@"x %.2f",[totalModel.total_exchange_integral floatValue]];
        shippingStr = @"";
    } else {
        self.guoBiIconImageView.hidden = YES;
        
        totalPriceStr = [NSString stringWithFormat:@"合计: %@",(totalModel.order_amount && ![totalModel.order_amount isEqualToString:@""]) ? totalModel.order_amount : totalModel.goods_price];
        shippingStr = @"含";
    }
    
    self.totalPriceLabel.text = totalPriceStr;
    self.totalShippingPriceLabel.text = [NSString stringWithFormat:@"(%@运费: %@元)",shippingStr, totalModel.shipping_price];
    
    self.hidden = NO;
}

@end
