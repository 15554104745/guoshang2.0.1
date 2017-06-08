//
//  RecommendCollectionViewCell.h
//  Demo
//
//  Created by JinLian on 16/8/10.
//  Copyright © 2016年 GroupFly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotGoodsModel.h"

@interface RecommendCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *lab_desc;

@property (weak, nonatomic) IBOutlet UILabel *lab_price;

@property (nonatomic, retain)HotGoodsModel *model;

@end
