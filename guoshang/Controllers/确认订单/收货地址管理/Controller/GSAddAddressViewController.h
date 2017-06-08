//
//  GSAddAddressViewController.h
//  guoshang
//
//  Created by 金联科技 on 16/9/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChackOutOrderAddressModel.h"

@protocol GSAddAddressViewControllerDelegate <NSObject>

@optional
- (void)addAddressViewControllerDidFinishAddAddress:(GSChackOutOrderAddressModel *)addressModel;

@end

@interface GSAddAddressViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *chooseAddressButton;

@property (weak, nonatomic) id <GSAddAddressViewControllerDelegate> delegate;
//收货人
@property (weak, nonatomic) IBOutlet UITextField *consigneeField;
//手机号码
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
//详细地址填写
@property (weak, nonatomic) IBOutlet UITextField *addressField;
//switch的选择
@property (weak, nonatomic) IBOutlet UISwitch *defultSwitch;

@property (strong, nonatomic) GSChackOutOrderAddressModel *addressModel;
@property (copy, nonatomic) void (^addAddressFinishedBlock) (GSChackOutOrderAddressModel *addressModel);

@end
