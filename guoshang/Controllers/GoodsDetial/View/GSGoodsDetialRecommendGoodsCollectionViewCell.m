//
//  GSGoodsDetialRecommendGoodsCollectionViewCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetialRecommendGoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation GSGoodsDetialRecommendGoodsCollectionViewCell

- (void)setRecommendModel:(GSHomeRecommendModel *)recommendModel {
    _recommendModel = recommendModel;
    
    NSString *imageString = [recommendModel.goods_img containsString:@"http://"] ? recommendModel.goods_img : [NSString stringWithFormat:@"%@%@",ImageBaseURL,recommendModel.goods_img];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:Goods_Pleaceholder_Image];
    self.goodsTitleLabel.text = recommendModel.name;
    self.goodsPriceLabel.text = recommendModel.shop_price;
}

@end
