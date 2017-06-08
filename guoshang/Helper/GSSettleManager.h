//
//  GSSettleManagre.h
//  guoshang
//
//  Created by Rechied on 16/9/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSSettleManager : NSObject
+ (void)settleGuoBiOrderWithParams:(NSDictionary *)params viewController:(UIViewController *)viewController;
+ (void)settleDefaultOrderWithParams:(NSDictionary *)params viewController:(UIViewController *)viewController;
+ (void)settleBusinessOrderWithParams:(NSDictionary *)params viewController:(UIViewController *)viewController;
@end
