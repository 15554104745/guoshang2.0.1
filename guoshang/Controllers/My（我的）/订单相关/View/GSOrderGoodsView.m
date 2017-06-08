//
//  GSOrderGoodsView.m
//  guoshang
//
//  Created by Rechied on 16/8/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSOrderGoodsView.h"
#import "UIColor+HaxString.h"
#import "UIImageView+WebCache.h"

@interface GSOrderGoodsView()

@property (strong, nonatomic) UIImageView *goodsImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *freight_price_label;
@property (strong, nonatomic) UILabel *goods_num_label;
@property (strong, nonatomic) UIImageView *guoBiImageView;

@end

@implementation GSOrderGoodsView

- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.clipsToBounds = YES;
    }
    return _goodsImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithHexString:@"939393"];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textColor = [UIColor colorWithHexString:@"E73736"];
    }
    return _priceLabel;
}



- (UILabel *)goods_num_label {
    if (!_goods_num_label) {
        _goods_num_label = [[UILabel alloc] init];
        _goods_num_label.font = [UIFont systemFontOfSize:12];
        _goods_num_label.textColor = [UIColor colorWithHexString:@"939393"];
    }
    return _goods_num_label;
}

- (UIImageView *)guoBiImageView {
    if (!_guoBiImageView) {
        _guoBiImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guobi"]];
    }
    return _guoBiImageView;
}

- (void)createUIWithisGuoBiPay:(BOOL)isGuoBiPay {
    
    //商品图
    [self addSubview:self.goodsImageView];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.size.sizeOffset(CGSizeMake(60, 60));
    }];
    
    //商品标题
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.equalTo(_goodsImageView.mas_right).offset(10);
        //make.right.offset(50);
        make.width.offset(Width - 140);
    }];
    
    if (isGuoBiPay) {
        [self addSubview:self.guoBiImageView];
        [_guoBiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_goodsImageView.mas_right).offset(10);
            make.bottom.equalTo(_goodsImageView.mas_bottom);
        }];
    }
    //商品价格
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_guoBiImageView) {
            make.left.equalTo(_guoBiImageView.mas_right).offset(2);
            make.centerY.equalTo(_guoBiImageView.mas_centerY);
        } else {
            make.left.equalTo(_goodsImageView.mas_right).offset(10);
            make.bottom.equalTo(_goodsImageView.mas_bottom);
        }
    }];
    
    //商品数量
    [self addSubview:self.goods_num_label];
    [self.goods_num_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(self.mas_centerY).offset(-10);
    }];
}

- (void)setOrderGoodsModel:(GSOrderGoodsModel *)orderGoodsModel {
    _orderGoodsModel = orderGoodsModel;
    
    [self createUIWithisGuoBiPay:[orderGoodsModel isGuoBiPayType]];
    
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:orderGoodsModel.original_img] placeholderImage:Goods_Pleaceholder_Image];
    
    self.titleLabel.text = orderGoodsModel.goods_name;
    
    if ([orderGoodsModel isGuoBiPayType]) {
        self.priceLabel.text = [NSString stringWithFormat:@"x%@个",orderGoodsModel.exchange_integral];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",orderGoodsModel.goods_price];
    }
    
    self.goods_num_label.text = [NSString stringWithFormat:@"x%@",orderGoodsModel.goods_number];
}

@end
