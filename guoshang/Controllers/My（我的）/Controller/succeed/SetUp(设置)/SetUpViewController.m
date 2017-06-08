

//
//  SetUpViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SetUpViewController.h"
#import "LoginViewController.h"
#import "GSNewLoginViewController.h"
#import "MyAddressViewController.h"
#import "AccountViewController.h"
#import "EditionViewController.h"
#import "HelpCentreViewController.h"
#import "GSChooseAddressViewController.h"
@interface SetUpViewController ()
@property (weak, nonatomic) IBOutlet UIButton *leaveBtn;

@end

@implementation SetUpViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.leaveBtn.layer.cornerRadius = 10;
    self.leaveBtn.clipsToBounds = YES;
}


- (IBAction)buttonClick:(UIButton *)sender {
    
    NSArray * classesArray = @[[GSChooseAddressViewController class],[AccountViewController class],[EditionViewController class],[HelpCentreViewController class]];
    
    //加入进货单
    if (sender.tag - 10 == 5) {
        //
        if (UserId!=nil) {
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"enter"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"GSBusinessUserShopID"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"isBusinessUser"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"isGuide"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Ruser"] != nil) {
                
                
                GSNewLoginViewController *logVC = [[GSNewLoginViewController alloc] init];
                [logVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:logVC animated:YES];
            }             
            
            
        }else{
            [AlertTool alertMesasge:@"您未登录，无需退出" confirmHandler:nil viewController:self];
        }
        
        
        
        
    }else if (sender.tag - 10 == 0 || sender.tag - 10 == 1){
        if (UserId!=nil) {
            if (sender.tag - 10 == 0) {
                
                GSChooseAddressViewController *chooseAddress = ViewController_in_Storyboard(@"Main", @"GSChooseAddressViewController");
                chooseAddress.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chooseAddress animated:YES];
            } else {
                UIViewController * vc = [[classesArray[sender.tag - 10]alloc]
                                         init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            
            [AlertTool alertTitle:@"请先登录哟！" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                GSNewLoginViewController * my =[[GSNewLoginViewController alloc] init];
                
                [self.navigationController pushViewController:my animated:YES];
                
            } viewController:self];
            
        }
        
        
    }else{
        
        if (sender.tag - 10 == 0) {
            
            GSChooseAddressViewController *chooseAddress = ViewController_in_Storyboard(@"Main", @"GSChooseAddressViewController");
            chooseAddress.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chooseAddress animated:YES];
        } else {
            
            UIViewController * vc = [[classesArray[sender.tag - 10]alloc]
                                     init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
