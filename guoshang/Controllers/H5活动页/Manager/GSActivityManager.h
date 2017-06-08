//
//  GSActivityManager.h
//  guoshang
//
//  Created by Rechied on 2016/11/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSActivityManager : NSObject
+ (void)pushToActivityWithActiviryURL:(NSString *)url navigationController:(UINavigationController *)navigationController;

+ (void)changeToGoodsDetialWithGoods_id:(NSString *)goods_id navigationController:(UINavigationController *)navigationController hudView:(UIView *)hudView;
@end
