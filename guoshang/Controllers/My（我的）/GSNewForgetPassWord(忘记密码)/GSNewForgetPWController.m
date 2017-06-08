//
//  GSNewForgetPWController.m
//  guoshang
//
//  Created by 时礼法 on 16/11/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNewForgetPWController.h"
#import "UIButton+countDown.h"
#import "FinishiViewController.h"
#import "GSSearchPasswordController.h"

@interface GSNewForgetPWController ()<UITextFieldDelegate>

@property(nonatomic)NSDictionary * dic;
@property(nonatomic,copy)NSString * checkStr;

@end

@implementation GSNewForgetPWController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)setupUI
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置透视图
    self.fatherView.layer.cornerRadius = 15;
    self.fatherView.clipsToBounds = YES;
    self.fatherView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];
    
    //设置下一步按钮
    self.NextButton.layer.cornerRadius = 8;
    self.NextButton.clipsToBounds = YES;
    self.NextButton.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];
    
    //获取验证码按钮
    self.yanzhengButton.layer.cornerRadius = 8;
    self.yanzhengButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.yanzhengButton.layer.borderWidth = 0.5f;
    self.yanzhengButton.clipsToBounds = YES;
    self.yanzhengButton.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];
    
    self.phoneTextF.delegate = self;
    self.yanzhengCode.delegate = self;

    
}



- (IBAction)yanzhengClicked:(id)sender {
         int count = 0;
    
    UIButton *button = sender;
    
    NSString * str = [NSString stringWithString:self.phoneTextF.text];
    for (int i = 0; i < self.phoneTextF.text.length; i++) {
        char  chr = [str characterAtIndex:i];
        
        if (chr>= '0' && chr <= '9') {
            count++;
        }
    }
    
    
    if (self.phoneTextF.text.length == 11 &&self.phoneTextF.text!=nil && count == 11) {
        //发送验证码
        [button startWithTime:60 title:@"获取验证码" countDownTitle:@"秒后重新发送" color:nil countCOlor:nil];
        NSString  *encryptString;
        NSString * account = [NSString stringWithFormat:@"mobile=%@",self.phoneTextF.text];
        encryptString = [account encryptStringWithKey:KEY];
        
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=resendcode") parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            weakSelf.dic = [NSDictionary dictionaryWithDictionary:responseObject];
            
            [weakSelf toPost];
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }else{
        
        [AlertTool alertMesasge:@"手机格式不正确" confirmHandler:nil viewController:self];
        
    }

}

-(void)toPost{
    //    NSLog(@"%@",self.dic);
    NSString * str = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"status"]];
    
    if ([str isEqualToString:@"0"]) {
        self.checkStr = [NSString stringWithFormat:@"%@",[self.dic objectForKey:@"result"]];
        
    }else if ([str isEqualToString:@"2"]){
        
        [AlertTool alertMesasge:@"手机号已经注册" confirmHandler:nil viewController:self];
        
    }else if ([str isEqualToString:@"3"]){
        
        [AlertTool alertMesasge:@"短信发送失败" confirmHandler:nil viewController:self];
        
    }
    
}

- (IBAction)NextButton:(id)sender {
    
    if ([self.yanzhengCode.text isEqualToString:self.checkStr]) {
        GSSearchPasswordController * fvc = [[GSSearchPasswordController alloc]init];
        
        fvc.accountStr =self.phoneTextF.text;
        fvc.isForget = YES;
        [self.navigationController pushViewController:fvc animated:YES];
    }else{
        [AlertTool alertMesasge:@"验证码错误，请重新输入" confirmHandler:nil viewController:self];
        
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
    // Dispose of any resources that can be recreated.
}



@end
