//
//  SLFBindingCard.h
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SLFBindingCard : UIView

@property (copy,nonatomic) void(^ReloadBlock)(void);
@property (nonatomic,strong) UIViewController *VC;

@end
