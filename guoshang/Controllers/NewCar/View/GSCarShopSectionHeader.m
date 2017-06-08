//
//  GSCarShopSectionHeader.m
//  guoshang
//
//  Created by Rechied on 2016/11/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCarShopSectionHeader.h"
#import "GSCarShopModel.h"

@implementation GSCarShopSectionHeader

- (UILabel *)shopTitleLabel {
    if (!_shopTitleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor colorWithHexString:@"242424"];
        _shopTitleLabel = label;
        return _shopTitleLabel;
    }
    return _shopTitleLabel;
}

- (UIButton *)chackMarkButton {
    if (!_chackMarkButton) {
        UIButton *chackMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [chackMarkButton setImage:[UIImage imageNamed:@"icon_car_chackMark_normal"] forState:UIControlStateNormal];
        [chackMarkButton setImage:[UIImage imageNamed:@"icon_car_chackMark_select"] forState:UIControlStateSelected];
        [chackMarkButton addTarget:self action:@selector(chackMarkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _chackMarkButton = chackMarkButton;
        return _chackMarkButton;
    }
    return _chackMarkButton;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"F0F2F5"];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.offset(10);
    }];
    
    UIView *sep = [[UIView alloc] init];
    sep.backgroundColor = [UIColor colorWithHexString:@"E3E5E9"];
    [view addSubview:sep];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(0.5f);
    }];
    
    [self addSubview:self.chackMarkButton];
    [_chackMarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15.0f);
        make.centerY.offset(5);
    }];
    
    UIImageView *shopIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_car_shopLogo"]];
    [self addSubview:shopIcon];
    [shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_chackMarkButton.mas_right).offset(10);
        make.centerY.offset(5);
    }];
    
    [self addSubview:self.shopTitleLabel];
    [_shopTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopIcon.mas_right).offset(5);
        make.centerY.offset(5);
    }];
}

- (void)setShopModel:(GSCarShopModel *)shopModel {
    _shopModel = shopModel;
    self.shopTitleLabel.text = shopModel.shop_title;
    self.chackMarkButton.selected = shopModel.select_shop;
}

- (void)chackMarkButtonAction:(UIButton *)sender {
    self.shopModel.select_shop = !self.shopModel.select_shop;
    [self setShopModel:_shopModel];
    if ([_delegate respondsToSelector:@selector(carShopSectionCellDidChangeSelectWithGoodsModel:inSection:)]) {
        [_delegate carShopSectionCellDidChangeSelectWithGoodsModel:_shopModel inSection:_section];
    }
}

@end
