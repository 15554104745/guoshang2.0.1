//
//  ShoppingCollectionViewCell.h
//  guoshang
//
//  Created by 张涛 on 16/3/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSShopBaseGoodsModel.h"

@interface ShoppingCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UIImageView *coinView;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *saledLabel;

@property (weak, nonatomic) IBOutlet UIImageView *moreImage;

@property (weak, nonatomic) IBOutlet UILabel *favoriteLable;


@property (strong, nonatomic) GSShopBaseGoodsModel *goodsModel;


@end
