//
//  GSOrderGoosInfoTableViewCell.m
//  guoshang
//
//  Created by Rechied on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSOrderGoosInfoTableViewCell.h"

@implementation GSOrderGoosInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setGoodsModel:(GSOrderGoodsModel *)goodsModel {
    
    [_goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.offset(Width - 170);
        
    }];
    
    
    if ([goodsModel isGuoBiPayType]) {
        self.guoBiImageWidth.constant = 20;
        self.guoBiImageView.hidden = NO;
        self.oldPriceLabel.hidden = YES;
        self.unitLabel.text = @"x";
        self.turePriceLabel.text = goodsModel.exchange_integral;
    } else {
        self.guoBiImageWidth.constant = 0;
        self.guoBiImageView.hidden = YES;
        self.oldPriceLabel.hidden = NO;
        self.unitLabel.text = @"¥";
        self.turePriceLabel.text = goodsModel.goods_price;
    }
    
    
    [self.goodsImageView setImageWithURL:[NSURL URLWithString:goodsModel.goods_thumb] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    self.goodsTitleLabel.text = goodsModel.goods_name;
    
    
    NSString *oldPrice = [NSString stringWithFormat:@"¥%@",goodsModel.market_price];
    NSMutableAttributedString *attrbutedString = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    
    [attrbutedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, oldPrice.length)];
    
    self.oldPriceLabel.attributedText = attrbutedString;
    self.salesVolumeLabel.text = goodsModel.sale_num;
    self.countLabel.text = [NSString stringWithFormat:@"x%@",goodsModel.goods_number];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
