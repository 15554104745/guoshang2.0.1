//
//  SLFRechargeViewController.h
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^reloadData)(void);
typedef void(^reSetUI)(void);

@interface SLFRechargeViewController : UIViewController

@property (nonatomic, assign) NSInteger type;
@property(nonatomic,copy) reloadData block;
@property(nonatomic,copy) reSetUI ReUIblock;

@property (nonatomic, strong) UIWindow *alterWindow;
@property (nonatomic,assign) NSInteger tap;


@end
