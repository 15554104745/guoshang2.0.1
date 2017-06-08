//
//  GSStoreDetailCollectionViewCell.m
//  guoshang
//
//  Created by Rechied on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSStoreDetailCollectionViewCell.h"

@implementation GSStoreDetailCollectionViewCell

- (void)setGoodsModel:(GSStoreGoodsModel *)goodsModel {
    
    _goodsModel = goodsModel;
    
    [self.goodImageView setImageWithURL:[NSURL URLWithString:goodsModel.original_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    self.goodTitleLabel.text = goodsModel.goods_name;
    self.moneyLabel.text = goodsModel.shop_price;
    self.sellCountLabel.text = goodsModel.goods_number;
}

@end
