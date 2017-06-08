//
//  GSCarRecommendGoodsCollectionViewCell.h
//  guoshang
//
//  Created by Rechied on 2016/11/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSHomeRecommendModel.h"

@protocol GSCarRecommendGoodsCollectionViewCellDelegate <NSObject>

- (void)carRecommendGoodsCellWillAddToCarWithGoods_id:(NSString *)goods_id;

@end

@interface GSCarRecommendGoodsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *decimalLabel;

@property (weak, nonatomic) id <GSCarRecommendGoodsCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) GSHomeRecommendModel *goodsModel;
@end
