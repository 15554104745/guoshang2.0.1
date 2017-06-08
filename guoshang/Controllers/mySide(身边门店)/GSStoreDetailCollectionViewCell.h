//
//  GSStoreDetailCollectionViewCell.h
//  guoshang
//
//  Created by Rechied on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSStoreGoodsModel.h"

@interface GSStoreDetailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellCountLabel;

@property (strong, nonatomic) GSStoreGoodsModel *goodsModel;
@end
