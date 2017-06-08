//
//  SLFGiftView.h
//  guoshang
//
//  Created by 时礼法 on 16/8/10.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLFGiftView : UIView

@property (copy,nonatomic) void(^ReloadBlock)(void);

@property(nonatomic,strong)UIViewController * popView;
-(instancetype)initWithFrame:(CGRect)frame;

@end
