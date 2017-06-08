//
//  RegisterViewController.m
//  guoshang
//
//  Created by 张涛 on 16/2/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "RegisterViewController.h"
#import "FinishiViewController.h"
#import "UIButton+countDown.h"


@interface RegisterViewController ()


@end

@implementation RegisterViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self createRegUI];
}

-(void)createRegUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 45, 60, 40)];
    numLabel.text = @"手机号";
    numLabel.textColor = [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0];
    numLabel.font = [UIFont systemFontOfSize:18];
    numLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:numLabel];
    
    UILabel * CKLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 105, 60, 40)];
    CKLabel.text = @"验证码";
    CKLabel.font = [UIFont systemFontOfSize:18];
    CKLabel.textColor = [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0];
    CKLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:CKLabel];
    
    _numTF = [[UITextField alloc]init];
    _numTF.layer.cornerRadius = 10;
    _numTF.layer.borderWidth = 1;
    _numTF.delegate = self;
    _numTF.tag = 1300;
    _numTF.layer.borderColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0].CGColor;    //
    [self.view addSubview:_numTF];
    
    _checkTF = [[UITextField alloc]init];
    _checkTF.layer.cornerRadius = 10;
    _checkTF.layer.borderWidth = 1;
    _checkTF.tag = 3001;
    _checkTF.delegate = self;
    _checkTF.layer.borderColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0].CGColor;
    [self.view addSubview:_checkTF];
    
    UIButton * getCheckNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getCheckNumBtn.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0];
    getCheckNumBtn.tag = 20;
    getCheckNumBtn.layer.cornerRadius = 5;
    [getCheckNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getCheckNumBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [getCheckNumBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCheckNumBtn];
    
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0];
    nextButton.tag = 21;
    nextButton.layer.cornerRadius = 10;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [nextButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    [_numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(numLabel.mas_centerY);
        make.left.mas_equalTo(numLabel.mas_right).with.offset(10);
        make.height.mas_equalTo(@40);
        make.right.mas_equalTo(self.view.mas_right).offset(-25);
    }];
    
    [getCheckNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(CKLabel.mas_centerY);
        make.right.mas_equalTo(self.view.mas_right).offset(-25);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(80);
        
    }];
    
    
    [_checkTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(CKLabel.mas_centerY);
        make.left.mas_equalTo(CKLabel.mas_right).with.offset(10);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(110.5);
      
    }];
    
   
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CKLabel.mas_bottom).with.offset(50);
        make.left.mas_equalTo(self.view.mas_left).with.offset(25);
        make.right.mas_equalTo(_numTF.mas_right);
        make.height.mas_equalTo(@40);
    }];
    
    
    UIImageView * logoIcon = [[UIImageView alloc] init];
    logoIcon.image = [UIImage imageNamed:@"guoshang"];
    [self.view addSubview:logoIcon];
    [logoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nextButton.mas_bottom).with.offset(50);
        make.left.mas_equalTo(self.view.mas_left).with.offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(@90);
        
    }];
}

-(void)click:(UIButton *)button{
    if (button.tag == 20) {
        
        int count = 0;

        NSString * str = [NSString stringWithString:_numTF.text];
        for (int i = 0; i < _numTF.text.length; i++) {
            char  chr = [str characterAtIndex:i];
            
            if (chr>= '0' && chr <= '9') {
                count++;
            }
        }
        NSLog(@"***%d",count);
        
        if (_numTF.text.length == 11 &&_numTF.text!=nil && count == 11) {
            //发送验证码
            [button startWithTime:60 title:@"获取验证码" countDownTitle:@"秒后重新发送" color:NewRedColor countCOlor:NewRedColor];
            NSLog(@"发送验证码");
            NSString  *encryptString;
            NSString * account = [NSString stringWithFormat:@"mobile=%@",_numTF.text];
            encryptString = [account encryptStringWithKey:KEY];
            NSLog(@"%@",encryptString);
            
            [HttpTool POST:@"http://www.ibg100.com/Apiss/index.php?m=Api&c=User&a=sendcode" parameters:@{@"token":encryptString} success:^(id responseObject) {
                _dic = [NSDictionary dictionaryWithDictionary:responseObject];

                    [self toPost];
                
            } failure:^(NSError *error) {
                
                NSLog(@"%@",error);
            }];
         

        }else{

            [AlertTool alertMesasge:@"手机格式不正确" confirmHandler:nil viewController:self];
        }
        
        
    }else{
        NSLog(@"next...");
        if ([_checkTF.text isEqualToString:_checkStr]) {
            FinishiViewController * fvc = [[FinishiViewController alloc]init];
            fvc.accountStr = _numTF.text;
            fvc.isForget = NO;
            NSLog(@"登录账户是：%@",fvc.accountStr);
            [self.navigationController pushViewController:fvc animated:YES];
        }else{
            
    [AlertTool alertMesasge:@"验证码错误，请重新输入" confirmHandler:nil viewController:self];
        }
      
    }

    

}

-(void)toPost{
    NSString * str = [NSString stringWithFormat:@"%@", [_dic objectForKey:@"status"]];
    NSLog(@"%@",str);
    
            if ([str isEqualToString:@"0"]) {
                NSLog(@"成功");
                _checkStr = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"result"]];
    
            }else if ([str isEqualToString:@"2"]){
        
                [AlertTool alertMesasge:@"手机号已经注册" confirmHandler:nil viewController:self];
    
            }else if ([str isEqualToString:@"3"]){
    
                  [AlertTool alertMesasge:@"短信发送失败,请重新发送" confirmHandler:nil viewController:self];
            }
    
 
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UITextField *textField1 = (UITextField *)[self.view viewWithTag:3000];
    UITextField *textField2 = (UITextField *)[self.view viewWithTag:3001];
    if (textField.tag == 3000) {
        //第一个失去响应
        [textField1 resignFirstResponder];
        //第二个开始响应
        [textField2 becomeFirstResponder];
    }else if (textField.tag == 3001){
        //第二个失去响应
        [textField2 resignFirstResponder];
    }
    
    return YES;
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
