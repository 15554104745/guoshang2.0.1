//
//  MoneyCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@interface MoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;//图片
@property (weak, nonatomic) IBOutlet UILabel *titleLable;//标题
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;//颜色等规格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *countLable;//数量


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tilteWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankwith;
@property (weak, nonatomic) IBOutlet UILabel *fieghtLable;//运费
@property(nonatomic,strong)GoodsModel * model;
@end
