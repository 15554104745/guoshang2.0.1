//
//  OrderBaseViewController.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "RequestManager.h"
#import "GSWillPayOrderTableViewCell.h"
#import "GSOrderModel.h"
#import "GSMyOrderHeaderView.h"
#import "GSOrderDetailViewController.h"

@protocol OrderBaseViewControllerDelegate <NSObject>

-(void)allPushToView:(UIViewController *)view;


@end

@interface OrderBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (copy, nonatomic) NSString *payStatus;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (weak, nonatomic) id<OrderBaseViewControllerDelegate> delegate;

@end
