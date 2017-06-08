//
//  AlertTool.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/17.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertTool : UIAlertController
//没有取消按钮(确认后无跳转)
+(UIAlertController *)alertMesasge:(NSString *)message  confirmHandler:(void(^)(UIAlertAction * action))confirmActionHandle viewController:(UIViewController *)vc;

//没有取消按钮(确认后有跳转)
+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle  confirmHandler:(void(^)(UIAlertAction * action))confirmActionHandler viewController:(UIViewController *)vc;

//有取消按钮的
+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle  confirmHandler:(void(^)(UIAlertAction * action))confirmHandler cancleHandler:(void(^)(UIAlertAction * action))cancleHandler viewController:(UIViewController *)vc;
@end
