//
//  MyOrderViewController.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayMoneyViewController.h"
#import "AllOrderViewController.h"
#import "OrderBaseViewController.h"
@interface MyOrderViewController : UIViewController<OrderBaseViewControllerDelegate>
@property (nonatomic,assign) NSInteger informNum;

@end
