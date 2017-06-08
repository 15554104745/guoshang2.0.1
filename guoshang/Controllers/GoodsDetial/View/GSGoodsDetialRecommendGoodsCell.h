//
//  GSGoodsDetialRecommendGoodsCell.h
//  guoshang
//
//  Created by Rechied on 2016/11/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetailBaseCell.h"

@protocol GSGoodsDetialRecommendGoodsCellDelegate <NSObject>

- (void)goodsDetailRecommendGoodsCellDidUpdateHeight;
- (void)goodsDetailRecommendGoodsCellDidSelectGoodsWithGoodsModel:(id)goodsModel;

@end


@interface GSGoodsDetialRecommendGoodsCell : GSGoodsDetailBaseCell
@property (weak, nonatomic) IBOutlet UICollectionView *recommendCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommendContentViewHeight;

@property (weak, nonatomic) id delegate;
@end
