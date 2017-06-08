//
//  GSOrderGoosInfoTableViewCell.h
//  guoshang
//
//  Created by Rechied on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
#import "GSOrderGoodsModel.h"
@interface GSOrderGoosInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *turePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *salesVolumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;


@property (weak, nonatomic) IBOutlet UIImageView *guoBiImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guoBiImageWidth;


@property (strong, nonatomic) GSOrderGoodsModel *goodsModel;
@end
