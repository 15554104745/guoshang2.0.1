//
//  BaseCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/1.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@interface BaseCell : UITableViewCell
@property (weak, nonatomic)  UIImageView *IconVIew;
@property (weak, nonatomic)  UILabel *titleLabel;
@property (weak, nonatomic)  UILabel *fieghtPriceLabel;
@property (weak, nonatomic)  UILabel *priceLable;
@property (weak, nonatomic)  UILabel *countLabel;
@property (weak, nonatomic)  UIImageView *wireIcon;

@property(nonatomic,strong)GoodsModel * model;

@end

