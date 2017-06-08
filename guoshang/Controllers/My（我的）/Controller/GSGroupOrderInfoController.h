//
//  GSGroupOrderInfoController.h
//  guoshang
//
//  Created by 金联科技 on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSSellerOrderHeader.h"
@interface GSGroupOrderInfoController : UIViewController
//订单号
@property (nonatomic,copy) NSString *order_ID; //订单id
@property (nonatomic,assign) GSOrderInfoType oderType;

@end
