//
//  GSCarShopSectionTableViewCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCarShopSectionTableViewCell.h"
#import "GSCarShopModel.h"

@implementation GSCarShopSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShopModel:(GSCarShopModel *)shopModel {
    _shopModel = shopModel;
    self.shopTitleLabel.text = shopModel.shop_title;
    self.chackMarkButton.selected = shopModel.select_shop;
}

- (IBAction)chackMarkAction:(UIButton *)sender {
    self.shopModel.select_shop = !self.shopModel.select_shop;
    [self setShopModel:_shopModel];
    if ([_delegate respondsToSelector:@selector(carShopSectionCellDidChangeSelectWithGoodsModel:inSection:)]) {
        [_delegate carShopSectionCellDidChangeSelectWithGoodsModel:_shopModel inSection:_section];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
