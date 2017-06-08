//
//  SLFBindingCard.m
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SLFBindingCard.h"
#import "AuthCodeView.h"
#import "SVProgressHUD.h"
#import "SLFRechargeViewController.h"

#define CountForText 4
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@interface SLFBindingCard ()<AuthCodeViewDataSource>

@end

@implementation SLFBindingCard
{
    UITextField * TF1;
    UITextField * TF2;
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
        UILabel * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 90, 15)];
        lb1.text = @"充值卡密码：";
        lb1.font = [UIFont systemFontOfSize:15];
        lb1.textColor  =COLOR(102, 102, 102, 102);
        [self addSubview:lb1];
        
        TF1 =[[UITextField alloc]initWithFrame:CGRectMake(110, 45, Width-110-20, 30)];
        TF1.borderStyle =  UITextBorderStyleRoundedRect;
        TF1.placeholder = @"密码区分大小写";
        [TF1 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:TF1];
        
        UILabel * lb2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 100, 110, 15)];
        lb2.text = @"请输入验证码：";
        lb2.font = [UIFont systemFontOfSize:15];
        lb2.textColor  =COLOR(102, 102, 102, 102);
        [self addSubview:lb2];
        
        TF2 =[[UITextField alloc]initWithFrame:CGRectMake(120, 95, Width-125-80, 30)];
        TF2.borderStyle =  UITextBorderStyleRoundedRect;
        TF2.placeholder = @"区分大小写";
       [TF2 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        
        [self addSubview:TF2];
        
        AuthCodeView *codeViewText = [[AuthCodeView alloc] initWithType:AuthCodeViewTypeText];
        [codeViewText setFrame:CGRectMake(Width-75, 95, 64.0, 30)];
        
        codeViewText.dataSource = self;
        [self addSubview:codeViewText];
        
        UIButton * chongzhiBT = [[UIButton alloc]initWithFrame:CGRectMake(30, 280, Width-60, 44)];
        [chongzhiBT setTitle:@"立即绑定" forState:1];
        [chongzhiBT setTitle:@"立即绑定" forState:0];
        [chongzhiBT addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [chongzhiBT setTitleColor:[UIColor whiteColor] forState:0];
        [chongzhiBT setTitleColor:[UIColor whiteColor] forState:1];
        chongzhiBT.backgroundColor = COLOR(228, 58, 61, 1);
        chongzhiBT.layer.masksToBounds = YES;
        chongzhiBT.layer.cornerRadius = 20;
        [self addSubview:chongzhiBT];
        
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
    
    return checkNum;
}

-(void)next
{

    if (TF1.text.length == 0 || TF2.text.length == 0 ) {
        
        [AlertTool alertMesasge:@"输入不完全请输入！" confirmHandler:nil viewController:self.VC];
        return;
    }

    if (![TF2.text isEqualToString:checkNum]) {
        [AlertTool alertMesasge:@"验证码不正确" confirmHandler:nil viewController:self.VC];
        return;
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在请求数据"];
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,card_sn=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],[NSString stringWithFormat:@"%@",TF1.text]];
    encryptString = [userId encryptStringWithKey:KEY];
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/BindEntityCards") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        _ReloadBlock();
        TF1.text = @"";
        TF2.text = @"";
        
        [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:self.VC];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

@end
