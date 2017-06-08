//
//  GSGoodsDetialChooseSpecificationsCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetialChooseSpecificationsCell.h"

@implementation GSGoodsDetialChooseSpecificationsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setDetailModel:(GSGoodsDetailModel *)detailModel {
    [super setDetailModel:detailModel];
    if (detailModel.attribute_name) {
        self.attributeLabel.text = [NSString stringWithFormat:@"已选：%@",detailModel.attribute_name];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
