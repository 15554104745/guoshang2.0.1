//
//  GSGoodsDetialRecommendGoodsCollectionViewCell.h
//  guoshang
//
//  Created by Rechied on 2016/11/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSHomeRecommendModel.h"

@interface GSGoodsDetialRecommendGoodsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

@property (strong, nonatomic) GSHomeRecommendModel *recommendModel;
@end
