//
//  GSCarEditCell.m
//  guoshang
//
//  Created by 金联科技 on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCarEditCell.h"
#import "UIImageView+WebCache.h"

@implementation GSCarEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteBtn:(UIButton *)sender{
    if (self.gsDeleteBlock) {
        self.gsDeleteBlock();
        
    }
}
-(void)setModel:(GSCarModel *)model{
    _model = model;
    _delectBtn.layer.cornerRadius = 5;
    _delectBtn.clipsToBounds = YES;
    _selection.selected = model.isSelect;
       [self settingData];
    
    
    
}

- (IBAction)Selectbtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.gsCarBlock) {
        self.gsCarBlock(sender.selected);
    }
}
-(void)reloadDeleteDataWith:(GSCarModel *)model{
    _selection.selected = _model.isSelect;
    if (!IsNilOrNull(_model.goods_img)) {
        [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.goods_img]]  placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    }
    _numberLabel.text =[NSString stringWithFormat:@"*%@", _model.goods_number];
    
    _frieghtLable.text = [NSString stringWithFormat:@"运费:%@",_model.shipping_price];
    _titleLabel.text = _model.goods_name;
    _titleLabel.numberOfLines = 2;
    _priceLabel.text = _model.goods_price;
    
//    _GBLable.text = [NSString stringWithFormat:@"%@个", _model.d_price];
}

- (IBAction)backSelect:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
    _selection.selected = sender.selected;
    if (self.gsCarBlock) {
        
        self.gsCarBlock(_selection.selected);
        
    }
}

-(void)settingData{
    _selection.selected = _model.isSelect;
    
    [_selection setImage:[UIImage imageNamed:@"newSele"] forState:UIControlStateNormal];
    [_selection setImage:[UIImage imageNamed:@"newW"] forState:UIControlStateSelected];
    if (!IsNilOrNull(_model.goods_thumb)) {
         [_iconView sd_setImageWithURL:[NSURL URLWithString:_model.goods_thumb] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    }
    NSString * str = [NSString stringWithFormat:@"%@",_model.attr_names];
    if (str.length > 2) {
        _rankLable.text = _model.attr_names;
    }else{
        CGFloat height = [LNLabel calculateMoreLabelSizeWithString:_model.goods_name AndWith:(self.frame.size.width - 160) AndFont:16.0];
        _rankWith.constant = 0.0;
        if (height > 70.0) {
            _titleWith.constant = 75.0;
        }else{
            _titleWith.constant = height;
            
        }
        
    }
    
    _numberLabel.text =[NSString stringWithFormat:@"*%@", _model.goods_number];
    
    _frieghtLable.text = [NSString stringWithFormat:@"运费:%@",_model.shipping_price];
    _titleLabel.text = _model.goods_name;
    _titleLabel.numberOfLines = 2;
    _priceLabel.text = _model.goods_price;
//    _GBLable.text = [NSString stringWithFormat:@"%@", _model.d_price];
    _shopUser.text = [NSString stringWithFormat:@"%@",_model.shop_title];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
