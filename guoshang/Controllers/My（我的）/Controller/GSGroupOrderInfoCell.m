//
//  GSGroupOrderInfoCell.m
//  guoshang
//
//  Created by 金联科技 on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGroupOrderInfoCell.h"
#import "GSCustomOrderInfoModel.h"
#import "UIImageView+WebCache.h"
@interface GSGroupOrderInfoCell ()
//图片
@property (weak, nonatomic) IBOutlet UIImageView *goods_thumb;
//产品名称
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
//销量
@property (weak, nonatomic) IBOutlet UILabel *sale_num;
//收藏
@property (weak, nonatomic) IBOutlet UILabel *collect;
//现价
@property (weak, nonatomic) IBOutlet UILabel *goods_price;
//现价
@property (weak, nonatomic) IBOutlet UILabel *market_price;

@property (weak, nonatomic) IBOutlet UILabel *count;



@end

@implementation GSGroupOrderInfoCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(void)layoutSubviews{
    [super layoutSubviews];

}

-(void)setMyGoodsModel:(GSMyOrderGoodsInfoModel *)myGoodsModel{
    _myGoodsModel = myGoodsModel;

    self.goods_name.text= myGoodsModel.goods_name;
    self.sale_num.text = @"";
    self.collect.text = @"";
    self.goods_price.text = myGoodsModel.goods_price;
    self.market_price.text =@"";
    [self.goods_thumb sd_setImageWithURL:[NSURL URLWithString:myGoodsModel.goods_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    self.count.text = [NSString stringWithFormat:@"X%@",myGoodsModel.goods_num];
}
-(void)setModel:(GSCustomGoodsInfoModel *)model{
    _model = model;
    self.goods_name.text= model.goods_name;
    self.sale_num.text = [NSString stringWithFormat:@"销量：%@",model.sale_num];
    self.collect.text = [NSString stringWithFormat:@"收藏：%@",model.collect];
    self.goods_price.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
    self.market_price.text = [NSString stringWithFormat:@"￥%@",model.market_price];
    [self.goods_thumb sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    self.count.text = [NSString stringWithFormat:@"X%@",model.goods_number];
}
@end
