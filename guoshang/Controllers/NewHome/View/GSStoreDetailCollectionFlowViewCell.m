//
//  GSStoreDetailCollectionFlowViewCell.m
//  guoshang
//
//  Created by Rechied on 16/7/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSStoreDetailCollectionFlowViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HaxString.h"
@implementation GSStoreDetailCollectionFlowViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoodsModel:(GSStoreGoodsModel *)goodsModel {
    
    _goodsModel = goodsModel;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.original_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    self.goodsTitleLabel.text = goodsModel.goods_name;
    NSString *price = (goodsModel.promote_price && ![goodsModel.promote_price isEqualToString:@""]) ? goodsModel.promote_price : goodsModel.shop_price;
    NSString *priceStr = [price containsString:@"￥"] ? [price stringByReplacingOccurrencesOfString:@"￥" withString:@""] : price;
    self.goodsPriceLabel.text = priceStr;
    self.goodsPriceLabel.text = goodsModel.shop_price;
    self.goodsSellCountLabel.text = [NSString stringWithFormat:@"已售%@",goodsModel.sale_num];
}

- (void)setRecommendModel:(GSHomeRecommendModel *)recommendModel {
    _recommendModel = recommendModel;
    self.layer.borderColor = [[UIColor colorWithHexString:@"d1d1d1"] CGColor];
    self.layer.borderWidth = .5f;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:recommendModel.original_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    
    self.goodsTitleLabel.text = recommendModel.name;
    NSString *price = (recommendModel.promote_price && ![recommendModel.promote_price isEqualToString:@""]) ? recommendModel.promote_price : recommendModel.shop_price;
    NSString *priceStr = [price containsString:@"￥"] ? [price stringByReplacingOccurrencesOfString:@"￥" withString:@""] : price;
    self.goodsPriceLabel.text = priceStr;
    //self.goodsSellCountLabel.hidden = YES;
    self.goodsSellCountLabel.text = [NSString stringWithFormat:@"已售%@",recommendModel.sale_num];
}

@end
