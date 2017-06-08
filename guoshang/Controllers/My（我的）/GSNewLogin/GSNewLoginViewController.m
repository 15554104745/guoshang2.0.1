//
//  GSNewLoginViewController.m
//  guoshang
//
//  Created by 时礼法 on 16/11/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNewLoginViewController.h"
#import "GSNewRegistViewController.h"
#import "WKProgressHUD.h"
#import "GSGoodsDetailSingleClass.h"
#import "ForgetViewController.h"
#import "GSNewForgetPWController.h"

@interface GSNewLoginViewController ()<UITextFieldDelegate>

@end

@implementation GSNewLoginViewController
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
    self.LoginBackView.layer.cornerRadius = 15;
    self.LoginBackView.clipsToBounds = YES;
    self.LoginBackView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];

    //设置登录按钮
    self.login.layer.cornerRadius = 8;
    self.login.clipsToBounds = YES;
    self.login.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5];
    
    self.nameTextF.delegate = self;
    self.passwordTextF.delegate = self;
    self.passwordTextF.secureTextEntry = YES;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Ruser"] != nil) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Ruser"];
        self.nameTextF.text = dic[@"name"];
        self.passwordTextF.text = dic[@"passWord"];
    }
    
}

- (IBAction)LoginButton:(id)sender {
    
    [self.nameTextF resignFirstResponder];
    [self.passwordTextF resignFirstResponder];
    
    if ([self valiMobile:self.nameTextF.text]) {
        
        WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:@"登录中" animated:YES];
        NSString  *encryptString;
        
        NSString * account = [NSString stringWithFormat:@"source=iOS,mobile=%@,password=%@",self.nameTextF.text,self.passwordTextF.text];
        
        encryptString = [account encryptStringWithKey:KEY];
        NSString *url = URLDependByBaseURL(@"/Api/User/login");
        
        [HttpTool POST:url parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            NSString * str = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"status"]];
            
            
            if ([str isEqualToString:@"1"]) {
                // NSLog(@"成功");
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
                    NSString * userStr = [NSString stringWithFormat:@"%@-%@",self.nameTextF.text,self.passwordTextF.text];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:userStr forKey:@"user"];
                }
                [hud dismiss:YES];
                if (self.changeToCar) {
                    [[self.navigationController.viewControllers firstObject] setSelectedIndex:2];
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if ([str isEqualToString:@"1006"]){
                [self alWithTitle:@"用户不存在，请核对用户"];
                [hud dismiss:YES];
                
            }else if ([str isEqualToString:@"1005"]){
                
                [self alWithTitle:@"密码错误,请重新输入"];
                self.passwordTextF.text = nil;
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

    
}


-(void)alWithTitle:(NSString *)message {
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"温馨提示:" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
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

- (IBAction)toBack:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)RegistButton:(id)sender {
    
    GSNewRegistViewController *regist = [[GSNewRegistViewController alloc] init];
    [self.navigationController pushViewController:regist animated:YES];
}

- (IBAction)remember:(id)sender {
    
    UIButton *button = [self.view viewWithTag:301];
     button.selected = !button.selected;

    if (button.selected == YES) {

        if (self.nameTextF.text != nil && self.passwordTextF.text != nil) {
            NSDictionary *dic = @{@"name":self.nameTextF.text,@"passWord":self.passwordTextF.text};
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dic forKey:@"Ruser"];
            [defaults synchronize];
        }
        
    }else{
        
        self.passwordTextF.text = nil;
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Ruser"];
    }

    
}



- (IBAction)forgetPassword:(id)sender {
    
    GSNewForgetPWController * forget =[[GSNewForgetPWController
                                     alloc] init];
    [self.navigationController pushViewController:forget animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
