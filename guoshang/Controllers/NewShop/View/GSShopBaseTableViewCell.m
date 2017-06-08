//
//  GSShopBaseTableViewCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/3.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSShopBaseTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation GSShopBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoodsModel:(GSShopBaseGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    NSString *goodsImageURLString = [goodsModel.goods_thumb containsString:@"http:"] ? goodsModel.goods_thumb : [NSString stringWithFormat:@"%@%@",ImageBaseURL,goodsModel.goods_thumb];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImageURLString] placeholderImage:Goods_Pleaceholder_Image];
    self.titlaLabel.text = goodsModel.goods_name;
    NSString *goodsPrice = (goodsModel.promote_price && ![goodsModel.promote_price isEqualToString:@""]) ? goodsModel.promote_price : goodsModel.shop_price;
    NSString *priceStr = [[goodsPrice componentsSeparatedByString:@"."] firstObject];
    self.goodsPriceLabel.text = [priceStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    
    NSString *decimalStr =  [[goodsPrice componentsSeparatedByString:@"."] lastObject];
    self.goodsPriceDecimalLabel.text = decimalStr;
    
    self.salesCountLabel.text = [NSString stringWithFormat:@"%@件",goodsModel.goods_sales];
    self.favorableLabel.text = goodsModel.favorable_rate;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
