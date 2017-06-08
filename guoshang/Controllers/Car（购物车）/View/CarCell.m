//
//  CarCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/23.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import "CarCell.h"
#import "UIImageView+WebCache.h"
@implementation CarCell



- (IBAction)selectBtn:(UIButton *)sender {

   sender.selected = !sender.selected;
    
  
    if (self.carBlock) {
        
        self.carBlock(sender.selected);
        
    }
    
}

- (IBAction)imageButtonClick:(id)sender {
    if (_selectBlock) {
        _selectBlock();
    }
}



- (IBAction)reduceBtn:(UIButton *)sender {
    if(self.numCutBlock){
        self.numCutBlock();
     
    }
    
    
}



- (IBAction)backGrondBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    _selectBtn.selected = sender.selected;
    if (self.carBlock) {
        
        self.carBlock(_selectBtn.selected);
        
    }
}


- (IBAction)addBtn:(UIButton *)sender {
    if (self.numAddBlock) {
        
        self.numAddBlock();

    }
    
    
}
-(void)setModel:(carModel *)model{
    
    _model = model;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSelctTheGoodsItem:)]
    ;
    [_GoodsImage addGestureRecognizer:tap];
    _GoodsImage.userInteractionEnabled = YES;
    
    //_numberLable.layer.borderWidth = 1;
    //_numberLable.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:0.9].CGColor;
    [self settingData];
   
    
}
-(void)toSelctTheGoodsItem:(UITapGestureRecognizer *)tap{
    if (_selectBtn.selected) {
        _selectBtn.selected = NO;
    }else{
        
        _selectBtn.selected = YES;
    }
    
    if (self.carBlock) {
        
        self.carBlock(_selectBtn.selected);
        
    }
    
}
//自定义cell高度
-(void)settingFrame{
    
    //    //标题
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.size.mas_equalTo([LNLabel calculateMoreLabelSizeWithString:_model.goods_name AndWith:self.frame.size.width/3 * 2 - 20 AndFont:13]);
    }];
    
    
    //    //规格
    
    [_rankLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_titleLable.mas_left);
        make.top.equalTo(_titleLable.mas_bottom).offset(10);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"规格" AndFont:13]);
    }];
    
    //大小
    [_SizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_rankLable.mas_right).offset(5);
        make.top.equalTo(_titleLable.mas_bottom).offset(10);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"DAXZ" AndFont:13]);
    }];
    //价格
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_titleLable.mas_right);
        make.top.equalTo(_rankLable.mas_bottom).offset(10);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:_model.goods_price AndFont:13]);
    }];
    
    
    //数量
    [_numLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_priceLabel.mas_right).offset(1);
        make.top.equalTo(_rankLable.mas_bottom).offset(10);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:_model.goods_number AndFont:13]);
    }];
    
    //运费牛排
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLabel.mas_right).offset(5);
        make.top.equalTo(_rankLable.mas_bottom).offset(10);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:[NSString stringWithFormat:@"运费:%@",_model.shipping_price] AndFont:13]);
    }];
    //加
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_freightLabel.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 40));
    }];
    
    //数量
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_addBtn.mas_left);
        make.top.equalTo(_freightLabel.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 40));
    }];
    //减
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_numberLable.mas_left);
        make.top.equalTo(_freightLabel.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 40));
    }];
    
    //图片
    CGFloat  with = self.frame.size.width /3 ;
    [_GoodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLable.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(with - 30);
        make.bottom.equalTo(_priceLabel.mas_bottom);
        
    }];
    
//    //选中按钮
//    
//    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(10);
//        make.top.equalTo(_GoodsImage.mas_top).offset(30);
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//        
//    }];
    
    //送国币View
    [_GBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLable.mas_left).offset(10);
        make.top.equalTo(_GoodsImage.mas_bottom).offset(10);
        make.width.mas_equalTo(with - 30);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
}

-(void)reloadDataWith:(carModel *)model{
    
    _selectBtn.selected = model.isSelect;
    _numberLable.text = _model.goods_number;
    _numLable.text = [NSString stringWithFormat:@"* %@",_model.goods_number];
    _freightLabel.text = [NSString stringWithFormat:@"运费:%@",_model.shipping_price];
    _coinLabel.text = [NSString stringWithFormat:@"%@个", _model.d_price];
    
}

-(void)settingData{
    _selectBtn.selected = _model.isSelect;
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"newSele"] forState:UIControlStateNormal];
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"newW"] forState:UIControlStateSelected];
    [_GoodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.goods_thumb]] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    _GoodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _GoodsImage.clipsToBounds = YES;
    _numberLable.text = _model.goods_number;
    _numLable.text = [NSString stringWithFormat:@"*%@",_model.goods_number];
    _freightLabel.text = [NSString stringWithFormat:@"运费:%@",_model.shipping_price];
    _freightLabel.numberOfLines = 0;
    _titleLable.text = _model.goods_name;
    _titleLable.numberOfLines = 2;
    _priceLabel.text = _model.goods_price;
    _coinLabel.text = [NSString stringWithFormat:@"%@个", _model.d_price];
//    NSLog(@"%@",_model.shop_title);
    _shopUser.text = [NSString stringWithFormat:@"%@",_model.shop_title];
    NSString * str = [NSString stringWithFormat:@"%@",_model.attr_names];
    if (str.length > 2) {
        _rankLable.text = _model.attr_names;
    }else{
        _rankWith.constant = 0.0;
        CGFloat height = [LNLabel calculateMoreLabelSizeWithString:_model.goods_name AndWith:(self.frame.size.width - 130) AndFont:15.0];
   
        _titleWith.constant = height;
      
        
    
        
    }
    
}

@end
