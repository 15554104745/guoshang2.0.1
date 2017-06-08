//
//  GSRefundViewController.h
//  guoshang
//
//  Created by JinLian on 16/9/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, GSEnteCurrentViewOfType) {
    //   商家版
    GSEnteCurrentViewOfDefaultSeller = 0,
//买家版
    GSEnteCurrentViewOfBuyers,
   
};
@interface GSRefundViewController : UIViewController

@property (nonatomic,copy) NSString *order_sn;
@property (nonatomic,assign) GSEnteCurrentViewOfType enterType;

@end
