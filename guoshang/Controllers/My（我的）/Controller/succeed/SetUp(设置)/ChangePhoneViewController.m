//
//  ChangePhoneViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "UIButton+countDown.h"
@interface ChangePhoneViewController ()

@property(nonatomic,copy)NSString * phoneStr;
@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改手机号";
    [self createUI];
}
-(void)createUI{
    //手机号
    UITextField * phone = [[UITextField alloc] init];
    [self.view addSubview:phone];
    phone.tag = 80;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    label.text = @"手机号";
    label.textColor = [UIColor blackColor];
    phone.leftView = label;
    phone.delegate = self;
    phone.leftViewMode = UITextFieldViewModeAlways;
    phone.textAlignment = NSTextAlignmentRight;
    __weak typeof(self)weakSelf = self;
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right).equalTo(@-10);
        make.top.equalTo(weakSelf.view.mas_top);
        make.height.equalTo(@60);

    }];
    
    
    UIView * wire1 = [[UIView alloc] init];
    wire1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:wire1];
    [wire1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(phone.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    
    //验证码
    UITextField * stoke = [[UITextField alloc] init];
    [self.view addSubview:stoke];
    stoke.delegate = self;
    UILabel * stokeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    stokeLabel.text = @"验证码";
    stokeLabel.textColor = [UIColor blackColor];
    stoke.leftView = stokeLabel;
    stoke.leftViewMode = UITextFieldViewModeAlways;
    UIButton * sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    sendBtn.backgroundColor = [UIColor redColor];
    [sendBtn setTintColor:[UIColor whiteColor]];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(butonClick:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.tag = 15;
    [stoke mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right).equalTo(@-10);
        make.top.equalTo(wire1.mas_bottom);
        make.height.equalTo(@60);
        
    }];
    stoke.tag = 40;
    stoke.rightView = sendBtn;
    stoke.rightViewMode = UITextFieldViewModeAlways;
    UIView * wire2 = [[UIView alloc] init];
    wire2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:wire2];
    [wire2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(stoke.mas_bottom);
        make.height.equalTo(@1);
    }];

    //登录密码
    UITextField * passWord = [[UITextField alloc] init];
    [self.view addSubview:passWord];
    UILabel * passWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    passWordLabel.text = @"登录密码";
    passWord.delegate = self;
    passWord.secureTextEntry = YES;
    passWordLabel.textColor = [UIColor blackColor];
    passWord .leftView = passWordLabel;
    passWord .leftViewMode = UITextFieldViewModeAlways;
    [passWord  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right).equalTo(@-10);
        make.top.equalTo(wire2.mas_bottom);
        make.height.equalTo(@60);
        
    }];
    UIView * wire3 = [[UIView alloc] init];
    wire3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:wire3];
    [wire3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.top.equalTo(passWord.mas_bottom);
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
        make.left.equalTo(weakSelf.view.mas_left).equalTo(@30);
        make.right.equalTo(weakSelf.view.mas_right).equalTo(@-30);
        make.top.equalTo(wire3.mas_bottom).equalTo(@30);
        make.height.equalTo(@40);
        
    }];
    
    
    
}
-(void)butonClick:(UIButton *)button{
    if (button.tag == 15) {
        UITextField * phone = [self.view viewWithTag:80];
        _phoneStr = phone.text;
       if (_phoneStr!=nil && _phoneStr.length == 11) {
            [button startWithTime:10 title:@"发送" countDownTitle:@"s" color:[UIColor redColor] countCOlor:[UIColor redColor]];
        }else{
            
            [self alWithTitle:@"格式不正确"];
        }
    
    
    
    }else{
        //在此进行数据等的校对
        
        self.phoneString(_phoneStr);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)alWithTitle:(NSString *)message {
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"温馨提示:" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
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
