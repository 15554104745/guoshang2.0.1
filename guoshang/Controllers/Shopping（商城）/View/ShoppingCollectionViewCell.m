//
//  ShoppingCollectionViewCell.m
//  guoshang
//
//  Created by 张涛 on 16/3/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ShoppingCollectionViewCell.h"
#import "UIImageView+WebCache.h"


@implementation ShoppingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.clipsToBounds = YES;
    [self.iconView setContentScaleFactor:1.0];
    self.iconView.contentMode =  UIViewContentModeScaleAspectFill;
    self.iconView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
}

- (void)setGoodsModel:(GSShopBaseGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    NSString *goodsImageURLString = [goodsModel.goods_thumb containsString:@"http:"] ? goodsModel.goods_thumb : [NSString stringWithFormat:@"%@%@",ImageBaseURL,goodsModel.goods_thumb];
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:goodsImageURLString] placeholderImage:Goods_Pleaceholder_Image];
    NSString *goodsPrice = (goodsModel.promote_price && ![goodsModel.promote_price isEqualToString:@""]) ? goodsModel.promote_price : goodsModel.shop_price;
    NSString *priceStr = [[goodsPrice componentsSeparatedByString:@"."] firstObject];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@.00",[priceStr stringByReplacingOccurrencesOfString:@"￥" withString:@""]];
    
    self.saledLabel.text = [NSString stringWithFormat:@"已售%@",_goodsModel.goods_sales];
    self.favoriteLable.text = [NSString stringWithFormat:@"好评率%@",_goodsModel.favorable_rate];
    
    
    NSString *decimalStr =  [[goodsPrice componentsSeparatedByString:@"."] lastObject];
    self.detailLabel.text = decimalStr;
    self.detailLabel.text = goodsModel.goods_name;
    [self.coinView setImage:[UIImage imageNamed:@"guobi"]];

}




@end
