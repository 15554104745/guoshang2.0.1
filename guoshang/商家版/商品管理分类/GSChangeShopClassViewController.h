//
//  GSChangeShopClassViewController.h
//  guoshang
//
//  Created by chenlei on 16/10/10.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSChangeShopClassViewController : UIViewController

@property (nonatomic, copy) void (^GSChangeShopClassViewControllerBlock)(NSString *changeSC);
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *category_title;

@end
