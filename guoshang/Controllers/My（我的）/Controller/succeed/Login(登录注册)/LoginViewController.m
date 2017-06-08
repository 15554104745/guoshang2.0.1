//
//  LoginViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "LoginViewController.h"
#import "PopViewController.h"
#import "RegisterViewController.h"
#import "SetUpViewController.h"
#import "ForgetViewController.h"
#import "NSString+Encrypt3DESandBase64.h"
#import "UMSocial.h"
#import "WKProgressHUD.h"
#import "GSGoodsDetailSingleClass.h"
@interface LoginViewController ()<UITextFieldDelegate,UMSocialUIDelegate>
{
    UITextField * _numTF;
    UITextField * _pwdTF;
    BOOL _bkeyboardHide;
}
@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
    [self createLoginUI];
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
    
    
}

/**
 点击任意界面返回
 */
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
//    NSLog(@"%d",_bkeyboardHide);
    
    if (_bkeyboardHide) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
        
        [self.view endEditing:YES];
        
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


//-(void)createItems{
//
//    UIButton * backBtn =[[UIButton alloc] initWithFrame:CGRectMake(15, 30, 18, 32)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
//
//
//}

//登录界面
- (void)createLoginUI{
    
    UIImageView * logIcon = [[UIImageView alloc] init];
    logIcon.image = [UIImage imageNamed:@"guoshang2"];
    [self.view addSubview:logIcon];
    __weak typeof(self)weakSelf = self;
    [logIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).equalTo(@100);
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(40);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-40);
        make.height.mas_equalTo(@80);
    }];
    
    //手机号
    UIView * phoneView = [[UIView alloc] init];
    int podding = (Width - 232) / 2;
    phoneView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"denglu"]];
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logIcon.mas_bottom).equalTo(@70);
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(podding);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-podding);
        make.height.mas_equalTo(@35);
        
    }];
    
    
    
    UIImageView * phoneIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 16)];
    phoneIcon.image = [UIImage imageNamed:@"shouji"];
    [phoneView addSubview:phoneIcon];
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneView.mas_top).equalTo(@10);
        make.left.mas_equalTo(phoneView.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(10, 16));
    }];
    
    
    _numTF = [[UITextField alloc]init];
    _numTF.textColor = [UIColor whiteColor];
    _numTF.tag = 1000;
    _numTF.delegate = self;
    _numTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _numTF.autocapitalizationType = UITextAutocorrectionTypeYes;
    [phoneView addSubview:_numTF];
    [_numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneView.mas_top);
        make.left.mas_equalTo(phoneIcon.mas_left).equalTo(@20);
        make.bottom.mas_equalTo(phoneView.mas_bottom);
        make.right.mas_equalTo(phoneView.mas_right);
    }];
    
    
    
    //密码
    UIView * passWordView = [[UIView alloc] init];
    passWordView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"denglu"]];
    [self.view addSubview:passWordView];
    [passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneView.mas_bottom).equalTo(@10);
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(podding);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-podding);
        make.height.mas_equalTo(@35);
        
    }];
    UIImageView * passWordIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 16)];
    passWordIcon.image = [UIImage imageNamed:@"suo1"];
    [passWordView addSubview:passWordIcon];
    [passWordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passWordView.mas_top).equalTo(@10);
        make.left.mas_equalTo(passWordView.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(10, 16));
    }];
    
    
    _pwdTF = [[UITextField alloc]init];
    _pwdTF.delegate = self;
    _pwdTF.secureTextEntry = YES;
    _pwdTF.tag = 1001;
    _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTF.textColor = [UIColor whiteColor];
    [passWordView addSubview:_pwdTF];
    [_pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passWordView.mas_top);
        make.left.mas_equalTo(passWordIcon.mas_left).equalTo(@20);
        make.bottom.mas_equalTo(passWordView.mas_bottom);
        make.right.mas_equalTo(passWordView.mas_right);
    }];
    
    //判断是否选择
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user"]!=nil) {
        NSString * str =[[NSUserDefaults standardUserDefaults]objectForKey:@"user"];
        NSArray * array = [str componentsSeparatedByString:@"-"];
        _numTF.text = array[0];
        _pwdTF.text = array[1];
        
    }
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"dnglu2"] forState:UIControlStateNormal];
    loginButton.tag = 10;
    [loginButton setTintColor:[UIColor redColor]];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [loginButton addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pwdTF.mas_bottom).with.offset(20);
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(podding);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-podding);
        make.height.mas_equalTo(@35);
    }];
    
    
    UIButton * regButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [regButton setImage:[UIImage imageNamed:@"zhuce"] forState:UIControlStateNormal];
    regButton.tag = 11;
    [regButton addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regButton];
    [regButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginButton.mas_bottom).with.offset(20);
        make.left.mas_equalTo(self.view.mas_left).with.offset(podding);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-podding);
        make.height.mas_equalTo(@35);
    }];
    
    UIButton * remerber = [[UIButton alloc] init];
    //是否记住密码
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user"]!=nil) {
        remerber.selected = YES;
    }
    [remerber setImage:[UIImage imageNamed:@"jizhuwo"] forState:UIControlStateSelected];
    [remerber setImage:[UIImage imageNamed:@"jishuwoS"] forState:UIControlStateNormal];
    remerber.tag = 301;
    [remerber addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:remerber];
    [remerber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(regButton.mas_bottom).with.offset(20);
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(podding);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    
    LNLabel * remeberLn = [LNLabel addLabelWithTitle:@"记住我?" TitleColor:[UIColor whiteColor] Font:13 BackGroundColor:nil];
    [self.view addSubview:remeberLn];
    [remeberLn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(regButton.mas_bottom).with.offset(20);
        make.left.mas_equalTo(remerber.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 23));
    }];
    
    LNButton * forgetPassWord = [LNButton buttonWithType:UIButtonTypeSystem Title:@"忘记密码" TitleColor:[UIColor whiteColor] Font:13 Target:self AndAction:@selector(buttonclick:)];
    forgetPassWord.tag = 300;
    [self.view addSubview:forgetPassWord];
    [forgetPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(regButton.mas_bottom).with.offset(20);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-podding);
        make.size.mas_equalTo(CGSizeMake(60, 23));
    }];
    
    /**********************************第三方登录******************************************************/
    
