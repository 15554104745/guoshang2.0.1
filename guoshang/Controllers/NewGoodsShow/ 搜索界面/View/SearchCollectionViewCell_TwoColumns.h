//
//  SearchCollectionViewCell_TwoColumns.h
//  guoshang
//
//  Created by 孙涛 on 16/10/6.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultModel.h"

@interface SearchCollectionViewCell_TwoColumns : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goods_image;

@property (weak, nonatomic) IBOutlet UILabel *goodsTitle_lab;

@property (weak, nonatomic) IBOutlet UILabel *goodsPrice_lab;

@property (weak, nonatomic) IBOutlet UILabel *goodsStyle_lab;


@property (nonatomic, strong)SearchResultModel *model;



@end
