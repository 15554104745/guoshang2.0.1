//
//  RecommendCollectionViewCell.m
//  Demo
//
//  Created by JinLian on 16/8/10.
//  Copyright © 2016年 GroupFly. All rights reserved.
//

#import "RecommendCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation RecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];



}

- (void)setModel:(HotGoodsModel *)model {
    
    _model = model;
//    self.layer.borderWidth = 0.5f;
//    self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
//    self.backgroundColor = [UIColor grayColor];
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
    
//    self.image.layer.borderColor = [[UIColor lightGrayColor]CGColor];
//    self.image.layer.borderWidth = 1.0f;
    
    self.lab_desc.text = model.short_name;
    self.lab_price.text = model.shop_price;
}


@end
