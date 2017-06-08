//
//  GSShopBaseSiftSectionCollectionReusableView.m
//  guoshang
//
//  Created by Rechied on 2016/11/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSShopBaseSiftSectionCollectionReusableView.h"

@implementation GSShopBaseSiftSectionCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)showAllButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if ([_delegate respondsToSelector:@selector(showAllButtonDidClickWithSection:selected:)]) {
        [_delegate showAllButtonDidClickWithSection:self.section selected:sender.isSelected];
    }
}

@end
