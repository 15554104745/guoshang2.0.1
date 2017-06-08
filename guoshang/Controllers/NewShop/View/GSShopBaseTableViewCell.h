//
//  GSShopBaseTableViewCell.h
//  guoshang
//
//  Created by Rechied on 2016/11/3.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSShopBaseGoodsModel.h"

@interface GSShopBaseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titlaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceDecimalLabel;
@property (strong, nonatomic) GSShopBaseGoodsModel *goodsModel;

@property (weak, nonatomic) IBOutlet UILabel *favorableLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesCountLabel;

@end
