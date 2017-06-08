//
//  GSShopBaseSiftCollectionViewCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/5.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSShopBaseSiftCollectionViewCell.h"
#import "UIColor+HaxString.h"

@implementation GSShopBaseSiftCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected {
    self.titleLabel.textColor = selected ? [UIColor colorWithHexString:@"f23030"] : [UIColor colorWithHexString:@"242424"];
}

@end
