//
//  LNcheckVersion.h
//  guoshang
//
//  Created by 宗丽娜 on 16/4/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LNVersionShowView.h"


typedef void(^ToShowAlertNewVersion)();
typedef void(^UpdateBlock)(NSString * str,NSArray *DataArr);

@interface LNcheckVersion : NSObject


-(void)showAlertView;

@property(nonatomic,copy)UpdateBlock updateBlock;
@property(nonatomic,copy)ToShowAlertNewVersion toshowAlertNewVersion;
@property(nonatomic)BOOL isStart;

@end