//    UIButton * qqLogin = [UIButton buttonWithType:UIButtonTypeSystem];
//    //    [qqLogin setBackgroundImage:[UIImage imageNamed:@"dnglu2"] forState:UIControlStateNormal];
//    qqLogin.tag = 302;
//    [qqLogin setTintColor:[UIColor redColor]];
//    [qqLogin setTitle:@"QQ" forState:UIControlStateNormal];
//    qqLogin.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [qqLogin addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:qqLogin];
//    [qqLogin mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(forgetPassWord.mas_bottom).with.offset(20);
//        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(podding);
//        make.right.mas_equalTo(weakSelf.view.mas_centerX).with.offset(-podding);
//        make.height.mas_equalTo(@35);
//    }];
//    
//    UIButton * wxLogin = [UIButton buttonWithType:UIButtonTypeSystem];
//    //    [wxLogin setBackgroundImage:[UIImage imageNamed:@"dnglu2"] forState:UIControlStateNormal];
//    wxLogin.tag = 303;
//    [wxLogin setTintColor:[UIColor redColor]];
//    [wxLogin setTitle:@"微信" forState:UIControlStateNormal];
//    wxLogin.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [wxLogin addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:wxLogin];
//    [wxLogin mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(forgetPassWord.mas_bottom).with.offset(20);
//        make.left.mas_equalTo(weakSelf.view.mas_centerX).with.offset(podding);
//        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-podding);
//        make.height.mas_equalTo(@35);
//    }];
    
    
}

