//
//  MyCollectTableViewCell.h
//  guoshang
//
//  Created by 张涛 on 16/3/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCollectTableViewCellDataSource;
@protocol MyCollectTableViewCellDelegate;

@interface MyCollectTableViewCell : UITableViewCell




@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *GBLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *saledLabel;

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *icon;


//- (void)customCell;
//
//- (void)buildMenuView;

@end

