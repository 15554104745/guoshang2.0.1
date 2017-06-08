//
//  GSNewRegistViewController.h
//  guoshang
//
//  Created by 时礼法 on 16/11/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSNewRegistViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *registBack;
@property (weak, nonatomic) IBOutlet UILabel *registPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *registpassword;
@property (weak, nonatomic) IBOutlet UILabel *verificationcode;
@property (weak, nonatomic) IBOutlet UIButton *getverification;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UITextField *verificationF;
@property (weak, nonatomic) IBOutlet UIView *RegistBackView;
@property (weak, nonatomic) IBOutlet UIButton *Registfinishi;

@property (weak, nonatomic) IBOutlet UITextField *invitCode;


@property(nonatomic)NSDictionary * Registdic;
@property(nonatomic,copy)NSString * RegistcheckStr;




@end
