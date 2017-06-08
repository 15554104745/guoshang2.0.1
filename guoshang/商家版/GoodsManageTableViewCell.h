//
//  GoodsManageTableViewCell.h
//  guoshang
//
//  Created by 孙涛 on 16/8/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsManageModel.h"

@interface GoodsManageTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^GoodsManageCellBlock)(BOOL isSaveClick);

@property (weak, nonatomic) IBOutlet UILabel *goods_addtime;
@property (weak, nonatomic) IBOutlet UIImageView *goods_image;
@property (weak, nonatomic) IBOutlet UILabel *goods_sellcount;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *goods_saveCount;
@property (weak, nonatomic) IBOutlet UILabel *goods_price;
@property (weak, nonatomic) IBOutlet UILabel *goods_oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *goods_stats; //
@property (weak, nonatomic) IBOutlet UIImageView *goods_rightImage;
@property (weak, nonatomic) IBOutlet UILabel *goods_inventory;
@property (weak, nonatomic) IBOutlet UIButton *goods_Upsell;

@property (nonatomic, strong)GoodsManageModel *model;

@property (nonatomic, strong)NSArray *dataList;

@end
