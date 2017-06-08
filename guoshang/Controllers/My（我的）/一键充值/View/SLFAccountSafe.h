//
//  SLFAccountSafe.h
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^reSetUI)(void);
@interface SLFAccountSafe : UIView

@property(nonatomic,copy) reSetUI ReUIblock;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) UIViewController *VC;

@end
