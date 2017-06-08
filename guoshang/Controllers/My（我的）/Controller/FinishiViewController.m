//
//  FinishiViewController.m
//  guoshang
//
//  Created by 张涛 on 16/2/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "FinishiViewController.h"

@interface FinishiViewController ()
{
    UITextField * _pwdTF;
    UITextField * _rpwdTF;
}
@end

@implementation FinishiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isForget) {
        
       self.title = @"找回密码";
    }else{
    
    
        self.title = @"注册";
    }
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self createPwdUI];
}

-(void)createPwdUI{
    UILabel * pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, 80, 40)];
    pwdLabel.text = @"密码";
    pwdLabel.font = [UIFont systemFontOfSize:18];
    pwdLabel.textColor = [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0];
    pwdLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:pwdLabel];
    
    UILabel * rpwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 110, 80, 40)];
    rpwdLabel.text = @"重复密码";
    rpwdLabel.font = [UIFont systemFontOfSize:18];
    rpwdLabel.textAlignment = NSTextAlignmentLeft;
    rpwdLabel.textColor = [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0];
    [self.view addSubview:rpwdLabel];
    
   _pwdTF = [[UITextField alloc]init];
    _pwdTF.placeholder = @"密码由数字，字母组成";
    _pwdTF.secureTextEntry = YES;
    _pwdTF.layer.borderColor  = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0].CGColor;
    _pwdTF.layer.borderWidth = 1;
    _pwdTF.layer.cornerRadius = 10;
    [self.view addSubview:_pwdTF];
    
   _rpwdTF = [[UITextField alloc]init];
    _rpwdTF.secureTextEntry = YES;
    _rpwdTF.placeholder = @"密码由数字，字母组成";
    _rpwdTF.layer.borderWidth = 1;
    _rpwdTF.layer.borderColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0].CGColor;
    _rpwdTF.layer.cornerRadius = 10;
    [self.view addSubview:_rpwdTF];
    
    UIButton * finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0];
    
    finishButton.layer.cornerRadius = 10;
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [finishButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    
    
    [_pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pwdLabel.mas_centerY);
        make.left.mas_equalTo(pwdLabel.mas_right).with.offset(10);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(@40);
    }];
    
    
    [_rpwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rpwdLabel.mas_centerY);
        make.left.mas_equalTo(rpwdLabel.mas_right).with.offset(10);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(@40);
    }];
    
    
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rpwdLabel.mas_bottom).with.offset(50);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(@40);
    }];
    
    
    
    UIImageView * logoIcon = [[UIImageView alloc] init];
    logoIcon.image = [UIImage imageNamed:@"guoshang"];
    [self.view addSubview:logoIcon];
    [logoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(finishButton.mas_bottom).with.offset(50);
        make.left.mas_equalTo(self.view.mas_left).with.offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(@90);
        
    }];
}

-(void)click:(UIButton *)button{
    
    if ([_pwdTF.text isEqualToString: _rpwdTF.text]&&_pwdTF.text!=nil&&_rpwdTF.text!=nil) {
    
    NSString * account = [NSString stringWithFormat:@"mobile=%@,password=%@",self.accountStr,_rpwdTF.text];
    NSString * encryptString = [account encryptStringWithKey:KEY];
        NSString * postStr;
        if (self.isForget == YES) {
            postStr = @"http://www.ibg100.com/Apiss/index.php?m=Api&c=user&a=repassword";
        }else{
            postStr = @"http://www.ibg100.com/Apiss/index.php?m=Api&c=User&a=doreg";
        }
        
        [HttpTool POST:postStr parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            NSString * str = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"status"]];
       
            if ([str isEqualToString:@"0"]) {

                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else if ([str isEqualToString:@"1"]){
                if(self.isForget == YES){
                        [AlertTool alertMesasge:@"该用户不存在" confirmHandler:nil viewController:self];
                }else{
                [AlertTool alertMesasge:@"注册失败,请重新注册" confirmHandler:nil viewController:self];
                }
                
            }else if ([str isEqualToString:@"2"]){
                if(self.isForget == YES){
                    [AlertTool alertMesasge:@"手机号格式不正确" confirmHandler:nil viewController:self];
                }else{
                    [AlertTool alertMesasge:@"手机号已经注册" confirmHandler:nil viewController:self];
                }
                
            }else if ([str isEqualToString:@"3"]){
                
                if(self.isForget == YES){
                    [AlertTool alertMesasge:@"密码格式不正确" confirmHandler:nil viewController:self];
                }else{
                    [AlertTool alertMesasge:@"手机格式不正确" confirmHandler:nil viewController:self];
                }

            }else if ([str isEqualToString:@"4"]){
                if(self.isForget == YES){
          
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
