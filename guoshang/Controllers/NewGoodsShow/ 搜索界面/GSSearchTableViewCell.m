//
//  GSSearchTableViewCell.m
//  guoshang
//
//  Created by JinLian on 16/9/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSSearchTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface GSSearchTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsStyle;

@end

@implementation GSSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setModel:(SearchResultModel *)model {
    
    _model = model;
    
    self.goodsName.text = model.goods_name;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    self.goodsPrice.text = model.shop_price;
//    self.goodsStyle.text = model.
}










- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
