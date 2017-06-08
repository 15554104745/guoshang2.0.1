//
//  GoodsDetailTableViewCell.h
//  guoshang
//
//  Created by 大菠萝 on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GoodsModel.h"
@interface GoodsDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *saleNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
-(void)loadDataFromModel:(GoodsModel*)model;


@end
