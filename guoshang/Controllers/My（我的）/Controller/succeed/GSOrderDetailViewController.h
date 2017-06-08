//
//  GSOrderDetailViewController.h
//  guoshang
//
//  Created by Rechied on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSOrderDetailModel.h"

typedef NS_ENUM(NSInteger, GSOrderType) {
//    我的订单
    GSOrderTypeDefaultOrder = 0,
//    团购订单
    GSOrderTypeGroupOrder,
//    进货订单
    GSOrderTypePurchaseOrder,
};

@interface GSOrderDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GSOrderDetailModel *detailModel;
@property (copy, nonatomic) NSString *order_id;
@property (copy, nonatomic) NSMutableArray *goodsArray;
@property (assign, nonatomic) GSOrderType orderType;
@end
