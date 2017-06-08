//
//  UIButton+countDown.m
//  JFHUI---01
//
//  Copyright © 2016年 com.jinfanghui.sys. All rights reserved.
//

#import "UIButton+countDown.h"

@implementation UIButton (countDown)

-(void)startWithTime:(NSInteger)countDownTime title:(NSString *)title countDownTitle:(NSString *)countDownTitle color:(UIColor *)color countCOlor:(UIColor *)countDownColor{
    //倒计时时间
    __block NSInteger timeOut = countDownTime;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(source, dispatch_walltime(NULL, 0),1.0 *NSEC_PER_SEC,0);
    
    dispatch_source_set_event_handler(source, ^{
        //倒计时结束
        if(timeOut <=0){
            dispatch_source_cancel(source);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置button的边框
//              self.layer.borderWidth = 2;
//               self.layer.borderColor = [UIColor blackColor].CGColor;
                //回倒主线程
                self.backgroundColor = color;
                
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else{
            //倒计时正在进行
            int seconds = timeOut % 60;
            
            NSString * timeStr = [NSString stringWithFormat:@"%0.1d",seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                self.backgroundColor = countDownColor;
//                self.layer.borderWidth = 2;
//                
//            self.layer.borderColor = [UIColor blackColor].CGColor;
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,countDownTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                
            });
            
            timeOut --;
        }
    });
    
    dispatch_resume(source);
}

@end
