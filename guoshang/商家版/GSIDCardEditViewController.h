//
//  GSIDCardEditViewController.h
//  guoshang
//
//  Created by Rechied on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSIDCardEditViewController : UIViewController

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *idNumber;
@property (copy, nonatomic) void(^commitBlock)(NSString *name,NSString *idNumber);
@end
