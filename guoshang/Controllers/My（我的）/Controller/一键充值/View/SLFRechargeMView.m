//
//  SLFRechargeMView.m
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SLFRechargeMView.h"
#import "SLFChargeMViewController.h"
#import "SVProgressHUD.h"

@implementation SLFRechargeMView
{
    UIButton *_leftBT;
    UIButton *_rightBT;
    UIButton *_centerBT;
    NSString *Money;
    
    //支付宝参数相关
    NSString *ali_pay_order_sn;
     NSString *notify_url;
     NSString *pay_order_sn;
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
    _leftBT = [[UIButton alloc] initWithFrame:CGRectMake(5, 40, Width/3 - 10, 100)];
    NSMutableAttributedString *titleL = [[NSMutableAttributedString alloc] initWithString:@"充值5000元\n即送2000国币\nPad一台"];
    NSRange redRange = NSMakeRange([[titleL string] rangeOfString:@"即送"].location, [[titleL string] rangeOfString:@"即送"].length);
    [titleL addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    [titleL addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.f] range:redRange];
    _leftBT.titleLabel.numberOfLines = 0;
    _leftBT.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_leftBT setAttributedTitle:titleL forState:UIControlStateNormal];
    _leftBT.layer.cornerRadius = 10.f;
    _leftBT.layer.masksToBounds = YES;
    [_leftBT addTarget:self action:@selector(leftBT:) forControlEvents:UIControlEventTouchUpInside];
    _leftBT.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f  blue:239/255.f  alpha:1];
    [self addSubview:_leftBT];
    
    _centerBT = [[UIButton alloc] initWithFrame:CGRectMake((Width/3) + 5, 40, Width/3 - 10, 100)];
    NSMutableAttributedString *titleC = [[NSMutableAttributedString alloc] initWithString:@"充值3000元\n即送1000国币"];
    NSRange redRange3 = NSMakeRange([[titleC string] rangeOfString:@"即送"].location, [[titleC string] rangeOfString:@"即送"].length);
    [titleC addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange3];
    [titleC addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.f] range:redRange3];
    _centerBT.titleLabel.numberOfLines = 0;
    _centerBT.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_centerBT setAttributedTitle:titleC forState:UIControlStateNormal];
    _centerBT.layer.cornerRadius = 10.f;
    _centerBT.layer.masksToBounds = YES;
    [_centerBT addTarget:self action:@selector(centerBT:) forControlEvents:UIControlEventTouchUpInside];
    _centerBT.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f  blue:239/255.f  alpha:1];
    [self addSubview:_centerBT];
    
    _rightBT = [[UIButton alloc] initWithFrame:CGRectMake((Width/3) * 2 + 5, 40, Width/3 - 10, 100)];
    NSMutableAttributedString *titleR = [[NSMutableAttributedString alloc] initWithString:@"充值1000元\n即送500国币"];
    NSRange redRange2 = NSMakeRange([[titleR string] rangeOfString:@"即送"].location, [[titleR string] rangeOfString:@"即送"].length);
    [titleR addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange2];
    [titleR addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.f] range:redRange2];
    _rightBT.titleLabel.numberOfLines = 0;
    _rightBT.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_rightBT setAttributedTitle:titleR forState:UIControlStateNormal];
    _rightBT.layer.cornerRadius = 10.f;
    _rightBT.layer.masksToBounds = YES;
    [_rightBT addTarget:self action:@selector(rightBT:) forControlEvents:UIControlEventTouchUpInside];
    _rightBT.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f  blue:239/255.f  alpha:1];
    [self addSubview:_rightBT];
    
    UIButton *RNRe = [[UIButton alloc] initWithFrame:CGRectMake((Width/2) - 100, _leftBT.endPointY + 80, 200, 30)];
    _RNRe = RNRe;
    [_RNRe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _RNRe.titleLabel.textAlignment = NSTextAlignmentCenter;
    _RNRe.layer.cornerRadius = 10.f;
    _RNRe.layer.masksToBounds = YES;
    _RNRe.backgroundColor = [UIColor colorWithRed:231/255.f green:55/255.f blue:54/255.f alpha:1];
    _RNRe.titleLabel.font = [UIFont systemFontOfSize:14];
    [_RNRe addTarget:self action:@selector(RNReClicked) forControlEvents:UIControlEventTouchUpInside];
    [_RNRe setTitle:@"立即充值" forState:UIControlStateNormal];
    [self addSubview:_RNRe];
}

-(void)leftBT:(UIButton *)button
{
    button.backgroundColor = [UIColor grayColor];
    _rightBT.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f  blue:239/255.f  alpha:1];
    _centerBT.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f  blue:239/255.f  alpha:1];
    Money = @"5000";
    button.selected = YES;
    _centerBT.selected = NO;
    _rightBT.selected = NO;
    
//    [self RequestAlipayData:Money];
    
}

-(void)rightBT:(UIButton *)button
{
    button.backgroundColor = [UIColor grayColor];
    _leftBT.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f  blue:239/255.f  alpha:1];
    _centerBT.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f  blue:239/255.f  alpha:1];
     Money = @"1000";
    button.selected = YES;
    _leftBT.selected = NO;
    _centerBT.selected = NO;
//    [self RequestAlipayData:Money];
}
-(void)centerBT:(UIButton *)button
{
    button.backgroundColor = [UIColor grayColor];
    _rightBT.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f  blue:239/255.f  alpha:1];
    _leftBT.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f  blue:239/255.f  alpha:1];
     Money = @"3000";
    button.selected = YES;
    _leftBT.selected = NO;
    _rightBT.selected = NO;
//    [self RequestAlipayData:Money];
}


-(void)RNReClicked
{
    if (_rightBT.selected == NO && _leftBT.selected == NO && _centerBT.selected == NO) {
        
        [AlertTool alertMesasge:@"请选择充值金额" confirmHandler:nil viewController:self.popView];
    }
    SLFChargeMViewController *MC = [[SLFChargeMViewController alloc] init];
    MC.Money = Money;
//    MC.pay_order_sn = pay_order_sn;
//    MC.ali_pay_order_sn = ali_pay_order_sn;
//    MC.notify_url = notify_url;
    
    MC.hidesBottomBarWhenPushed = YES;
    [self.popView.navigationController  pushViewController:MC animated:YES];
    
}

//-(void)RequestAlipayData:(NSString *)money
//{
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD showWithStatus:@"正在创建充值订单···"];
//    NSString *  encryptString;
//    NSString * userId = [NSString stringWithFormat:@"user_id=%@,amount=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],money];
//    encryptString = [userId encryptStringWithKey:KEY];
//    [HttpTool POST:URLDependByBaseURL(@"/Api/User/get_rechargeCard_info") parameters:@{@"token":encryptString} success:^(id responseObject) {
//        
//        ali_pay_order_sn = responseObject[@"result"][@"ali_pay_order_sn"];
//        notify_url = responseObject[@"result"][@"notify_url"];
//        pay_order_sn = responseObject[@"result"][@"pay_order_sn"];
//        
//        [SVProgressHUD dismiss];
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//    }];
//    
//}

@end
