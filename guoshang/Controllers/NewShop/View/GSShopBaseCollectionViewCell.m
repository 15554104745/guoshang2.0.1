//
//  GSShopBaseCollectionViewCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/3.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSShopBaseCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation GSShopBaseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.goodsImageView.clipsToBounds = YES;
    [self.goodsImageView setContentScaleFactor:1.0];
    self.goodsImageView.contentMode =  UIViewContentModeScaleAspectFill;
    self.goodsImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
}

- (void)setGoodsModel:(GSShopBaseGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    NSString *goodsImageURLString = [goodsModel.goods_thumb containsString:@"http:"] ? goodsModel.goods_thumb : [NSString stringWithFormat:@"%@%@",ImageBaseURL,goodsModel.goods_thumb];
    
    NSLog(@"%@",goodsImageURLString);
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImageURLString] placeholderImage:Goods_Pleaceholder_Image];
    self.goodsTitleLabel.text = goodsModel.goods_name;
    NSString *goodsPrice = (goodsModel.promote_price && ![goodsModel.promote_price isEqualToString:@""]) ? goodsModel.promote_price : goodsModel.shop_price;
    NSString *priceStr = [[goodsPrice componentsSeparatedByString:@"."] firstObject];
    
    self.goodsPriceLabel.text = [priceStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    
    NSString *decimalStr =  [[goodsPrice componentsSeparatedByString:@"."] lastObject];
    self.goodsPriceDecimalLabel.text = decimalStr;
    
    self.salesCountLabel.text = [NSString stringWithFormat:@"%@件",goodsModel.goods_sales];
    self.favorableLabel.text = goodsModel.favorable_rate;
}

@end
