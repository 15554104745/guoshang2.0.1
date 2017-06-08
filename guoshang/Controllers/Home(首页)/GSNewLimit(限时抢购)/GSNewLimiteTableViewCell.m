//
//  GSNewLimiteTableViewCell.m
//  guoshang
//
//  Created by 时礼法 on 16/11/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNewLimiteTableViewCell.h"

@implementation GSNewLimiteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.goBuy.layer.borderWidth = 1;
    self.goBuy.layer.borderColor = [UIColor redColor].CGColor;
    self.goBuy.layer.cornerRadius = 8;
    self.goBuy.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
