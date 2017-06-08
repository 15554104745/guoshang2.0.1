//
//  RecommodCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "RecommodCell.h"

@implementation RecommodCell

-(void)setModel:(BestModel *)model{
    _imageHeight.constant = self.frame.size.width;
    _model = model;
    _titleWith.constant  = [LNLabel  calculateMoreLabelSizeWithString:_model.name AndWith:self.frame.size.width - 10 AndFont:15.0];
    
    self.backgroundColor = [UIColor whiteColor];
    [self settingData];
}



-(void)settingData{

    _priceLable.text = _model.shop_price;
    _titleLable.numberOfLines = 2;
    _titleLable.text = _model.name;
    NSString * str = [NSString stringWithFormat:@"%@",_model.thumb];
    [_IconView setImageWithURL:[NSURL URLWithString:str]placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];

}


@end
