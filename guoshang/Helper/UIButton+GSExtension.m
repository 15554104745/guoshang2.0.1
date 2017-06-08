//
//  UIButton+GSExtension.m
//  guoshang
//
//  Created by 金联科技 on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "UIButton+GSExtension.h"

@implementation UIButton (GSExtension)


+(UIButton *)buttonWithFrame:(CGRect)frame withImageName:(NSString*)imgName  withTitle:(NSString*)title withFontSize:(CGFloat)size addTarget:(id)target WithSelector:(SEL)selector{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    button.frame=frame;
    [button setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

@end
