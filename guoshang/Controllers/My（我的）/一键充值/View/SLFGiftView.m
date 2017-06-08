//
//  SLFGiftView.m
//  guoshang
//
//  Created by 时礼法 on 16/8/10.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SLFGiftView.h"
#import "AuthCodeView.h"
#import "SVProgressHUD.h"
#import "GetPresentViewController.h"

@interface SLFGiftView ()<AuthCodeViewDataSource>

@end

@implementation SLFGiftView
{
    UITextField *_TF1;
    UITextField *_TF2;
    NSString *code;
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
    UILabel * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 90, 15)];
    lb1.text = @"赠品卡密码：";
    lb1.font = [UIFont systemFontOfSize:15];
    lb1.textColor  =COLOR(102, 102, 102, 102);
    [self addSubview:lb1];
    
    _TF1 =[[UITextField alloc]initWithFrame:CGRectMake(110, 45, Width-110-20, 30)];
    _TF1.borderStyle =  UITextBorderStyleRoundedRect;
    _TF1.placeholder = @"密码区分大小写";
    [_TF1 setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [self addSubview:_TF1];
    
    UILabel * lb2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 100, 110, 15)];
    lb2.text = @"请输入验证码：";
    lb2.font = [UIFont systemFontOfSize:15];
    lb2.textColor  =COLOR(102, 102, 102, 102);
    [self addSubview:lb2];
    
    _TF2 =[[UITextField alloc]initWithFrame:CGRectMake(125, 95, Width-125-90, 30)];
    _TF2.borderStyle =  UITextBorderStyleRoundedRect;
    
    [self addSubview:_TF2];
    
    AuthCodeView *codeViewText = [[AuthCodeView alloc] initWithType:AuthCodeViewTypeText];
    [codeViewText setFrame:CGRectMake(Width-75, 95, 64.0, 30)];
    
    codeViewText.dataSource = self;
    [self addSubview:codeViewText];
    
    UIButton * chongzhiBT = [[UIButton alloc]initWithFrame:CGRectMake(30, 280, Width-60, 44)];
    [chongzhiBT setTitle:@"提交" forState:1];
    [chongzhiBT setTitle:@"提交" forState:0];
    [chongzhiBT addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [chongzhiBT setTitleColor:[UIColor whiteColor] forState:0];
    [chongzhiBT setTitleColor:[UIColor whiteColor] forState:1];
    chongzhiBT.backgroundColor = COLOR(228, 58, 61, 1);
    chongzhiBT.layer.masksToBounds = YES;
    chongzhiBT.layer.cornerRadius = 20;
    [self addSubview:chongzhiBT];
}

-(void)next
{
    
    if (![_TF2.text isEqualToString:code]) {
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的验证码输入有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    if (_TF1.text.length ==0) {
        
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的兑换码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
   
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,gift_password=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],_TF1.text];
    encryptString = [userId encryptStringWithKey:KEY];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/CheckGift") parameters:@{@"token":encryptString} success:^(id responseObject) {
  
        _TF1.text = @"";
        _TF2.text = @"";
        
        if([responseObject[@"status"] integerValue]==1)
        {
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [SVProgressHUD dismiss];
            
        }
        else
        {
            if([responseObject[@"result"][@"rechargeable_card"] integerValue]>0)//实体卡
            {
                GetPresentViewController *getV = [[GetPresentViewController alloc] init];
                getV.type = @"3";
                getV.chongzhikaID =responseObject[@"result"][@"card_id"] ;
                [self.popView.navigationController pushViewController:getV animated:YES];
            }
            else if ([responseObject[@"result"][@"ipad"] integerValue]==0)//直送国币
            {
                GetPresentViewController *getV = [[GetPresentViewController alloc] init];
                getV.type = @"1";
                getV.guobiCount = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"pay_points"]];
                getV.chongzhikaID =responseObject[@"result"][@"card_id"] ;
                [self.popView.navigationController pushViewController:getV animated:YES];
            }
            else//国币+pad
            {
                
                GetPresentViewController *getV = [[GetPresentViewController alloc] init];
                getV.type = @"2";
                getV.guobiCount = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"pay_points"]];
                getV.chongzhikaID =responseObject[@"result"][@"card_id"] ;
                [self.popView.navigationController pushViewController:getV animated:YES];
            }
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];

}


- (NSString *)authCodeView:(AuthCodeView *)p_view withType:(AuthCodeViewType)p_type;
{
    
    char data[4];
    for (int x = 0; x < 4; x++)
    {
        
        int j = '0' + (arc4random_uniform(75));
        
        if((j>=58 && j<= 64) || (j>=91 && j<=96)){
            --x;
            continue;
        }else{
            data[x] = (char)j;
        }
        
        
    }
    
    code =[[NSString alloc] initWithBytes:data length:4 encoding:NSUTF8StringEncoding];
    return [[NSString alloc] initWithBytes:data length:4 encoding:NSUTF8StringEncoding];
}



@end
