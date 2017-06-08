//
//  GSChackOutOrderSectionHeaderCell.m
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChackOutOrderSectionHeaderCell.h"
#import "UIImageView+WebCache.h"

@implementation GSChackOutOrderSectionHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShopGoodsInfoModel:(GSChackOutOrderShopGoodsInfoModel *)shopGoodsInfoModel {
    //NSLog(@"%@",shopGoodsInfoModel.shop_title);
    _shopGoodsInfoModel = shopGoodsInfoModel;
    self.shopTitleLabel.text = shopGoodsInfoModel.shop_title;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopGoodsInfoModel.shoplogo] placeholderImage:[UIImage imageNamed:@"icon"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
