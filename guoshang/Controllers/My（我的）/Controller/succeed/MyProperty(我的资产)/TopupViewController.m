//
//  TopupViewController.m
//  guoshang
//
//  Created by 张涛 on 16/3/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "TopupViewController.h"

@interface TopupViewController ()
{
    UIButton * onlineButton;
    UIButton * cardButton;
    UIView * onlineView;
    UIView * cardView;
    UILabel * moneyLabel;
    UITextField * cardNumTF;
    UITextField * pwdNumTF;
    
    NSDictionary * payDic;
    NSString * encryptString;
}
@end

@implementation TopupViewController


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [onlineButton removeFromSuperview];
    
    [cardButton removeFromSuperview];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = MyColor;
    
    self.title = @"金币充值";
    
    self.money = 0;
    [self createUI];
}

-(void)createUI{
        
    //在线充值
    onlineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    onlineView.backgroundColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:1];
    [self.view addSubview:onlineView];
    
    UILabel * titleLabel1 = [[UILabel alloc]init];
    titleLabel1.text = @"充值金额";
    titleLabel1.font = [UIFont boldSystemFontOfSize:15];
    [onlineView addSubview:titleLabel1];
//    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_lessThanOrEqualTo(titleLabel1.superview);
//    }];
    
    UILabel * titleLabel2 = [[UILabel alloc]init];
    titleLabel2.text = @"支付方式";
    titleLabel2.font = [UIFont boldSystemFontOfSize:15];
    [onlineView addSubview:titleLabel2];
    
    moneyLabel = [[UILabel alloc]init];
//    moneyLabel.text = @"￥10.00";
    moneyLabel.textColor = [UIColor redColor];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.font = [UIFont boldSystemFontOfSize:15];
    [onlineView addSubview:moneyLabel];
    
    UIView * moneyView = [[UIView alloc]init];
    moneyView.backgroundColor = [UIColor whiteColor];
    [onlineView addSubview:moneyView];
    
    NSInteger len = Width /3;
    NSArray * arr = [NSArray arrayWithObjects:@"10元",@"50元",@"100元",@"500元",@"1000元",@"5000元", nil];
    for (int i = 0; i<6; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((i%3)*(len-3)+10, i/3*35+5, len-13, 30);
        button.layer.cornerRadius = 8;
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [UIColor redColor].CGColor;
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.tag = 12 +i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [moneyView addSubview:button];
    }
    
    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.backgroundColor = [UIColor whiteColor];
    payButton.tag = 18;
    [payButton setTitle:@"         支付宝支付" forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [payButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [payButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [payButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [onlineView addSubview:payButton];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 22, 22)];
    //    imageView.backgroundColor = [UIColor blueColor];
    [imageView setImage:[UIImage imageNamed:@"zhifubao"]];
    [payButton addSubview:imageView];
    
    UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(Width-20, 10, 10, 15)];
    //    imageView.backgroundColor = [UIColor blueColor];
    [imageView1 setImage:[UIImage imageNamed:@"toPop"]];
    [payButton addSubview:imageView1];
    
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(20);
        make.left.mas_equalTo(self.view.mas_left).with.offset(5);
        make.width.mas_lessThanOrEqualTo(titleLabel1.superview);
        make.height.mas_equalTo(20);
    }];
    
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(moneyView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.view.mas_left).with.offset(5);
        make.width.mas_lessThanOrEqualTo(titleLabel2.superview);
        make.height.mas_equalTo(20);
    }];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel1.mas_centerY);
        make.right.mas_equalTo(moneyView.mas_right).with.offset(-25);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel1.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(Width);
        make.height.mas_equalTo(80);
    }];
    
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel2.mas_bottom).with.offset(8);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(Width);
        make.height.mas_equalTo(40);
    }];

}


-(void)buttonClick:(UIButton *)button{
    switch (button.tag) {
        case 12:
        {
            moneyLabel.text = @"￥10.00";
            self.money = 10;
            NSString * userId = [NSString stringWithFormat:@"user_id=%@,amount=%ld",UserId,(long)self.money];
            encryptString = [userId encryptStringWithKey:KEY];
        }
            break;
        case 13:
        {
            moneyLabel.text = @"￥50.00";
            self.money = 50;
            NSString * userId = [NSString stringWithFormat:@"user_id=%@,amount=%ld",UserId,self.money];
            encryptString = [userId encryptStringWithKey:KEY];
        }
            break;
        case 14:
        {
            moneyLabel.text = @"￥100.00";
            self.money = 100;
            NSString * userId = [NSString stringWithFormat:@"user_id=%@,amount=%ld",UserId,self.money];
            encryptString = [userId encryptStringWithKey:KEY];
        }
            break;
        case 15:
        {
            moneyLabel.text = @"￥500.00";
            self.money = 500;
            NSString * userId = [NSString stringWithFormat:@"user_id=%@,amount=%ld",UserId,self.money];
            encryptString = [userId encryptStringWithKey:KEY];
        }
            break;
        case 16:
        {
            moneyLabel.text = @"￥1000.00";
            self.money = 1000;
            NSString * userId = [NSString stringWithFormat:@"user_id=%@,amount=%ld",UserId,self.money];
            encryptString = [userId encryptStringWithKey:KEY];
        }
            break;
        case 17:
        {
            moneyLabel.text = @"￥5000.00";
            self.money = 5000;
            NSString * userId = [NSString stringWithFormat:@"user_id=%@,amount=%ld",UserId,self.money];
            encryptString = [userId encryptStringWithKey:KEY];
        }
            break;
        case 18:
        {
            if (self.money != 0) {
                __weak typeof(self) weakSelf = self;
                [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=get_recharge_info") parameters:@{@"token":encryptString} success:^(id responseObject) {
                    payDic = @{@"notify_url":responseObject[@"result"][@"notify_url"],
                               @"ordsubject":responseObject[@"result"][@"pay_order_sn"],
                               @"trade_no":responseObject[@"result"][@"ali_pay_order_sn"],
                               @"all_price":responseObject[@"result"][@"amount"],
                               @"order_number":@"1"
                               };
                    NSArray *array = [[UIApplication sharedApplication] windows];
                    UIWindow* win=[array objectAtIndex:0];
                    if (win.hidden == YES) {
                        [win setHidden:NO];
                    }
                    [HttpTool toPayWithAliSDKWith:payDic AndViewController:weakSelf Isproperty:YES IsToPayForProperty:self.isToPay];
                } failure:^(NSError *error) {
                    
                }];
                
 
            }else{
                UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请选择充值金额!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                 target:self
                                               selector:@selector(timerFireMethod:)
                                               userInfo:promptAlert
                                                repeats:NO];
                [promptAlert show];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
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
