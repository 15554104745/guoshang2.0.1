//
//  GSChackOutOrderTableViewCell.h
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChackOutOrderSingleGoodsModel.h"

@interface GSChackOutOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guoBiIconImageViewWidth;

@property (weak, nonatomic) IBOutlet UIImageView *guoBiIconImageView;

@property (assign, nonatomic) GSChackOutOrderType chackOutOrderType;

@property (strong, nonatomic) GSChackOutOrderSingleGoodsModel *singleGoodsModel;
@end
