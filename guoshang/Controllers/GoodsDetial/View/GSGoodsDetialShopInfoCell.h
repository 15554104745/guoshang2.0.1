//
//  GSGoodsDetialShopInfoCell.h
//  guoshang
//
//  Created by Rechied on 2016/11/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetailBaseCell.h"

@interface GSGoodsDetialShopInfoCell : GSGoodsDetailBaseCell

@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *collectShopButton;
@property (weak, nonatomic) IBOutlet UIButton *toShopButton;

@property (weak, nonatomic) IBOutlet UILabel *allGoodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *addGoodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *carePeopleCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNumberViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectButtonViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginConstant;


@end
