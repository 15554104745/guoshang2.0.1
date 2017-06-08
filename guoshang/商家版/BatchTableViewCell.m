//
//  BatchTableViewCell.m
//  guoshang
//
//  Created by JinLian on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "BatchTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation BatchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDateModel:(BatchManageModel *)dateModel {
    
    _dateModel = dateModel;
    
    if (dateModel.selectState)
    {
        _selectState = YES;
        _goods_selectImage.image = [UIImage imageNamed:@"xuanzhong"];
    }else{
        _selectState = NO;
        _goods_selectImage.image = [UIImage imageNamed:@"weixuanzhong"];
    }
    
    
    [_goods_image sd_setImageWithURL:[NSURL URLWithString:dateModel.goods_img]placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    _gooods_addtime.text = [NSString stringWithFormat:@"添加时间：%@",dateModel.add_time];
    _goods_information.text = dateModel.goods_name;
    _goods_sendNumber.text = [NSString stringWithFormat:@"销量:%@",dateModel.sale_num];
    _goods_save.text = [NSString stringWithFormat:@"收藏:%@",dateModel.collect_num];
    _goods_Price.text = [NSString stringWithFormat:@"￥:%@",dateModel.shop_price];
    
    NSString *oldStr = [NSString stringWithFormat:@"￥:%@",dateModel.market_price];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
    NSUInteger length = [oldStr length];
    
    [attriStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    
    [attriStr addAttribute:NSStrikethroughColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, length)];
    [self.goods_oldPrice setAttributedText:attriStr];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
