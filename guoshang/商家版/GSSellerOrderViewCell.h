//
//  GSSellerOrderViewCell.h
//  guoshang
//
//  Created by 金联科技 on 16/8/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSSellerOrderHeader.h"
#import "GSCustomOrderModel.h"
#import "GSMyOrderModel.h"
@interface GSSellerOrderViewCell : UITableViewCell
//客户订单的MOdel
@property (nonatomic,strong) GSCustomGoodsModel *customGoodsModel;
//我的订单的model
@property (nonatomic,strong) GSMyGoodModel *myGoodsModel;
//买家信息
@property(nonatomic,strong) NSDictionary *customOrderInfo;

+(instancetype)orederCellWithTableView:(UITableView*)tableView withOrderType:(GSOrderInfoType)type;
@end
