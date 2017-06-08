//
//  GSOrderBaseViewController.h
//  guoshang
//
//  Created by 金联科技 on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSCustomOrderModel.h"
#import "GSMyOrderModel.h"
#import "GSSellerOrderHeader.h"
@interface GSOrderBaseViewController : UIViewController

@property (nonatomic,assign) GSOrderInfoType orderType; //判断订单类型 
//父类的属性 子类会继承
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *myTableView;

@property(nonatomic,assign)int  page;
- (void)loadData;
@end
