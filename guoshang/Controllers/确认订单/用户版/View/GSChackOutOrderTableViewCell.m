//
//  GSChackOutOrderTableViewCell.m
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChackOutOrderTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation GSChackOutOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSingleGoodsModel:(GSChackOutOrderSingleGoodsModel *)singleGoodsModel {
    _singleGoodsModel = singleGoodsModel;
    
    if (singleGoodsModel.goods_thumb && ![singleGoodsModel.goods_thumb isEqualToString:@""]) {
       [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:singleGoodsModel.goods_thumb] placeholderImage:Goods_Pleaceholder_Image];
    } else {
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:singleGoodsModel.goods_img] placeholderImage:Goods_Pleaceholder_Image];
    }
    
    
    
    
    self.goodsNameLabel.text = singleGoodsModel.goods_name;
    NSString *priceStr = nil;
    if (self.chackOutOrderType == GSChackOutOrderTypeGuoBi) {
        priceStr = [NSString stringWithFormat:@" x %.2f",[singleGoodsModel.exchange_integral floatValue]];
        if (self.guoBiIconImageViewWidth.constant != 20) {
            self.guoBiIconImageViewWidth.constant = 20;
        }
        self.guoBiIconImageView.hidden = NO;
    } else {
        priceStr = singleGoodsModel.goods_price;
        if (self.guoBiIconImageViewWidth.constant > 0) {
            self.guoBiIconImageViewWidth.constant = 0;
        }
        self.guoBiIconImageView.hidden = YES;
    }
    
    self.goodsPriceLabel.text = priceStr;
    
    
    self.goodsCountLabel.text = [NSString stringWithFormat:@"*%@",singleGoodsModel.goods_number];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
