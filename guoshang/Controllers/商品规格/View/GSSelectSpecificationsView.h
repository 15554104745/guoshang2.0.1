//
//  GSSelectSpecificationsView.h
//  guoshang
//
//  Created by Rechied on 2016/11/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSGoodsSpecificationsTotalModel.h"
#import "BuyCountView.h"

@interface GSSelectSpecificationsView : UIView

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) BuyCountView *countView;

@property (nonatomic, assign) BOOL notShowChangCount;
@property (strong, nonatomic) GSGoodsSpecificationsTotalModel *specificationsTotalModel;

- (instancetype)initWithGoodsModel:(id)goodsModel hasSpecifications:(BOOL)hasSpecifications;

@end
