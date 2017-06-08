//
//  GSMineCollectionViewCell.m
//  guoshang
//
//  Created by Rechied on 2016/10/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSMineCollectionViewCell.h"

@implementation GSMineCollectionViewCell

- (void)setToolsModel:(GSMineToolsModel *)toolsModel {
    self.titleLabel.text = toolsModel.title;
    self.iconImageView.image = [UIImage imageNamed:toolsModel.iconName];
}

@end
