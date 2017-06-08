//
//  ShoppingTableViewCell.m
//  guoshang
//
//  Created by 张涛 on 16/2/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ShoppingTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ShoppingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setGoodsModel:(GSShopBaseGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    NSString *goodsImageURLString = [goodsModel.goods_thumb containsString:@"http:"] ? goodsModel.goods_thumb : [NSString stringWithFormat:@"%@%@",ImageBaseURL,goodsModel.goods_thumb];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:goodsImageURLString] placeholderImage:Goods_Pleaceholder_Image];
    self.titleLabel.text = goodsModel.goods_name;
    [self.coinImage setImage:[UIImage imageNamed:@"guobi"]];
    self.countLabel.text = [NSString stringWithFormat:@"%@",goodsModel.shop_price];
    self.haveSaled.text = [NSString stringWithFormat:@"已售%@",_goodsModel.goods_sales];
    self.favoriteRate.text = [NSString stringWithFormat:@"好评率%@",_goodsModel.favorable_rate];
    
    self.coinImage.hidden = NO;
    self.countLabel.hidden = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
