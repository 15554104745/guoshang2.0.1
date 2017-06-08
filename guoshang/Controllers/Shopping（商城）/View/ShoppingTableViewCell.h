//
//  ShoppingTableViewCell.h
//  guoshang
//
//  Created by 张涛 on 16/2/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
#import "GSShopBaseGoodsModel.h"

@interface ShoppingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *coinImage;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (strong, nonatomic) GSShopBaseGoodsModel *goodsModel;

@property (weak, nonatomic) IBOutlet UILabel *haveSaled;

@property (weak, nonatomic) IBOutlet UILabel *favoriteRate;

//金币
- (void)configGoldCellWithModel:(GoodsDetailModel *)model;
//国币
- (void)configGuoCellWithModel:(GoodsDetailModel *)model;

@end
