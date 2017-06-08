//
//  GSCarRecommendGoodsCollectionViewCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCarRecommendGoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation GSCarRecommendGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoodsModel:(GSHomeRecommendModel *)goodsModel {
    _goodsModel = goodsModel;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.goods_img] placeholderImage:Goods_Pleaceholder_Image];
    self.titleLabel.text = goodsModel.name;
    NSString *goods_price = [[goodsModel.shop_price componentsSeparatedByString:@"."][0] stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    self.priceLabel.text = goods_price;
    self.decimalLabel.text = [[goodsModel.shop_price componentsSeparatedByString:@"."] lastObject];
}

- (IBAction)addToCarAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(carRecommendGoodsCellWillAddToCarWithGoods_id:)]) {
        [_delegate carRecommendGoodsCellWillAddToCarWithGoods_id:self.goodsModel.goods_id];
    }
}

@end
