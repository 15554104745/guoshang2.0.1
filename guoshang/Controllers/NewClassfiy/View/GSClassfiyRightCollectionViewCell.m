//
//  GSClassfiyRightCollectionViewCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSClassfiyRightCollectionViewCell.h"
#import "UIColor+HaxString.h"

@implementation GSClassfiyRightCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [[UIColor colorWithHexString:@"dcdcdc"] CGColor];
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
}

- (void)setItemModel:(GSClassfiyItemModel *)itemModel {
    _itemModel = itemModel;
    self.titleLabel.text = itemModel.name;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithHexString:@"efefef"];
        //[self performSelector:@selector(setHighlighted:) withObject:@(0) afterDelay:0.5];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}


@end
