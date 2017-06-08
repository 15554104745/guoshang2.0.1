//
//  GSNewRegistViewController.m
//  guoshang
//
//  Created by 时礼法 on 16/11/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNewRegistViewController.h"
#import "UIButton+countDown.h"
#import "FinishiViewController.h"


@interface GSNewRegistViewController ()<UITextFieldDelegate>

@end

@implementation GSNewRegistViewController
{
    BOOL _bkeyboardHide;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置透视图
    self.RegistBackView.layer.cornerRadius = 15;
    self.RegistBackView.clipsToBounds = YES;
    self.RegistBackView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];

    //设置登录按钮
    self.Registfinishi.layer.cornerRadius = 8;
    self.Registfinishi.clipsToBounds = YES;
    self.Registfinishi.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];
    
    //获取验证码按钮
    self.getverification.layer.cornerRadius = 8;
    self.getverification.layer.borderColor = [UIColor whiteColor].CGColor;
    self.getverification.layer.borderWidth = 0.5f;
    self.Registfinishi.clipsToBounds = YES;
    self.Registfinishi.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];
    
    self.phoneTextF.delegate = self;
    self.passwordTextF.delegate = self;
    self.passwordTextF.secureTextEntry = YES;
    self.verificationF.delegate = self;
    self.invitCode.delegate = self;
}

- (IBAction)getVerification:(id)sender {
    
    {
        
        if ([self valiMobile:self.phoneTextF.text]== NO) {
            [AlertTool alertMesasge:@"手机格式不正确" confirmHandler:nil viewController:self];
            return;
        }
        
        int count = 0;
        
        NSString * str = [NSString stringWithString:self.phoneTextF.text];
        for (int i = 0; i < self.phoneTextF.text.length; i++) {
            char  chr = [str characterAtIndex:i];
            
            if (chr>= '0' && chr <= '9') {
                count++;
            }
        }
        
        
        if (self.phoneTextF.text.length == 11 &&self.phoneTextF.text!=nil && count == 11) {
           
            NSString  *encryptString;
            NSString * account = [NSString stringWithFormat:@"mobile=%@",self.phoneTextF.text];
            encryptString = [account encryptStringWithKey:KEY];
            
            __weak typeof(self) weakSelf = self;
            [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=sendcode") parameters:@{@"token":encryptString} success:^(id responseObject) {
                
                weakSelf.Registdic = [NSDictionary dictionaryWithDictionary:responseObject];
                
                [weakSelf toPost:sender];
                
                
            } failure:^(NSError *error) {
                
            }];
            
            
        }else{
            
            [AlertTool alertMesasge:@"手机格式不正确" confirmHandler:nil viewController:self];
            
        }
        
        
    }
}


- (IBAction)Finished:(id)sender {
    
    if (self.phoneTextF.text.length == 0 || self.passwordTextF.text.length == 0 || self.verificationF.text.length == 0) {
        [AlertTool alertMesasge:@"输入不完全，请输入" confirmHandler:nil viewController:self];
        return;
    }
    
    if ([self.verificationF.text isEqualToString:self.RegistcheckStr] == NO) {
        [AlertTool alertMesasge:@"验证码错误，请重新输入" confirmHandler:nil viewController:self];
        return;
    }
    if ([self.verificationF.text isEqualToString:self.RegistcheckStr]) {
        NSString * account = [NSString stringWithFormat:@"source=iOS,mobile=%@,password=%@,recommend_code=%@",self.phoneTextF.text,self.passwordTextF.text,self.invitCode.text];
        NSString * encryptString = [account encryptStringWithKey:KEY];
          NSString * postStr = URLDependByBaseURL(@"?m=Api&c=User&a=doreg");
        
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:postStr parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            NSString * str = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"status"]];
            
            if ([str isEqualToString:@"0"]) {
                
                
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                
            }else if ([str isEqualToString:@"1"]){
                
                    [AlertTool alertMesasge:@"注册失败,请重新注册" confirmHandler:nil viewController:weakSelf];
                
            }else if ([str isEqualToString:@"2"]){
                
                    [AlertTool alertMesasge:@"手机号已经注册" confirmHandler:nil viewController:weakSelf];
                
            }else if ([str isEqualToString:@"3"]){
              
                    [AlertTool alertMesasge:@"手机格式不正确" confirmHandler:nil viewController:weakSelf];
                
            }else if ([str isEqualToString:@"4"]){
                
                    [AlertTool alertMesasge:@"手机或密码格式不正确" confirmHandler:nil viewController:self];
                
            }
            
            
            
        } failure:^(NSError *error) {
            
        }];
    }
}


- (IBAction)toback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

-(void)toPost:(UIButton *)button{
    //    NSLog(@"%@",self.dic);
    NSString * str = [NSString stringWithFormat:@"%@", [self.Registdic objectForKey:@"status"]];
    
    if ([str isEqualToString:@"0"]) {
        [button startWithTime:60 title:@"获取验证码" countDownTitle:@"秒后重新发送" color:nil countCOlor:nil];
        self.RegistcheckStr = [NSString stringWithFormat:@"%@",[self.Registdic objectForKey:@"result"]];
        
    }else if ([str isEqualToString:@"2"]){
        //发送验证码
        
        [AlertTool alertMesasge:@"手机号已经注册" confirmHandler:nil viewController:self];
        
    }else if ([str isEqualToString:@"3"]){
        
        [AlertTool alertMesasge:@"短信发送失败" confirmHandler:nil viewController:self];
        
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}



@end
