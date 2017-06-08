//
//  GSAddAddressViewController.m
//  guoshang
//
//  Created by 金联科技 on 16/9/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSAddAddressViewController.h"
#import "GSChooseContactManager.h"
#import "GSChooseAddressManager.h"
#import "NSString+MobilePhone.h"
#import "RequestManager.h"
#import "MBProgressHUD.h"


@interface GSAddAddressViewController ()<UITextFieldDelegate,GSChooseAddressManagerDelegate>

@property (copy, nonatomic) NSDictionary *addressInfo;

@end

@implementation GSAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor whiteColor];
    self.consigneeField.delegate = self;
    self.phoneNumberField.delegate = self;
    self.addressField.delegate = self;
    if (self.addressModel) {
        [self upDateAddressInfo];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)upDateAddressInfo {
    self.consigneeField.text = self.addressModel.consignee;
    self.phoneNumberField.text = (self.addressModel.tel && ![self.addressModel.tel isEqualToString:@""]) ? self.addressModel.tel : self.addressModel.mobile;
    self.addressField.text = self.addressModel.address;
    [self.chooseAddressButton setTitle:[self.addressModel getAppendAddressNoDetailAddress] forState:UIControlStateNormal];
    

    if ([self.addressModel.is_default boolValue] == 1) {
        [self.defultSwitch setOn:YES];
    } else {
        [self.defultSwitch setOn:NO];
    }
    self.defultSwitch.userInteractionEnabled = YES;
     [self.defultSwitch addTarget:self action:@selector(swichChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)swichChanged:(UISwitch *)swith
{
    UISwitch *switchButton = (UISwitch*)swith;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [self.defultSwitch setOn:NO];
    }else {
        [self.defultSwitch setOn:YES];
    }
}

- (void)textFieldTextDidChanged:(NSNotification *)notif {
    UITextField *textField = notif.object;
    
    if (textField == self.consigneeField) {
        if (textField.text.length > 7) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 7)];
        }
    }
    
    if (textField == self.phoneNumberField) {
        if (textField.text.length > 17) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 17)];
        }
    }
    
    if (textField == self.addressField) {
        if (textField.text.length > 50) {
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 50)];
        }
    }
}

//地址选择
- (IBAction)addressSelect:(UIButton *)sender {
    [self.view endEditing:YES];
    NSLog(@"地址选择");
    GSChooseAddressManager *manager = [GSChooseAddressManager manager];
    manager.delegate = self;
    [manager showAddNewAddressControl];
}
//保存并使用
- (IBAction)saveAction:(UIButton*)sender {
    [self.view endEditing:YES];
    NSLog(@"保存并使用");
    [self chackOutInfo];
}
//添加联系人
- (IBAction)addContactPersonAction:(UIButton *)sender {
    NSLog(@"添加联系人");
    [self.view endEditing:YES];
    [self showAddressManager];
}

#pragma mark - 检测用户输入信息
- (void)chackOutInfo {
    
    //是否填写姓名
    if (!self.consigneeField.text || [self.consigneeField.text isEqualToString:@""]) {
        [self alertWithMessage:@"请先填写收件人姓名!"];
        return;
    }
    
    //是否填写手机号码
    if (!self.phoneNumberField.text || [self.phoneNumberField.text isEqualToString:@""]) {
        [self alertWithMessage:@"请先填写收件人手机号码!"];
        return;
    } else {
        //是否是正确的手机号码
        if (![self.phoneNumberField.text isReallyMobileNumber]) {
            [self alertWithMessage:@"请输入正确的手机号码!"];
            return;
        }
    }
    
    //是否选择地区
    if (!self.addressInfo && !self.addressModel) {
        [self alertWithMessage:@"请先选择地区!"];
        return;
    }
    
    //判断是否填写详细地址
    if (!self.addressField.text || [self.addressField.text isEqualToString:@""]) {
        [self alertWithMessage:@"请先填写详细地址!"];
        return;
    }
    
    [self saveAndUsed];
    
}

#pragma mark - 保存并使用
- (void)saveAndUsed {
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
    NSString *URLString = nil;
    if (self.addressModel) {
        URLString = URLDependByBaseURL(@"/Api/User/editaddress");
    } else {
        URLString = URLDependByBaseURL(@"/Api/User/addaddress");
    }
    
    __weak typeof(self) weakSelf = self;
    __block NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[self getParams]];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLString parameters:[params addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUDForView:nil animated:YES];
        
        
        if (responseObject && [responseObject[@"status"] isEqualToNumber:@0]) {
            
            if ([weakSelf.delegate respondsToSelector:@selector(addAddressViewControllerDidFinishAddAddress:)]) {
                if (weakSelf.addressInfo) {
                    [params setValuesForKeysWithDictionary:weakSelf.addressInfo];
                    if (!weakSelf.addressModel && responseObject[@"result"]) {
                        [params setObject:responseObject[@"result"] forKey:@"address_id"];
                    }
                } else {
                    NSMutableDictionary *addressInfo = [weakSelf.addressModel mj_keyValues];
                    [params removeObjectsForKeys:@[@"district",@"city",@"province"]];
                    [addressInfo setValuesForKeysWithDictionary:params];
                    params = [[NSMutableDictionary alloc] initWithDictionary:addressInfo];
                }
                
                GSChackOutOrderAddressModel *addressModel = [GSChackOutOrderAddressModel mj_objectWithKeyValues:params];
                [weakSelf.delegate addAddressViewControllerDidFinishAddAddress:addressModel];
            }
        } else {
            [weakSelf alertWithMessage:@"保存地址失败,请稍后再试"];
        }
        
    }];
}

#pragma mark - 获取参数
- (NSDictionary *)getParams {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:UserId forKey:@"user_id"];
    [params setObject:@"1" forKey:@"country"];
    
    NSArray *keyArray = @[@"province",@"city",@"district"];
    if (_addressInfo) {
        [keyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [params setObject:_addressInfo[[NSString stringWithFormat:@"%@_id",obj]] forKey:obj];
        }];
    } else {
        [keyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [params setObject:[self.addressModel valueForKey:[NSString stringWithFormat:@"%@_id",obj]] forKey:obj];
        }];
    }
    
    if (self.addressModel) {
        [params setObject:self.addressModel.address_id forKey:@"address_id"];
    }
    [params setObject:[NSString stringWithFormat:@"%d",self.defultSwitch.isOn] forKey:@"is_default"];
    [params setObject:self.consigneeField.text forKey:@"consignee"];
    
    [params setObject:self.addressField.text forKey:@"address"];
    [params setObject:self.phoneNumberField.text forKey:@"mobile"];
    [params setObject:self.phoneNumberField.text forKey:@"tel"];
    
    return [[NSDictionary alloc] initWithDictionary:params];
    
}


- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - GSChooseAddressManagerDelegate

- (void)chooseAddressManager:(GSChooseAddressManager *)manager didFinishSelectAddressInfo:(NSDictionary *)addressInfo {
    
    self.addressInfo = [[NSDictionary alloc] initWithDictionary:addressInfo];
    GSChackOutOrderAddressModel *addressModel = [GSChackOutOrderAddressModel mj_objectWithKeyValues:addressInfo];
    [self.chooseAddressButton setTitle:[addressModel getAppendAddressNoDetailAddress] forState:UIControlStateNormal];
}




- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSLog(@"--------------------return");
    if (textField == self.consigneeField) {
        [self.phoneNumberField becomeFirstResponder];
    }
    
    if (textField == self.phoneNumberField) {
        [self addressSelect:nil];
    }
    
    if (textField == self.addressField) {
        [self chackOutInfo];
    }
    
    return YES;
}
@end
