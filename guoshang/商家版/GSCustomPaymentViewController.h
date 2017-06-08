//
//  GSCustomPaymentViewController.h
//  guoshang
//
//  Created by 金联科技 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSOrderBaseViewController.h"
@protocol PayMoneyDelegate <NSObject>

-(void)pushTo:(UIViewController *)view;

@end

@interface GSCustomPaymentViewController : GSOrderBaseViewController
@property(nonatomic,weak)id<PayMoneyDelegate>delegate;

@end
