//
//  GSHomeLimitCell.m
//  guoshang
//
//  Created by Rechied on 16/8/5.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSHomeLimitCell.h"

@implementation GSHomeLimitCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(65*(Height/667.0f));
        }];
        
        [self addSubview:self.marketPriceLabel];
        [_marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self addSubview:self.limitPriceLabel];
        [_limitPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_marketPriceLabel.mas_top).offset(0);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        
        
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (LNLabel *)marketPriceLabel {
    if (!_marketPriceLabel) {
        _marketPriceLabel = [LNLabel addLabelWithTitle:@"" TitleColor:[UIColor grayColor] Font:10.0f BackGroundColor:[UIColor clearColor]];
        _marketPriceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _marketPriceLabel;
}

- (LNLabel *)limitPriceLabel {
    if (!_limitPriceLabel) {
        _limitPriceLabel = [LNLabel addLabelWithTitle:@"" TitleColor:[UIColor redColor] Font:11.0f BackGroundColor:[UIColor clearColor]];
        _limitPriceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _limitPriceLabel;
}

- (void)setLimitModel:(GSHomeLimitModel *)limitModel {
    _limitModel = limitModel;
    [_imageView setImageWithURL:[NSURL URLWithString:limitModel.thumb] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    _limitModel = limitModel;
    _limitPriceLabel.text = (limitModel.promote_price && ![limitModel.promote_price isEqualToString:@""]) ? limitModel.promote_price : limitModel.shop_price;
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:limitModel.market_price attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[UIColor grayColor],NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]}];
    [_marketPriceLabel setAttributedText:mString];
    if (_clickBlock) {
        
        [self addSubview:self.button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_offset(0);
        }];
    }
}

- (void)setClickBlock:(void (^)(GSHomeLimitModel *))clickBlock {
    _clickBlock = clickBlock;
    if (_limitModel) {
        [self addSubview:self.button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_offset(0);
        }];
    }
}

- (LNButton *)button {
    if (!_button) {
        _button = [LNButton buttonWithType:UIButtonTypeSystem Title:@"" TitleColor:nil Font:0 image:nil andBlock:^(LNButton *button) {
            if (_clickBlock) {
                _clickBlock(_limitModel);
                
            }
        }];
    }
    return _button;
}


@end
