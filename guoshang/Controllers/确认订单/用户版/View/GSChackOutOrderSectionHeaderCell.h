//
//  GSChackOutOrderSectionHeaderCell.h
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChackOutOrderShopGoodsInfoModel.h"

@interface GSChackOutOrderSectionHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopPhoneLabel;

@property (strong, nonatomic) GSChackOutOrderShopGoodsInfoModel *shopGoodsInfoModel;

@end
