//
//  MySlideHeaderCollectionReusableView.m
//  guoshang
//
//  Created by 大菠萝 on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MySlideHeaderCollectionReusableView.h"

@implementation MySlideHeaderCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self=[super initWithFrame:frame]) {
        
        
        _headPhotoBtn=[[UIButton alloc]init];
        [self addSubview:_headPhotoBtn];
        // [_headPhotoBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_headPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(10);
            make.top.mas_equalTo(self.mas_top).offset(10);
            //         make.width.mas_equalTo(Podding);
            //         make.height.mas_equalTo(Podding);
            make.width.mas_equalTo(Podding*2);
            make.width.mas_equalTo(Podding);
            
        }];
        
        
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(10);
            make.top.mas_equalTo(_headPhotoBtn.mas_bottom).offset(5);
            make.width.mas_equalTo(Podding);
            make.height.mas_equalTo(10);
        }];
        
        
        _moneyLabel=[[UILabel alloc]init];
        _moneyLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headPhotoBtn.mas_right).offset(10);
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.width.mas_equalTo(Podding);
            make.height.mas_equalTo(10);
        }];
        
        
        _peisongLabel=[[UILabel alloc]init];
        _peisongLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_peisongLabel];
        [_peisongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_moneyLabel.mas_right).offset(10);
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.width.mas_equalTo(Podding);
            make.height.mas_equalTo(10);
        }];
        
        
        _timeLabel=[[UILabel alloc]init];
        _timeLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_moneyLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headPhotoBtn.mas_right).offset(10);
            make.top.mas_equalTo(_moneyLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(Podding*2);
            make.height.mas_equalTo(10);
        }];
        
        
        
        UIButton *bt=[[UIButton alloc]init];
        _xiangqingBtn=bt;
        [_xiangqingBtn addTarget:self action:@selector(toXiangqing:) forControlEvents:UIControlEventTouchUpInside];
        [_xiangqingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_peisongLabel.mas_right);
            make.top.mas_equalTo(_timeLabel.mas_right);
            make.width.mas_equalTo(Podding);
            make.height.mas_equalTo(Podding);
        }];
        
        [self addSubview:_xiangqingBtn];
        
        UIView *vie=[[UIView alloc]init];
        [self addSubview:vie];
        [vie mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(Width);
            make.height.mas_equalTo(70);
        }];
        
        
        
        
        _fenleiLabel=[[UILabel alloc]init];
        _fenleiLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_fenleiLabel];
        [_fenleiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(5);
            make.top.mas_equalTo(vie.mas_bottom).offset(10);
            make.width.mas_equalTo(Podding);
            make.height.mas_equalTo(10);
        }];
        
        _moreBtn=[[UIButton alloc]init];
        [_moreBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(toMore:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.top.mas_equalTo(_timeLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(Podding*2);
            make.height.mas_equalTo(10);
        }];
        
        _breadBtn=[[UIButton alloc]init];
        [_breadBtn setTitle:@"面包饮料" forState:UIControlStateNormal];
        [_breadBtn addTarget:self action:@selector(toBread:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_breadBtn];
        [_breadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(5);
            make.top.mas_equalTo(_fenleiLabel.mas_left).offset(5);
            make.width.mas_equalTo(Podding);
            make.height.mas_equalTo(10);
        }];
        
        _snacksBtn=[[UIButton alloc]init];
        [_snacksBtn setTitle:@"休闲小吃" forState:UIControlStateNormal];
        [_snacksBtn addTarget:self action:@selector(toSnacks:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_snacksBtn];
        [_snacksBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_breadBtn.mas_right).offset(10);
            make.top.mas_equalTo(_fenleiLabel.mas_left).offset(5);
            make.width.mas_equalTo(Podding);
            make.height.mas_equalTo(10);
        }];
        
        _dairyBtn=[[UIButton alloc]init];
        [_dairyBtn setTitle:@"奶制品" forState:UIControlStateNormal];
        [_dairyBtn addTarget:self action:@selector(toDairy:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dairyBtn];
        [_dairyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_snacksBtn.mas_right).offset(10);
            make.top.mas_equalTo(_fenleiLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(Podding);
            make.height.mas_equalTo(10);
        }];
        
        
        _jindeBtn=[[UIButton alloc]init];
        [_jindeBtn setTitle:@"烟酒糖茶" forState:UIControlStateNormal];
        [_jindeBtn addTarget:self action:@selector(toJinde:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_jindeBtn];
        [_jindeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_dairyBtn.mas_right).offset(10);
            make.top.mas_equalTo(_fenleiLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(Podding);
            make.height.mas_equalTo(10);
        }];
        
        
    }
    return  self;
    
}

//跳转查看详情页面
-(void)toXiangqing:(UIButton*)btn
{
    
    
}
//跳转商品分类更多页面
-(void)toMore:(UIButton*)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(tiaozhuan)]) {
        
        [_delegate tiaozhuan];
        
    }
    
}

-(void)toBread:(UIButton*)btn
{
    
    
}
-(void)toSnacks:(UIButton*)btn
{
    
    
}
-(void)toDairy:(UIButton*)btn
{
    
    
}
-(void)toJinde:(UIButton*)btn
{
    
    
}

@end
