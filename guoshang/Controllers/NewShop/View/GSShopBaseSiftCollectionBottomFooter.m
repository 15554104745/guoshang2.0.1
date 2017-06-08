//
//  GSShopBaseSiftCollectionBottomFooter.m
//  guoshang
//
//  Created by Rechied on 2016/11/7.
//  Copyright © 2016年 hi. All rights r/Users/rechied/Desktop/iOSWorkSpace/guoshang3.1.1/guoshang/Controllers/NewShop/View/GSShopBaseSiftCollectionBottomFooter.heserved.
//

#import "GSShopBaseSiftCollectionBottomFooter.h"

@implementation GSShopBaseSiftCollectionBottomFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)resertButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(resertButtonClick)]) {
        [_delegate resertButtonClick];
    }
}

- (IBAction)commitButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(commitButtonClick)]) {
        [_delegate commitButtonClick];
    }
}

@end
