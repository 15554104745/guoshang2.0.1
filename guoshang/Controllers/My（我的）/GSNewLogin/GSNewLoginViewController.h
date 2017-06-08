//
//  GSNewLoginViewController.h
//  guoshang
//
//  Created by 时礼法 on 16/11/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSNewLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *LoginBackView;
@property (weak, nonatomic) IBOutlet UIImageView *LoginName;
@property (weak, nonatomic) IBOutlet UILabel *fenge1;
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UIImageView *passwordLable;
@property (weak, nonatomic) IBOutlet UILabel *fenge2;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *rememberPassWord;

@property (assign, nonatomic) BOOL changeToCar;
@end
