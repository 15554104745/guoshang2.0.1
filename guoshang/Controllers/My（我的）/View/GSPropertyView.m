//
//  GSPropertyView.m
//  guoshang
//
//  Created by Rechied on 16/7/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSPropertyView.h"

@implementation GSPropertyView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    self = [super init];
    
    _bgImageView = [[UIImageView alloc] init];
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
    
    _leftView = [UIView new];
    _midView = [UIView new];
    _rightView = [UIView new];
    [self addSubview:_leftView];
    [self addSubview:_midView];
    [self addSubview:_rightView];
    
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_offset(0);
    }];
    
    [_midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftView.mas_right).offset(0);
        make.width.equalTo(_leftView.mas_width);
        make.top.bottom.mas_offset(0);
    }];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_midView.mas_right).offset(0);
        make.top.right.bottom.mas_offset(0);
        make.width.equalTo(_leftView.mas_width);
    }];
    
    _jinBiLab = [LNLabel addLabelWithTitle:@"金币: 0.00" TitleColor:WhiteColor Font:12 BackGroundColor:[UIColor clearColor]];
    [_leftView addSubview:_jinBiLab];
    
    _guoBiLab = [LNLabel addLabelWithTitle:@"国币: 0.00" TitleColor:WhiteColor Font:12 BackGroundColor:[UIColor clearColor]];
    [_midView addSubview:_guoBiLab];
    
    _chuZhiKaLab = [LNLabel addLabelWithTitle:@"储值卡: 0.00" TitleColor:WhiteColor Font:12 BackGroundColor:[UIColor clearColor]];
    [_rightView addSubview:_chuZhiKaLab];
    
    [_jinBiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_leftView.mas_centerX);
         make.centerY.equalTo(_leftView.mas_centerY);
    }];
    
    [_guoBiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_midView.mas_centerX);
        make.centerY.equalTo(_midView.mas_centerY);
    }];
    
    [_chuZhiKaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rightView.mas_centerX);
        make.centerY.equalTo(_rightView.mas_centerY);
    }];
    
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 400+i;
        [button addTarget:self action:@selector(propertyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:
                [_leftView addSubview:button];
                break;
                
            case 1:
                [_midView addSubview:button];
                break;
                
            case 2:
                [_rightView addSubview:button];
                break;
                
            default:
                break;
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_offset(0);
        }];
        
    }
    
    return self;
}

- (void)propertyButtonClick:(UIButton *)button {
    NSInteger index = button.tag - 400;
    //NSLog(@"%zi",index);
    if (_propertyButtonClickBlock) {
        _propertyButtonClickBlock(index);
    }
}


- (void)setGoldNum:(NSString *)goldNum guobiNum:(NSString *)guobiNum topupCardNum:(NSString *)topupCardNum {
    
    _jinBiLab.text = [NSString stringWithFormat:@"金币: %@",goldNum];
    _guoBiLab.text = [NSString stringWithFormat:@"国币: %@",guobiNum];
    _chuZhiKaLab.text = [NSString stringWithFormat:@"充值卡: %@",topupCardNum];
}


@end
