//
//  UIButton+countDown.h
//  JFHUI---01
//
//  Copyright © 2016年 com.jinfanghui.sys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (countDown)
/**
 倒计时按钮
 countDownTime 倒计时时间
 title 倒计时开始前的标题
 countDownTitle 倒计时中的标题
 color 倒计时开始前的颜色
 countDownColor 倒计时中的颜色
 */


-(void)startWithTime:(NSInteger)countDownTime title:(NSString *)title countDownTitle:(NSString *)countDownTitle color:(UIColor *)color countCOlor:(UIColor *)countDownColor;


@end
