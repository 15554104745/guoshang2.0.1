//
//  ThreeCollectionViewCell.h
//  guoshang
//
//  Created by JinLian on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreeViewModel.h"

@interface ThreeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)ThreeViewModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *lab_name;

@property (weak, nonatomic) IBOutlet UILabel *lab_price;


@end
