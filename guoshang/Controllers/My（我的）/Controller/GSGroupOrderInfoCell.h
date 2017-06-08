//
//  GSGroupOrderInfoCell.h
//  guoshang
//
//  Created by 金联科技 on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSCustomGoodsInfoModel;
#import "GSMyOrderInfoModel.h"
@interface GSGroupOrderInfoCell : UITableViewCell

@property (nonatomic,strong) GSCustomGoodsInfoModel *model;
@property (nonatomic,strong) GSMyOrderGoodsInfoModel *myGoodsModel;
@end
