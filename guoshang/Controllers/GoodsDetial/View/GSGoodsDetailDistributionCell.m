//
//  GSGoodsDetailDistributionCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetailDistributionCell.h"

@implementation GSGoodsDetailDistributionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailModel:(GSGoodsDetailModel *)detailModel {
    [super setDetailModel:detailModel];
    
    [self.chooseAddressButton setTitle:[detailModel.address getGoodsDetailAddress] forState:UIControlStateNormal];
    NSString *shippingPrice = [detailModel.goodsinfo.shipping_price floatValue] == 0 ? @"包邮" : [NSString stringWithFormat:@"¥%@",detailModel.goodsinfo.shipping_price];
    self.shippingPriceLabel.text = shippingPrice;
    
    self.serveLabel.text = [NSString stringWithFormat:@"由%@进行发货",detailModel.shop_info.shop_title];
}

@end
