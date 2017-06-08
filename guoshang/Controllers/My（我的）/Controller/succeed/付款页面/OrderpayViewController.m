//
//  OrderpayViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/31.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "OrderpayViewController.h"
#import "OrderMomeyCell.h"
#import "DispatchGoodsViewController.h"
#import "MyOrderViewController.h"
@interface OrderpayViewController ()

@end

@implementation OrderpayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor;
    self.title = @"付款";
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel * wire = [[UILabel alloc] init];
    wire.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    [headerView addSubview:wire];
    [wire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(headerView.mas_top).offset(2);
        
    }];
    
    LNLabel * momeyLable = [LNLabel addLabelWithTitle:@"订单总金额：" TitleColor:[UIColor colorWithRed:164/255.0 green:164/255.0  blue:164/255.0  alpha:1.0] Font:15.0 BackGroundColor:nil];
    [headerView addSubview:momeyLable];
    
    [momeyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
        make.top.equalTo(wire.mas_bottom).offset(15);
        
    }];
    
    LNLabel * payLable = [LNLabel addLabelWithTitle:nil TitleColor:NewRedColor Font:15.0 BackGroundColor:[UIColor whiteColor]];
    NSString * priceStr;
    CGSize  size;
    if (self.dataDic.count > 0) {
        NSString * str = [NSString stringWithFormat:@"%@",self.dataDic[@"all_price"]];
        CGFloat  price = [str floatValue];
        priceStr = [NSString stringWithFormat:@"%.2f",price];
        size  = [LNLabel calculateLableSizeWithString:priceStr AndFont:16.0];
        payLable.text = priceStr;
        
    }else{

        size  = [LNLabel calculateLableSizeWithString:@"10000" AndFont:16.0];
        
    }
    
    [headerView addSubview:payLable];
    [payLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-10);
        make.width.equalTo(@(size.width));
        make.height.equalTo(@20);
        make.top.equalTo(momeyLable.mas_top);
    }];
    
    
    UILabel * wire1 = [[UILabel alloc] init];
    wire1.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
    [headerView addSubview:wire1];
    [wire1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(payLable.mas_bottom).offset(15);
        
    }];
    
//    UIView * view = [[UIView alloc] init];
//    view.backgroundColor = MyColor;
//    [headerView addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(headerView.mas_left);
//        make.right.equalTo(headerView.mas_right);
//        make.height.equalTo(@15);
//        make.top.equalTo(wire1.mas_bottom);
//        
//    }];
//    
//    UILabel * wire2 = [[UILabel alloc] init];
//    wire2.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
//    [headerView addSubview:wire2];
//    [wire2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(headerView.mas_left);
//        make.right.equalTo(headerView.mas_right);
//        make.height.equalTo(@1);
//        make.top.equalTo(view.mas_bottom);
//        
//    }];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 60;
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
