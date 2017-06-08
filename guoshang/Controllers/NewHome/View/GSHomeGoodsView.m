//
//  GSHomeGoodsView.m
//  guoshang
//
//  Created by Rechied on 16/8/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSHomeGoodsView.h"
#import "UIImageView+WebCache.h"
#import "GSGoodsDetailInfoViewController.h"
#import "UIColor+HaxString.h"
@interface GSHomeGoodsView()
@property (strong, nonatomic) UIImageView *goodsImageView;
@property (strong, nonatomic) LNLabel *label;
@property (strong, nonatomic) GSHomeCellGoodsModel *goodsModel;
@property (weak, nonatomic) UIImageView *isHotImageView;
@property (weak, nonatomic) UIImageView *isNewImageView;
@end

@implementation GSHomeGoodsView

- (instancetype)initWithGoodsModel:(GSHomeCellGoodsModel *)goodsModel labStr:(NSString *)labStr labColor:(NSString *)labColor {
    self = [super init];
    if (self) {
        self.goodsModel = goodsModel;
//        self.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
//        self.layer.borderWidth = 0.5f;
        __weak typeof(self) weakSelf = self;
        //顶部image
        [self addSubview:self.goodsImageView];
        [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_offset(0);
            make.height.equalTo(weakSelf.mas_width);
        }];
        [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.thumb] placeholderImage:Goods_Pleaceholder_Image];
        
        //设置热销、新品
        [self setGoodsAttributeWithIsNew:goodsModel.is_new isHot:goodsModel.is_hot];
        
        
        /*
        //标签
        [self addSubview:[self createLabelWithLabString:labStr bgColor:labColor]];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5.0f);
            make.top.equalTo(_goodsImageView.mas_bottom).offset(5);
            make.width.offset([labStr sizeWithAttributes:@{NSFontAttributeName:_label.font}].width + 5);
        }];
         */
        
        
        //标题
        LNLabel *titleLabel = [LNLabel addLabelWithTitle:goodsModel.name TitleColor:[UIColor lightGrayColor] Font:12.0f BackGroundColor:[UIColor clearColor]];
        titleLabel.numberOfLines = 2;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_goodsImageView.mas_bottom).offset(5);
                make.left.offset(5);
                make.width.equalTo(weakSelf.mas_width).offset(-10);
            }];
        }];
        
        
//        //原价格
//        LNLabel *market_priceLabel = [LNLabel addLabelWithTitle:goodsModel.market_price TitleColor:[UIColor colorWithHexString:@"ababab"] Font:10.0f BackGroundColor:[UIColor clearColor]];
//        [self addSubview:market_priceLabel];
//        [market_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            //make.right.offset(-5);
//            //make.centerX.equalTo(weakSelf.mas_centerX).offset(-5);
//            make.left.offset(7);
//            make.bottom.offset(-5);
//        }];
        
        //商店价格
        LNLabel *shop_priceLabel = [LNLabel addLabelWithTitle:(goodsModel.promote_price && ![goodsModel.promote_price isEqualToString:@""]) ? goodsModel.promote_price : goodsModel.shop_price TitleColor:[UIColor redColor] Font:12.0f BackGroundColor:[UIColor clearColor]];
        [self addSubview:shop_priceLabel];
        [shop_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.left.offset(5);
            make.left.offset(5);
            //make.centerX.equalTo(weakSelf.mas_centerX).offset(-5);
            //make.bottom.equalTo(market_priceLabel.mas_top).offset(2);
            make.bottom.offset(-2);
        }];
        
//        UILabel *line = [[UILabel alloc] init];
//        line.backgroundColor = [UIColor colorWithHexString:@"ababab"];
//        [self addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.offset(.5);
//            make.centerX.equalTo(market_priceLabel.mas_centerX);
//            make.centerY.equalTo(market_priceLabel.mas_centerY);
//            make.width.equalTo(market_priceLabel.mas_width);
//        }];
        
        
        
        
    }
    return self;
}

- (void)setPushClick:(void (^)(UIViewController *))pushClick {
    _pushClick = pushClick;
    __weak typeof(self) weakSelf = self;
    if (pushClick) {
        
        LNButton *button = [LNButton buttonWithType:UIButtonTypeSystem Title:@"" TitleColor:nil Font:0 image:nil andBlock:^(LNButton *button) {
            GSGoodsDetailInfoViewController *showViewController = [[GSGoodsDetailInfoViewController alloc] init];
            showViewController.hidesBottomBarWhenPushed = YES;
            showViewController.recommendModel = weakSelf.goodsModel;
            weakSelf.pushClick(showViewController);
        }];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_offset(0);
        }];
    }
}

- (void)setGoodsAttributeWithIsNew:(NSString *)isNew isHot:(NSString *)isHot {
    if ([isNew isEqualToString:@"1"]) {
        
        [_goodsImageView addSubview:self.isNewImageView];
        [_isNewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.bottom.offset(0);
        }];
    } else {
        [_isNewImageView removeFromSuperview];
    }
    
    if ([isHot isEqualToString:@"1"]) {
        
        [_goodsImageView addSubview:self.isHotImageView];
        [_isHotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(3);
            make.top.offset(0);
        }];
    } else {
        [_isHotImageView removeFromSuperview];
    }
}

- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
    }
    return _goodsImageView;
}

- (UIImageView *)isHotImageView {
    if (!_isHotImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_goods_isHot"]];
        _isHotImageView = imageView;
        return _isHotImageView;
    }
    return _isHotImageView;
}

- (UIImageView *)isNewImageView {
    if (!_isNewImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_goods_isNew"]];
        _isNewImageView = imageView;
        return _isNewImageView;
    }
    return _isNewImageView;
}


- (LNLabel *)createLabelWithLabString:(NSString *)labString bgColor:(NSString *)bgColor {
    if (!_label) {
        _label = [LNLabel addLabelWithTitle:labString TitleColor:[UIColor whiteColor] Font:10.0f BackGroundColor:[UIColor colorWithHexString:bgColor]];
        _label.layer.cornerRadius = 2.0f;
        _label.layer.masksToBounds = YES;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
