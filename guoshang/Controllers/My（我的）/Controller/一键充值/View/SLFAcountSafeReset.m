//
//  SLFAcountSafeReset.m
//  guoshang
//
//  Created by 时礼法 on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SLFAcountSafeReset.h"
#import "AuthCodeView.h"
#import "SVProgressHUD.h"
#import "SLFAcountSafeReset.h"
#define CountForText 4
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@interface SLFAcountSafeReset ()<AuthCodeViewDataSource>

@end

@implementation SLFAcountSafeReset
{
    UITextField * TF1;
    UITextField * lbis;
    UITextField * TF2;
    UITextField * lbis2;
    NSString *checkNum;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI
{
    self.backgroundColor =[UIColor whiteColor];
    
    UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 120, 17)];
    lb.text = @"重新设置支付密码";
    lb.font = [UIFont systemFontOfSize:15];
    lb.textColor  =COLOR(102, 102, 102, 102);
    [self addSubview:lb];
    
    UILabel * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(25, 60, 110, 15)];
    lb1.text = @"请输入原支付密码：";
    lb1.font = [UIFont systemFontOfSize:12];
    lb1.textColor  =COLOR(102, 102, 102, 102);
    [self addSubview:lb1];
    
    TF1 =[[UITextField alloc]initWithFrame:CGRectMake(130, 55, Width-110-30, 30)];
    TF1.borderStyle =  UITextBorderStyleRoundedRect;
    TF1.secureTextEntry = YES;
    TF1.placeholder = @"密码区分大小写";
    [TF1 setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self addSubview:TF1];
    
    UILabel * lbisL = [[UILabel alloc]initWithFrame:CGRectMake(25, 95, 90, 15)];
    lbisL.text = @"请输入新密码：";
    lbisL.font = [UIFont systemFontOfSize:12];
    lbisL.textColor  =COLOR(102, 102, 102, 102);
    [self addSubview:lbisL];
    
    lbis =[[UITextField alloc]initWithFrame:CGRectMake(130, 90, Width-110-30, 30)];
    lbis.borderStyle =  UITextBorderStyleRoundedRect;
    lbis.secureTextEntry = YES;
    lbis.placeholder = @"密码区分大小写";
    [lbis setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self addSubview:lbis];
    
    UILabel * lbisL2 = [[UILabel alloc]initWithFrame:CGRectMake(25, 130, 90, 15)];
    lbisL2.text = @"请再次输入：";
    lbisL2.font = [UIFont systemFontOfSize:12];
    lbisL2.textColor  =COLOR(102, 102, 102, 102);
    [self addSubview:lbisL2];
    
    lbis2 =[[UITextField alloc]initWithFrame:CGRectMake(130, 125, Width-110-30, 30)];
    lbis2.borderStyle =  UITextBorderStyleRoundedRect;
    lbis2.secureTextEntry = YES;
    lbis2.placeholder = @"密码区分大小写";
    [lbis2 setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self addSubview:lbis2];
    
    UILabel * lb2 = [[UILabel alloc]initWithFrame:CGRectMake(25, 175, 110, 15)];
    lb2.text = @"请输入验证码：";
    lb2.font = [UIFont systemFontOfSize:12];
    lb2.textColor  =COLOR(102, 102, 102, 102);
    [self addSubview:lb2];
    
    TF2 =[[UITextField alloc]initWithFrame:CGRectMake(125, 170, Width-125-90, 30)];
    TF2.placeholder = @"验证码区分大小写";
    [TF2 setFont:[UIFont systemFontOfSize:12.f]];
    TF2.borderStyle =  UITextBorderStyleRoundedRect;
    
    [self addSubview:TF2];
    
    AuthCodeView *codeViewText = [[AuthCodeView alloc] initWithType:AuthCodeViewTypeText];
    [codeViewText setFrame:CGRectMake(Width-75, 170, 64.0, 30)];
    
   
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"标志"]];
//    if ([[UIScreen mainScreen] bounds].size.height > 568) {
//        image.frame = CGRectMake(25, 250, 12, 12);
//    }else
//    {
//        image.frame = CGRectMake(25, 250, 12, 12);
//    }
    image.frame = CGRectMake(25, 250, 12, 12);
    image.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:image];
    
    UILabel * tip = [[UILabel alloc]initWithFrame:CGRectMake(40, 230, Width - 50,80)];
    tip.text = @"为了提高你的资金安全，防止别人盗用。需要设置支付密码，支付密码开启后，使用充值卡余额支付时，需要设置支付密码，为你的账户安全加把锁。";
    tip.numberOfLines = 0;
    tip.font = [UIFont systemFontOfSize:12];
    tip.textColor  =COLOR(102, 102, 102, 102);
    [self addSubview:tip];
    
    
    codeViewText.dataSource = self;
    [self addSubview:codeViewText];
    
    UIButton * TJButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 340, Width-60, 44)];
    [TJButton setTitle:@"提交" forState:1];
    [TJButton setTitle:@"提交" forState:0];
    [TJButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [TJButton setTitleColor:[UIColor whiteColor] forState:0];
    [TJButton setTitleColor:[UIColor whiteColor] forState:1];
    TJButton.userInteractionEnabled = YES;
    TJButton.backgroundColor = COLOR(228, 58, 61, 1);
    TJButton.layer.masksToBounds = YES;
    TJButton.layer.cornerRadius = 20;
    [self addSubview:TJButton];
    
}

- (NSString *)authCodeView:(AuthCodeView *)p_view withType:(AuthCodeViewType)p_type;
{
    
    char data[CountForText];
    for (int x = 0; x < CountForText; x++)
    {
        
        int j = '0' + (arc4random_uniform(75));
        
        if((j>=58 && j<= 64) || (j>=91 && j<=96)){
            --x;
            continue;
        }else{
            data[x] = (char)j;
        }
        
        
    }
    
    
    checkNum = [[NSString alloc] initWithBytes:data length:CountForText encoding:NSUTF8StringEncoding];
    return [[NSString alloc] initWithBytes:data length:CountForText encoding:NSUTF8StringEncoding];
}

-(void)nextStep
{
    if (TF1.text.length == 0 || TF2.text.length == 0 || lbis2.text.length == 0 || lbis.text.length == 0) {
        
        [AlertTool alertMesasge:@"输入不完全请输入！" confirmHandler:nil viewController:self.VC];
        return;
    }
    
    if (![lbis2.text isEqualToString:lbis.text]) {
        
        [AlertTool alertMesasge:@"密码输入不一致" confirmHandler:nil viewController:self.VC];
        return;
    }
    if (![TF2.text isEqualToString:checkNum]) {
        [AlertTool alertMesasge:@"验证码不正确" confirmHandler:nil viewController:self.VC];
        return;
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在请求数据"];
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,type=1,old_password=%@,new_password=%@,re_password=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],TF1.text,lbis.text,lbis2.text];
    encryptString = [userId encryptStringWithKey:KEY];
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/SavePayPassword") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:responseObject[@"message"] delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:@"取消" , nil];
        [alert show];
        [SVProgressHUD dismiss];
        [self removeFromSuperview];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
@end
