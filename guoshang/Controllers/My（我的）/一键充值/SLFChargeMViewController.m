//
//  SLFChargeMViewController.m
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SLFChargeMViewController.h"
#import "SLFRechargeViewController.h"
#import "GSProtocolViewController.h"
#import "SVProgressHUD.h"

@interface SLFChargeMViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UITextView *WriteView;

@end

@implementation SLFChargeMViewController
{
    UIScrollView *_scrollView;
    UIButton *CancellB;
    UIButton *SureB;
    UIButton *LIcon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"一键充值";
    _scrollView  = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(Width, Height + 120);
    [self.view addSubview:_scrollView];
    [self addUI];
}

-(void)addUI
{
    self.view.backgroundColor = MyColor;
    UILabel *rechargeM = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 80, 30)];
    rechargeM.text = @"充值金额 : ";
    rechargeM.textColor = [UIColor grayColor];
    rechargeM.textAlignment = NSTextAlignmentLeft;
    rechargeM.font = [UIFont systemFontOfSize:17];
    [_scrollView addSubview:rechargeM];
    
    UILabel *MoneyL = [[UILabel alloc] initWithFrame:CGRectMake(rechargeM.endPointX, 30, 100, 30)];
    MoneyL.text = [NSString stringWithFormat:@"%@元",self.Money];
    MoneyL.textColor = [UIColor redColor];
    MoneyL.textAlignment = NSTextAlignmentLeft;
    MoneyL.font = [UIFont systemFontOfSize:17];
    [_scrollView addSubview:MoneyL];
    
    UILabel *lineHL = [[UILabel alloc] initWithFrame:CGRectMake(0, rechargeM.endPointY + 5, Width, 0.5)];
    lineHL.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:lineHL];
    
    UILabel *rechargeType = [[UILabel alloc] initWithFrame:CGRectMake(20, lineHL.endPointY + 15, Width, 30)];
    rechargeType.text = @"支付方式";
    rechargeType.textColor = [UIColor grayColor];
    rechargeType.textAlignment = NSTextAlignmentLeft;
    rechargeType.font = [UIFont systemFontOfSize:17];
    [_scrollView addSubview:rechargeType];
    
    UIImageView *PayTy = [[UIImageView alloc] initWithFrame:CGRectMake(60, rechargeType.endPointY + 15, 60, 60)];

    PayTy.image = [UIImage imageNamed:@"zhifubao1@3x.png"];
    PayTy.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:PayTy];
    
    UILabel *PayTyL = [[UILabel alloc] initWithFrame:CGRectMake(33, PayTy.endPointY, 120, 30)];
    PayTyL.text = @"支付宝支付";
    PayTyL.textColor = [UIColor grayColor];
    PayTyL.textAlignment = NSTextAlignmentCenter;
    PayTyL.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:PayTyL];
    
    UILabel *MemWri = [[UILabel alloc] initWithFrame:CGRectMake(20, PayTyL.endPointY + 20, 120, 30)];
    MemWri.text = @"会员备注 :";
    MemWri.textColor = [UIColor grayColor];
    MemWri.textAlignment = NSTextAlignmentLeft;
    MemWri.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:MemWri];
    
    _WriteView = [[UITextView alloc] initWithFrame:CGRectMake(20, MemWri.endPointY,Width - 40, 40)];
    _WriteView.layer.borderColor = [[UIColor grayColor] CGColor];
    _WriteView.layer.borderWidth = 0.5f;
    _WriteView.layer.cornerRadius = 10;
    if ([_writeView isEqualToString:@""]) {
        _WriteView.text = @"无";
    }else
    {
        _WriteView.text = self.writeView;
    }

    _WriteView.layer.masksToBounds = YES;
    [_scrollView addSubview:_WriteView];
    
    LIcon = [[UIButton alloc] initWithFrame:CGRectMake(20, _WriteView.endPointY + 10, 15, 15)];
    LIcon.layer.borderColor = [[UIColor blackColor] CGColor];
    [LIcon addTarget:self action:@selector(LIconClick:) forControlEvents:UIControlEventTouchUpInside];
    LIcon.backgroundColor = [UIColor redColor];
    LIcon.selected = YES;
    LIcon.layer.borderWidth = 0.5f;
    LIcon.layer.cornerRadius = 8;
    LIcon.layer.masksToBounds = YES;
    [_scrollView addSubview:LIcon];
    
    UIButton *LIconL = [[UIButton alloc] initWithFrame:CGRectMake(LIcon.endPointX + 3, _WriteView.endPointY + 8, 160, 20)];
    [LIconL setTitle:@"充值卡协议 , 购买表示同意" forState:UIControlStateNormal];
    [LIconL addTarget:self action:@selector(ToWebView) forControlEvents:UIControlEventTouchUpInside];
    [LIconL setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    LIconL.titleLabel.textAlignment = NSTextAlignmentCenter;
    LIconL.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_scrollView addSubview:LIconL];
    
    SureB = [[UIButton alloc] initWithFrame:CGRectMake(20, LIconL.endPointY + 50, Width/2 - 15, 30)];
    SureB.titleLabel.textAlignment = NSTextAlignmentCenter;
    SureB.layer.cornerRadius = 10;
    SureB.layer.masksToBounds = YES;
    [SureB setTitle:@"提交申请" forState:UIControlStateNormal];
    SureB.titleLabel.font = [UIFont systemFontOfSize:17];
    SureB.backgroundColor = [UIColor redColor];
    [SureB addTarget:self action:@selector(SureBClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:SureB];
    
    CancellB = [[UIButton alloc] initWithFrame:CGRectMake(Width/2 + 15, LIconL.endPointY + 50, Width/2 - 30, 30)];
    CancellB.titleLabel.textAlignment = NSTextAlignmentCenter;
    [CancellB setTitle:@"重置" forState:UIControlStateNormal];
    CancellB.layer.cornerRadius = 10;
    CancellB.layer.masksToBounds = YES;
    CancellB.titleLabel.font = [UIFont systemFontOfSize:17];
    CancellB.backgroundColor = [UIColor grayColor];
    [CancellB addTarget:self action:@selector(CancellBClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:CancellB];
}

-(void)LIconClick:(UIButton *)button
{
    if (button.selected == NO) {
        button.backgroundColor = [UIColor redColor];
        button.selected = YES;
    }else
    {
        button.selected = NO;
        button.backgroundColor = [UIColor whiteColor];
    }
    
}

-(void)SureBClick:(UIButton *)button
{
    if (LIcon.selected == NO) {
        [AlertTool alertMesasge:@"您未遵守协议" confirmHandler:nil viewController:self];
        return;
    }
    
    if ([self.ali_pay_order_sn isEqualToString:@""] || self.ali_pay_order_sn == nil) {
        
        //创建生成订单
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"正在创建充值订单···"];
        NSString *  encryptString;
        NSString * userId = [NSString stringWithFormat:@"user_id=%@,amount=%@,user_note=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],self.Money,_WriteView.text];
        encryptString = [userId encryptStringWithKey:KEY];
        [HttpTool POST:URLDependByBaseURL(@"/Api/User/get_rechargeCard_info") parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            
            //跳转到支付宝进行支付
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:self.Money forKey:@"all_price"];
            [dic setObject:responseObject[@"result"][@"notify_url"] forKey:@"notify_url"];
            [dic setObject:responseObject[@"result"][@"ali_pay_order_sn"] forKey:@"trade_no"];
            [dic setObject:responseObject[@"result"][@"pay_order_sn"] forKey:@"ordsubject"];
            
            
            [HttpTool toPayWithAliSDKWith:dic AndViewController:self Isproperty:NO IsToPayForProperty:NO];
            
            button.backgroundColor = [UIColor redColor];
            CancellB.backgroundColor = [UIColor grayColor];
            button.selected = YES;
            
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
    }else
    {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.Money forKey:@"all_price"];
        [dic setObject:self.notify_url forKey:@"notify_url"];
        [dic setObject:self.ali_pay_order_sn forKey:@"trade_no"];
        [dic setObject:self.pay_order_sn forKey:@"ordsubject"];
        
        
        [HttpTool toPayWithAliSDKWith:dic AndViewController:self Isproperty:NO IsToPayForProperty:NO];
        
        button.backgroundColor = [UIColor redColor];
        CancellB.backgroundColor = [UIColor grayColor];
        button.selected = YES;

    }
}

-(void)CancellBClick:(UIButton *)button
{
        button.backgroundColor = [UIColor redColor];
    SureB.backgroundColor = [UIColor grayColor];
    
    _WriteView.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_scrollView endEditing:YES];
}

//充值卡协议跳转方法
-(void)ToWebView
{
    GSProtocolViewController *web = [[GSProtocolViewController alloc] init];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
