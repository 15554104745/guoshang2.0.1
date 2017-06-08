//
//  TranscationTableViewCell.m
//  guoshang
//
//  Created by JinLian on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "TranscationTableViewCell.h"

@implementation TranscationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(TransactionModel *)model {
    
    _model = model;
    
    self.label_time.text = model.add_time;
    self.label_money.text = model.amount_desc;
    self.label_describe.text = model.trade_desc;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
