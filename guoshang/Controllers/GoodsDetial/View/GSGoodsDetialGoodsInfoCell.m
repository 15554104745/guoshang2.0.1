//
//  GSGoodsDetialGoodsInfoCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetialGoodsInfoCell.h"
#import "GSHomeRecommendModel.h"
#import "GSShopBaseGoodsModel.h"
#import "Masonry.h"

@implementation GSGoodsDetialGoodsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setRecommendModel:(id)recommendModel {
    NSString *goods_name, *shop_picre, *market_price = nil;
    NSDictionary *dic = [recommendModel mj_keyValues];
    goods_name = dic[@"name"] ? dic[@"name"] : dic[@"goods_name"];
    shop_picre = dic[@"shop_price"];
    market_price = dic[@"market_price"];

    
    self.titleLabel.text = goods_name;
    self.priceLabel.text = [[[shop_picre  componentsSeparatedByString:@"."] firstObject] stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    self.decimalLabel.text = [[shop_picre componentsSeparatedByString:@"."] lastObject];
    self.originalPriceLabel.text = market_price;
    self.describeLabel.hidden = YES;
    self.sellCountLabel.hidden = YES;
    self.greatChanceLabel.hidden = YES;
}

- (void)setGoodsModel:(GSShopBaseGoodsModel *)goodsModel {
    self.titleLabel.text = goodsModel.name;
    self.originalPriceLabel.text = goodsModel.market_price;
    self.describeLabel.hidden = YES;
    self.sellCountLabel.hidden = YES;
    self.greatChanceLabel.hidden = YES;
}

- (void)setDetailModel:(GSGoodsDetailModel *)detailModel {
    
    [super setDetailModel:detailModel];
    
    //对兑换商品和普通商品进行区分
   
     self.titleLabel.text = detailModel.goodsinfo.goods_name;
    self.sellCountLabel.text = [NSString stringWithFormat:@"已售%@件",detailModel.goodsinfo.goods_sales];
    self.greatChanceLabel.text = [NSString stringWithFormat:@"%@好评",detailModel.goodsinfo.favorable_rate];
    self.originalPriceLabel.text = detailModel.goodsinfo.market_price;
    self.describeLabel.text = detailModel.goodsinfo.goods_brief;
    self.priceLabel.text = [[[detailModel.goodsinfo.shop_price componentsSeparatedByString:@"."] firstObject] stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    self.decimalLabel.text = [[detailModel.goodsinfo.shop_price componentsSeparatedByString:@"."] lastObject];
    self.describeLabel.hidden = NO;
    self.sellCountLabel.hidden = NO;
    self.greatChanceLabel.hidden = NO;
     //如果是国币商品
    if ([detailModel.goodsinfo.is_exchange isEqualToString:@"1"]) {
        UIImageView *GuobiIconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guobi"]];
        [self addSubview:GuobiIconImage];
        [GuobiIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.describeLabel.mas_bottom).offset(20);
            make.left.mas_offset(@5);
            make.width.height.mas_offset(20);
        }];
        
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(30);
        }];
        
        self.RenminbiIcon.hidden = YES;
        self.decimalPoint.hidden = YES;
        self.decimalLabel.hidden = YES;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
