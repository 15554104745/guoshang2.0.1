//
//  MerchandiseShopInfoTableViewCell.h
//  Demo
//
//  Created by suntao on 16/8/4.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailShopInfoModel.h"

extern NSString *const kMerchandiseShopBasicInfoTableViewCellIdentifier;

typedef void(^MerchandiseShopBasicInfoBlock)(NSInteger index);

@interface MerchandiseShopBasicInfoTableViewCell : UITableViewCell

@property (copy, nonatomic) MerchandiseShopBasicInfoBlock block;

@property (weak, nonatomic) IBOutlet UILabel *shop_name;

@property (weak, nonatomic) IBOutlet UIImageView *shop_image;

@property (weak, nonatomic) IBOutlet UILabel *shop_allgoods;

@property (weak, nonatomic) IBOutlet UILabel *shop_newGoods;

@property (weak, nonatomic) IBOutlet UILabel *shop_collect;


@property (nonatomic, strong)GoodsDetailShopInfoModel *model;


@property (weak, nonatomic) IBOutlet UIButton *concernBtn;


@end