//按钮点击事件
-(void)buttonclick:(UIButton *)button{
    [_pwdTF resignFirstResponder];
    [_numTF resignFirstResponder];

    if (button.tag == 10) {

        
//        if (_numTF.text.length == 11) {
        if ([self valiMobile:_numTF.text]) {

             WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:@"登录中" animated:YES];
            NSString  *encryptString;
            
            NSString * account = [NSString stringWithFormat:@"source=iOS,mobile=%@,password=%@",_numTF.text,_pwdTF.text];
            
            encryptString = [account encryptStringWithKey:KEY];
//            NSLog(@"%@",encryptString);
            NSString *url = URLDependByBaseURL(@"/Api/User/login");
            //@"http://www.ibg100.com/Apiss/index.php?m=Api&c=User&a=login"
            
            [HttpTool POST:url parameters:@{@"token":encryptString} success:^(id responseObject) {
                
                NSString * str = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"status"]];

                
                if ([str isEqualToString:@"1"]) {
//                    NSLog(@"成功");
                    NSDictionary * dic = [  NSDictionary dictionaryWithDictionary: responseObject[@"result"][@"userinfo"]];
                    NSString * str = dic[@"user_id"];
                    NSString * nameStr = dic[@"user_name"];
                    if ([dic[@"store_user_type"] integerValue] == 3) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isBusinessUser"];
                    }
                    
                    if (dic[@"shop_id"] && ![dic[@"shop_id"] isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:dic[@"shop_id"] forKey:@"GSBusinessUserShopID"];
                    }
                    
                    //判断是否是业务员
                    if ([dic[@"is_salesman"] isEqualToNumber:@1]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isGuide"];
                    }
        
                    
                    GSGoodsDetailSingleClass *singleClass = [GSGoodsDetailSingleClass sharInstance];
                    singleClass.province_id = @"";

                    //用户user_id
                    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"enter"];
                    //用户名
                    [[NSUserDefaults standardUserDefaults] setObject:nameStr forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    //判断是否需要记住密码
                    UIButton * button = [self.view viewWithTag:301];
                    if (button.selected == YES) {
                        NSString * userStr = [NSString stringWithFormat:@"%@-%@",_numTF.text,_pwdTF.text];
                        
                        [[NSUserDefaults standardUserDefaults]setObject:userStr forKey:@"user"];
                    }
                            [hud dismiss:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else if ([str isEqualToString:@"1006"]){
                    [self alWithTitle:@"用户不存在，请核对用户"];
                      [hud dismiss:YES];
                    
                }else if ([str isEqualToString:@"1005"]){
                    
                    [self alWithTitle:@"密码错误,请重新输入"];
                      [hud dismiss:YES];
                    
                }else if ([str isEqualToString:@"1004"]){
                    
                    [AlertTool alertMesasge:@"密码长度不够，请重新输入" confirmHandler:nil viewController:self];
                      [hud dismiss:YES];
                }
                
            } failure:^(NSError *error) {
                  [hud dismiss:YES];
            }];
            
        }else{
            [AlertTool alertMesasge:@"手机格式不正确" confirmHandler:nil viewController:self];
        }
        
        //忘记密码
    }else if (button.tag == 300){
        ForgetViewController * forget =[[ForgetViewController
                                         alloc] init];
        [self.navigationController pushViewController:forget animated:YES];
        //记住我
    }else if (button.tag == 301){
        button.selected = !button.selected;
        
        if (button.selected == YES) {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user"]!=nil &&_numTF.text!=nil&&_pwdTF!=nil) {
                NSString * userStr = [NSString stringWithFormat:@"%@ - %@",_numTF.text,_pwdTF.text];
                [[NSUserDefaults standardUserDefaults]setObject:userStr forKey:@"user"];
            }
            
        }else{
            
            _numTF.text = nil;
            _pwdTF.text = nil;
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"user"];
        }
        
    }else if (button.tag == 302){//qq登录
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            //           获取微博用户名、uid、token、第三方的原始用户信息thirdPlatformUserProfile等
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity * snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                
                NSURL * imageUrl = [NSURL URLWithString:response.thirdPlatformUserProfile[@"figureurl_qq_2"]];
                NSData * imageData = [NSData dataWithContentsOfURL:imageUrl];
                [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"image"];
                NSString * account = [NSString stringWithFormat:@"open_id=%@,name=%@",snsAccount.usid,snsAccount.userName];
//                NSLog(@"%@",account);
                NSString  * encryptString = [account encryptStringWithKey:KEY];
//                NSLog(@"%@",encryptString);
                [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=third_login") parameters:@{@"token":encryptString} success:^(id responseObject) {
//                    NSLog(@"%@",responseObject);
//                    NSLog(@"%@",responseObject[@"status"]);
                    if (responseObject[@"status"]) {
                        NSDictionary * dic = [NSDictionary dictionaryWithDictionary: responseObject[@"result"]];
                        NSString * str = dic[@"user_id"];
                        NSString * nameStr = dic[@"user_name"];
                        //用户user_id
                        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"enter"];
                        //用户名
                        [[NSUserDefaults standardUserDefaults] setObject:nameStr forKey:@"userName"];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } failure:^(NSError *error) {
//                    NSLog(@"%@",error);
                }];
                
//                NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            }
        });
    }else if (button.tag == 303){//微信登录
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            //           获取微博用户名、uid、token、第三方的原始用户信息thirdPlatformUserProfile等
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
                
                    NSURL * imageUrl = [NSURL URLWithString:response.thirdPlatformUserProfile[@"figureurl_qq_2"]];
                    NSData * imageData = [NSData dataWithContentsOfURL:imageUrl];
                    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"image"];
                    NSString * account = [NSString stringWithFormat:@"name=%@,open_id=%@",snsAccount.userName,snsAccount.usid];
                    NSString  * encryptString = [account encryptStringWithKey:KEY];
                    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=third_login") parameters:@{@"token":encryptString} success:^(id responseObject) {
//                        NSLog(@"%@",responseObject);
                        if (responseObject[@"status"]) {
                            NSDictionary * dic = [NSDictionary dictionaryWithDictionary: responseObject[@"result"]];
                            NSString * str = dic[@"user_id"];
                            NSString * nameStr = dic[@"user_name"];
                            //用户user_id
                            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"enter"];
                            //用户名
                            [[NSUserDefaults standardUserDefaults] setObject:nameStr forKey:@"userName"];
    
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } failure:^(NSError *error) {
    
                    }];
                
//                NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            }
        });
    }else{
//        NSLog(@"register...");
        RegisterViewController * rvc = [[RegisterViewController alloc]init];
        [self.navigationController pushViewController:rvc animated:YES];
    }
    
    
}


-(void)toBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)alWithTitle:(NSString *)message {
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"温馨提示:" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //由tag值找到两个不同的textField
    UITextField *textField1 = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textField2 = (UITextField *)[self.view viewWithTag:1001];
    //当光标在第一个里面时
    if (textField.tag == 1000) {
        //第一个失去响应
        [textField1 resignFirstResponder];
        //第二个开始响应
        [textField2 becomeFirstResponder];
    }else if (textField.tag == 1001){
        //第二个失去响应
        [textField2 resignFirstResponder];
    }
    
    return YES;
}

//当键盘开始响应就执行
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //整体的父视图是能够更改位置的，移动整体的父视图
    _bkeyboardHide = YES;
    if (textField.tag == 1000) {
        //动画效果
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, -216, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //让父视图回归原位置
    
    if (textField.tag == 1001) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
    _bkeyboardHide = NO;
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
