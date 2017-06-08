//
//  GSStoreDetailCollectionFlowViewCell.h
//  guoshang
//
//  Created by Rechied on 16/7/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSStoreGoodsModel.h"
#import "GSHomeRecommendModel.h"
@interface GSStoreDetailCollectionFlowViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSellCountLabel;

@property (strong, nonatomic) void(^imageSizeBlock)(CGSize imageSize);

@property (strong, nonatomic) GSStoreGoodsModel *goodsModel;
@property (strong, nonatomic) GSHomeRecommendModel *recommendModel;
@end
