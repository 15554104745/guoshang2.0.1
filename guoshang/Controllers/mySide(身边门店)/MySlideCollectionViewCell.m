//
//  MySlideCollectionViewCell.m
//  guoshang
//
//  Created by 大菠萝 on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MySlideCollectionViewCell.h"

@implementation MySlideCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        _picImageView=[[UIImageView alloc]init];
        self.contentView.backgroundColor=[UIColor blueColor];
        _picImageView.backgroundColor=[UIColor greenColor];
        [self.contentView addSubview:_picImageView];
        [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.contentView.mas_left);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.width.mas_equalTo(Podding*2);
            make.height.mas_equalTo(Podding*2);
            
            
        }];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.numberOfLines=0;
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.top.mas_equalTo(_picImageView.mas_bottom).offset(5);
            make.width.mas_equalTo(Podding*2);
            make.height.mas_equalTo(30);
        }];
        _priceLabel=[[UILabel alloc]init];
        _priceLabel.numberOfLines=0;
        _priceLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.contentView.mas_left);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(Podding);
            make.height.mas_equalTo(20);
        }];
        _numberLabel=[[UILabel alloc]init];
        _numberLabel.numberOfLines=0;
        _numberLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_numberLabel];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(_priceLabel.mas_right).offset(5);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(Podding);
            make.height.mas_equalTo(20);
        }];
        
        
    }
    
    return self;
    
}



@end
