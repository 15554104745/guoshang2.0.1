//
//  MoneyCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MoneyCell.h"
#import "UIImageView+WebCache.h"

@implementation MoneyCell



-(void)setModel:(GoodsModel *)model{
    _model = model;
    [self settingData];
}

-(void)settingData{
    _titleLable.numberOfLines = 0;
    _titleLable.text = _model.goods_name;
    if ([_model.goods_price isEqualToString:@"￥0.00"]) {
        _priceLabel.text = [NSString stringWithFormat:@"%@个",_model.exchange_integral];
    }else{
    _priceLabel.text = [NSString stringWithFormat:@"%@",_model.goods_price];
    }
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.goods_thumb]] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
//    _fieghtLable.text = [NSString stringWithFormat:@"运费：%@",_model.shipping_price];
    _countLable.text = [NSString stringWithFormat:@"* %@",_model.goods_number];
    
    if (_model.attr_names !=nil) {
       
         _rankLabel.text = _model.attr_names;
    }else{
     
        _rankwith.constant = 0.0;
         CGFloat height = [LNLabel calculateMoreLabelSizeWithString:_model.goods_name AndWith:(self.frame.size.width - 130) AndFont:15.0];
        _tilteWith.constant = height;
        
        
    }
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
