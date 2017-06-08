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
@interface MyOrderViewController : UIViewController<PayMoneyDelegate,AllPayMoneyDelegate>

@property(nonatomic,assign)NSInteger informNum;
@end
