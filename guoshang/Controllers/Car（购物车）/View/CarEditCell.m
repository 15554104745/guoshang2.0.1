//
//  CarEditCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/27.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import "CarEditCell.h"
#import "UIImageView+WebCache.h"
@implementation CarEditCell

- (IBAction)deleteBtn:(UIButton *)sender{
    if (self.deleteBlock) {
        self.deleteBlock();
      
    }
}
-(void)setModel:(carModel *)model{
    _model = model;
    [self settingData];
    _delectBtn.layer.cornerRadius = 5;
    _delectBtn.clipsToBounds = YES;
    _selection.selected = model.isSelect;
    
}

- (IBAction)Selectbtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.carBlock) {
        self.carBlock(sender.selected);
    }
}
-(void)reloadDeleteDataWith:(carModel *)model{
    _selection.selected = _model.isSelect;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_model.goods_thumb] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    
    _numberLabel.text =[NSString stringWithFormat:@"*%@", _model.goods_number];
    
    _frieghtLable.text = [NSString stringWithFormat:@"运费:%@",_model.shipping_price];
    _titleLabel.text = _model.goods_name;
    _titleLabel.numberOfLines = 2;
    _priceLabel.text = _model.goods_price;
    _GBLable.text = [NSString stringWithFormat:@"%@个", _model.d_price];
}

- (IBAction)backSelect:(UIButton *)sender {

    sender.selected = !sender.selected;
    _selection.selected = sender.selected;
    if (self.carBlock) {
        self.carBlock(_selection.selected);
    }
}

- (IBAction)imageButtonClick:(id)sender {
    if (_selectBlock) {
        _selectBlock();
    }
}

-(void)settingData{
    _selection.selected = _model.isSelect;

    [_selection setBackgroundImage:[UIImage imageNamed:@"newSele"] forState:UIControlStateNormal];
    [_selection setBackgroundImage:[UIImage imageNamed:@"newW"] forState:UIControlStateSelected];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_model.goods_thumb] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.clipsToBounds = YES;
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
    _GBLable.text = [NSString stringWithFormat:@"%@", _model.d_price];
    _shopUser.text = [NSString stringWithFormat:@"%@",_model.shop_title];

}
@end
