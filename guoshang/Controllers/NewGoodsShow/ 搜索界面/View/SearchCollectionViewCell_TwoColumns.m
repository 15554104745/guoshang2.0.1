//
//  SearchCollectionViewCell_TwoColumns.m
//  guoshang
//
//  Created by 孙涛 on 16/10/6.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SearchCollectionViewCell_TwoColumns.h"
#import "UIImageView+WebCache.h"

@implementation SearchCollectionViewCell_TwoColumns

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SearchResultModel *)model {
    _model = model;
    
    [self.goods_image sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    self.goodsPrice_lab.text = model.shop_price;
    self.goodsTitle_lab.text = model.goods_name;
    self.goodsStyle_lab.layer.masksToBounds = YES;
        self.goodsStyle_lab.layer.cornerRadius = 5;
    if (model.on_exchange.integerValue ==1) {
        self.goodsStyle_lab.text = @"国币商品";
    }
    else
    {
        if (model.is_give_integral.integerValue ==1) {
            self.goodsStyle_lab.text = @"特卖商品";
        }
        else
        {
            self.goodsStyle_lab.text = @"易购商品";
        }
    }
}


@end
