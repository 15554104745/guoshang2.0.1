//
//  OrderMomeyCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/4/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "OrderMomeyCell.h"

@implementation OrderMomeyCell
-(void)setDic:(NSMutableDictionary *)dic{
    _dic = dic;
    _priceLabel.text = [NSString stringWithFormat:@"￥ %@",_dic[@"all_price"]];
    _countLabel.text = [NSString stringWithFormat:@"%@",_dic[@"order_number"]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
