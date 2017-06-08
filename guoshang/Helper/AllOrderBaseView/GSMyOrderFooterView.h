//
//  GSMyOrderFooterView.h
//  guoshang
//
//  Created by 金联科技 on 16/8/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSOrderModel.h"

typedef void (^reloadTableView)();
@interface GSMyOrderFooterView : UIView

@property (nonatomic,strong)GSOrderModel *orderModel;

@property (nonatomic, copy) reloadTableView loadData;
@end
