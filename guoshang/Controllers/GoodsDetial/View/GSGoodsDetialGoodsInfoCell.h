//
//  GSGoodsDetialGoodsInfoCell.h
//  guoshang
//
//  Created by Rechied on 2016/11/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetailBaseCell.h"


@interface GSGoodsDetialGoodsInfoCell : GSGoodsDetailBaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *decimalLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *greatChanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *RenminbiIcon;
@property (weak, nonatomic) IBOutlet UILabel *decimalPoint;

@property (strong, nonatomic) id recommendModel;

@end
