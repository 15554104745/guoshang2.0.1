//
//  changePasswordViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "changePasswordViewController.h"

@interface changePasswordViewController ()
{
    UITextField * _oldPassWord;
    UITextField * _newPassWord;
    UITextField * _recurNewPassWord;
}
@end

@implementation changePasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = MyColor;
    self.title = @"修改密码";
    [self createUI];
   

}

-(void)createUI{
    
    
    _oldPassWord = [[UITextField alloc] init];
    [self.view addSubview:_oldPassWord];
    _oldPassWord.tag = 1002;
    _oldPassWord.secureTextEntry = YES;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 62, 35)];
    label.text = @"原密码";
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = WordColor;
    _oldPassWord.leftView = label;
    _oldPassWord.delegate = self;
     _oldPassWord.placeholder = @"密码由字母，数字组成";
    _oldPassWord.leftViewMode = UITextFieldViewModeAlways;
    _oldPassWord.textAlignment = NSTextAlignmentLeft;
    [_oldPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right).equalTo(@-10);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@60);
    }];
    
    UIView * wire1 = [[UIView alloc] init];
    wire1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:wire1];
    [wire1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_oldPassWord.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    
    //新密码
    _newPassWord = [[UITextField alloc] init];
    [self.view addSubview:_newPassWord];
    _newPassWord.delegate = self;
    _newPassWord.tag = 1003;
     _newPassWord.placeholder = @"密码由字母，数字组成";
    _newPassWord.secureTextEntry = YES;
    UILabel * stokeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 62, 35)];
    stokeLabel.text = @"新密码";
    stokeLabel.textAlignment = NSTextAlignmentRight;
    stokeLabel.textColor = WordColor;
    _newPassWord.leftView = stokeLabel;
    _newPassWord.leftViewMode = UITextFieldViewModeAlways;
    [_newPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right).equalTo(@-10);
        make.top.equalTo(wire1.mas_bottom);
        make.height.equalTo(@60);
        
    }];
    UIView * wire2 = [[UIView alloc] init];
    wire2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:wire2];
    [wire2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_newPassWord.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    
    //重复新密码
    _recurNewPassWord = [[UITextField alloc] init];
    [self.view addSubview:_recurNewPassWord];
    _recurNewPassWord.placeholder = @"密码由字母，数字组成";
    _recurNewPassWord.delegate = self;
    _recurNewPassWord.tag = 1004;
    _recurNewPassWord.secureTextEntry = YES;
    UILabel * recurStokeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 92, 35)];
    recurStokeLabel.text = @"重复新密码";
    recurStokeLabel.textAlignment = NSTextAlignmentRight;
    recurStokeLabel.textColor = WordColor;
    _recurNewPassWord.leftView = recurStokeLabel;
    _recurNewPassWord.leftViewMode = UITextFieldViewModeAlways;
    [_recurNewPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right).equalTo(@-10);
        make.top.equalTo(wire2.mas_bottom);
        make.height.equalTo(@60);
        
    }];
    UIView * wire3 = [[UIView alloc] init];
    wire3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:wire3];
    [wire3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_recurNewPassWord.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    UIButton * realBtn = [[UIButton alloc] init];
    realBtn.backgroundColor = [UIColor redColor];
    [realBtn setTitle:@"确定" forState:UIControlStateNormal];
    [realBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [realBtn addTarget:self action:@selector(butonClick:) forControlEvents:UIControlEventTouchUpInside];
    realBtn.tag = 16;
    [self.view addSubview:realBtn];
    [realBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).equalTo(@30);
        make.right.equalTo(self.view.mas_right).equalTo(@-30);
        make.top.equalTo(wire3.mas_bottom).equalTo(@30);
        make.height.equalTo(@40);
        
    }];
    
}
-(void)butonClick:(UIButton *)button{
    
    int count = 0,wordCount = 0;
       NSString * str = [NSString stringWithString:_newPassWord.text];
    for (int i = 0; i < _newPassWord.text.length; i++) {
        char chr = [str characterAtIndex:i];
        if (chr>= '0' && chr <= '9') {
            count++;
        }else if((chr >='a' && chr<='z') ||  (chr >='A' && chr<='Z')){
            wordCount++;
        }
        
    }

//    int  allCount = count + wordCount;
    NSString * statueStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]];
    if ([_newPassWord.text isEqualToString:_recurNewPassWord.text]) {
        if(_newPassWord.text.length<5||_newPassWord.text.length>20)
        {
 [AlertTool alertMesasge:@"密码长度错误！" confirmHandler:nil viewController:self];
            return;
        }
        if (_oldPassWord.text!=nil && count!=0 && wordCount!=0) {
            NSString * account = [NSString stringWithFormat:@"user_id=%@,old_password=%@,new_password=%@",statueStr,_oldPassWord.text,_newPassWord.text];
            NSString * encryptString = [account encryptStringWithKey:KEY];
            __weak typeof(self) weakSelf = self;
            [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=changepassword") parameters:@{@"token":encryptString} success:^(id responseObject) {
                
                NSString * str = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"status"]];
                if ([str isEqualToString:@"0"]) {
                    [AlertTool alertTitle:@"修改成功" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                        
                       [weakSelf.navigationController popToRootViewControllerAnimated:YES];

                        
                    } viewController:self];

                }else if ([str isEqualToString:@"1"]){
                    
                    [AlertTool alertMesasge:@"该用户不存在" confirmHandler:nil viewController:weakSelf];
                    
                }else if ([str isEqualToString:@"2"]){
                    [AlertTool alertMesasge:@"旧密码错误" confirmHandler:nil viewController:weakSelf];
                    
                }
                
                
                
            } failure:^(NSError *error) {
                
            }];
            
        }else{
            
            [AlertTool alertMesasge:@"输入错误，请重新输入" confirmHandler:nil viewController:self];
            
        }
        
        

    }else{
        [AlertTool alertMesasge:@"两次输入密码不相同" confirmHandler:nil viewController:self];

    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //由tag值找到两个不同的textField
    UITextField *textField1 = (UITextField *)[self.view viewWithTag:1002];
    UITextField *textField2 = (UITextField *)[self.view viewWithTag:1003];
      UITextField *textField3 = (UITextField *)[self.view viewWithTag:1004];
    //当光标在第一个里面时
    if (textField.tag == 1002) {
        //第一个失去响应
        [textField1 resignFirstResponder];
        //第二个开始响应
        [textField2 becomeFirstResponder];
    }else if (textField.tag == 1003){
        //第二个失去响应
        [textField2 resignFirstResponder];
        [textField3 becomeFirstResponder];
    }else if (textField.tag == 1004){
        [textField3 resignFirstResponder];
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
