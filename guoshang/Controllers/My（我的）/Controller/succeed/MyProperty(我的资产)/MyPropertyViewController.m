//
//  MyPropertyViewController.m
//  guoshang
//
//  Created by 张涛 on 16/3/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyPropertyViewController.h"
#import "GoldViewController.h"
#import "GuoCoinViewController.h"
#import "TopupViewController.h"
#import "CashViewController.h"
#import "MyGuoBiViewController.h"
@interface MyPropertyViewController ()
{
    NSString * pay_points;
    NSString * user_money;
}
@end

@implementation MyPropertyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的金币";
    
    self.view.backgroundColor = MyColor;
    
    NSString * userId = [NSString stringWithFormat:@"user_id=%@",UserId];
    NSString * encryptString = [userId encryptStringWithKey:KEY];
    
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=myprofile") parameters:@{@"token":encryptString} success:^(id responseObject) {
        self.guoCoinLabel.text = responseObject[@"result"][@"pay_points"];
        self.goldLabel.text = responseObject[@"result"][@"user_money"];
    } failure:^(NSError *error) {
        
    }];
    
    
    
    [self.gold1 setImage:[UIImage imageNamed:@"jinbi"]];
    [self.gold2 setImage:[UIImage imageNamed:@"jinbi"]];
    [self.gold3 setImage:[UIImage imageNamed:@"jinbi"]];
    [self.guobi setImage:[UIImage imageNamed:@"guobi"]];
    
    [self.more1 setImage:[UIImage imageNamed:@"toPop"]];
    [self.more2 setImage:[UIImage imageNamed:@"toPop"]];
    [self.more3 setImage:[UIImage imageNamed:@"toPop"]];
    [self.more4 setImage:[UIImage imageNamed:@"toPop"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goldButton:(id)sender {
//    GoldViewController * gvc = [[GoldViewController alloc]init];
//    [self.navigationController pushViewController:gvc animated:YES];
}

- (IBAction)guoCoinButton:(id)sender {
    MyGuoBiViewController * cz = [[MyGuoBiViewController alloc]init];
    [self.navigationController pushViewController:cz animated:YES];
}

- (IBAction)topupButton:(id)sender {
    TopupViewController * tvc = [[TopupViewController alloc]init];
    tvc.isToPay = NO;
    [self.navigationController pushViewController:tvc animated:YES];
}

- (IBAction)cashButton:(id)sender {
    CashViewController * cvc = [[CashViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
}
@end

