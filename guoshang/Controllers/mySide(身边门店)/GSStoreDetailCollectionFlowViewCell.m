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
    self.goodsPriceLabel.text = goodsModel.shop_price;
    self.goodsSellCountLabel.text = [NSString stringWithFormat:@"已售%@",goodsModel.goods_number];
}

- (void)setRecommendModel:(GSHomeRecommendModel *)recommendModel {
    _recommendModel = recommendModel;
    self.layer.borderColor = [[UIColor colorWithHexString:@"d1d1d1"] CGColor];
    self.layer.borderWidth = .5f;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:recommendModel.goods_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    
    self.goodsTitleLabel.text = recommendModel.name;
    NSString *priceStr = [recommendModel.shop_price containsString:@"￥"] ? [recommendModel.shop_price stringByReplacingOccurrencesOfString:@"￥" withString:@""] : recommendModel.shop_price;
    self.goodsPriceLabel.text = priceStr;
    self.goodsSellCountLabel.hidden = NO;
    //self.goodsSellCountLabel.text = [NSString stringWithFormat:@"已售%@",goodsModel.goods_number];
}

@end
