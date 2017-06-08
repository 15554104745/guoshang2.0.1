//
//  MultilevelCollectionViewCell.m
//  MultilevelMenu
//
//  Created by gitBurning on 15/3/13.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "MultilevelCollectionViewCell.h"

@implementation MultilevelCollectionViewCell

- (void)awakeFromNib {
    
}

-(UILabel *)titile
{
    _titile.layer.cornerRadius = 5;
    _titile.clipsToBounds = YES;
    return _titile;
}

@end
