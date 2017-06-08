//
//  GSSearchPasswordController.m
//  guoshang
//
//  Created by 时礼法 on 16/11/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSSearchPasswordController.h"

@interface GSSearchPasswordController ()<UITextFieldDelegate>

@end

@implementation GSSearchPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreatUI];
}

-(void)CreatUI
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置透视图
    self.SearchBeijing.layer.cornerRadius = 15;
    self.SearchBeijing.clipsToBounds = YES;
    self.SearchBeijing.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];
    
    //设置下一步按钮
    self.finishiedButton.layer.cornerRadius = 8;
    self.finishiedButton.clipsToBounds = YES;
    self.finishiedButton.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];
    
    
    self.password.delegate = self;
    self.password.secureTextEntry = YES;
    self.rePassword.delegate = self;
    self.rePassword.secureTextEntry = YES;
    
}


- (IBAction)finished:(id)sender {
    
    if ([self.password.text isEqualToString: _rePassword.text]&&_password.text!=nil&&_rePassword.text!=nil) {
        
        NSString * account = [NSString stringWithFormat:@"source=iOS,mobile=%@,password=%@",self.accountStr,_rePassword.text];
        NSString * encryptString = [account encryptStringWithKey:KEY];
        NSString * postStr;
        if (self.isForget == YES) {
            postStr = URLDependByBaseURL(@"?m=Api&c=user&a=repassword");
        }else{
            postStr = URLDependByBaseURL(@"?m=Api&c=User&a=doreg");
        }
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:postStr parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            NSString * str = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"status"]];
            
            if ([str isEqualToString:@"0"]) {
                
                
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                
            }else if ([str isEqualToString:@"1"]){
                if(weakSelf.isForget == YES){
                    [AlertTool alertMesasge:@"该用户不存在" confirmHandler:nil viewController:weakSelf];
                }else{
                    [AlertTool alertMesasge:@"注册失败,请重新注册" confirmHandler:nil viewController:weakSelf];
                }
                
            }else if ([str isEqualToString:@"2"]){
                if(weakSelf.isForget == YES){
                    [AlertTool alertMesasge:@"手机号格式不正确" confirmHandler:nil viewController:weakSelf];
                }else{
                    [AlertTool alertMesasge:@"手机号已经注册" confirmHandler:nil viewController:weakSelf];
                }
                
            }else if ([str isEqualToString:@"3"]){
                
                if(self.isForget == YES){
                    [AlertTool alertMesasge:@"密码格式不正确" confirmHandler:nil viewController:weakSelf];
                }else{
                    [AlertTool alertMesasge:@"手机格式不正确" confirmHandler:nil viewController:weakSelf];
                }
                
            }else if ([str isEqualToString:@"4"]){
                if(weakSelf.isForget == YES){
                    
                }else{
                    
                    [AlertTool alertMesasge:@"手机密码格式不正确" confirmHandler:nil viewController:self];
                }
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }else{
        
        [AlertTool alertMesasge:@"两次密码不相同，请重新输入" confirmHandler:nil viewController:self];
        
    }

}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
