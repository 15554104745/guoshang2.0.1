//
//  MyCenterCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/6/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyCenterCell.h"

@implementation MyCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self addView];
        
    }

    return self;
}


-(void)addView{
    
    UIImageView * iconView = [[UIImageView alloc] init];
    _iconView = iconView;
    [self.contentView addSubview:_iconView];
    LNLabel * titleLable = [LNLabel addLabelWithTitle:@"我的收藏qweerrtt" TitleColor:WordColor Font:14 BackGroundColor:[UIColor whiteColor]];

    _titleLable = titleLable;
    [self.contentView addSubview:titleLable];
    UIImageView * icView = [[UIImageView alloc] init];
    _toImageView = icView;
   
    [self.contentView addSubview:icView];
    UIImageView * bottonView = [[UIImageView alloc] init];
    _bottonWire = bottonView;
    [self.contentView addSubview:bottonView];
    [_bottonWire setImage:[UIImage imageNamed:@"wire"]];
//    UIImageView * topView = [[UIImageView alloc] init];
//    _topWire = topView;
//    [_topWire setImage:[UIImage imageNamed:@"wire"]];
//    [self.contentView addSubview:topView];
    
    
    __weak typeof (self) weakSelf = self;
    
//    [_topWire mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf.contentView);
//        make.left.mas_equalTo(weakSelf.contentView);
//        make.right.mas_equalTo(weakSelf.contentView);
//        make.height.mas_equalTo(1);
//    }];
    
    [_bottonWire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(weakSelf.contentView);
        make.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1);
    }];

    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
   
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(5);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"我的收藏" AndFont:15]);
    }];
    
    [_toImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(20);
        make.height.equalTo(@10);
        make.width.equalTo(@10);
        
    }];
}




-(void)setMyArray:(NSMutableArray *)myArray{
 
        _myArray = myArray;
        [self settingData];
 
    
    
}


-(void)settingData{
   
    _iconView.image =[UIImage imageNamed:_myArray[0]];
    _titleLable.text = _myArray[1];
    _toImageView.image = [UIImage imageNamed:@"gengduo2"];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
