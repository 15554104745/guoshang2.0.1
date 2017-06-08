//
//  ShoppingViewController.m
//  guoshang
//
//  Created by 张涛 on 16/2/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ShoppingViewController.h"
#import "ShoppingTableViewCell.h"
#import "ShoppingCollectionViewCell.h"
#import "GoodsShowViewController.h"
#import "CKAlertViewController.h"

@interface ShoppingViewController ()

@end

@implementation ShoppingViewController

//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if ( self.dataArray.count == 0) {
//        [self dataInit];
//        [self allDataInit];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor;
    self.title = @"国币商城";

    self.url = URLDependByBaseURL(@"?m=Api&c=Category&a=category&is_exchange=1");
//    CKAlertViewController *alert = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"尊敬的客户， 手机版暂时不支持国币商品兑换，请用电脑登录www.ibg100.com进行兑换！"];
//    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"我知道了" handler:^(CKAlertAction *action) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }];
//    
//    [alert addAction:cancel];
//    
//    [self presentViewController:alert animated:NO completion:nil];
    
    [self allDataInit];
    
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
