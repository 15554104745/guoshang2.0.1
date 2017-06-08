//
//  GSSearchPasswordController.h
//  guoshang
//
//  Created by 时礼法 on 16/11/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSSearchPasswordController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *SearchBeijing;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *rePassword;
@property (weak, nonatomic) IBOutlet UIButton *finishiedButton;

@property(nonatomic,strong)NSString * accountStr;
@property(nonatomic,assign)BOOL isForget;

@end
