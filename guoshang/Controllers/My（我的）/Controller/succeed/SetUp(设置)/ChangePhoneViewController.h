//
//  ChangePhoneViewController.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PhoneBlock)(NSString * string);
@interface ChangePhoneViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,copy)PhoneBlock  phoneString;

@end
