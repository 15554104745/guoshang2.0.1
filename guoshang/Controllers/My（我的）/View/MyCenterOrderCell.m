//
//  MyCenterOrderCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/6/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyCenterOrderCell.h"
#import "MyOrderViewController.h"
#import "MyHistoryViewController.h"
#import "MyPropertyViewController.h"
#import "SetUpViewController.h"
//#import "LoginViewController.h"
#import "GSNewLoginViewController.h"
#import "MyCollectViewController.h"
#import "MyPopularizeViewController.h"
@implementation MyCenterOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self addView];
        
    }
    
    return self;
}
-(void)addView{
    UIImageView * wireImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 1.0)];
    wireImage.image = [UIImage imageNamed:@"wire"];
    [self.contentView addSubview:wireImage];
    
    __weak typeof(self.contentView) weakSelf = self.contentView;
    
    UIView * orderView = [[UIView alloc] init];
    [self.contentView addSubview:orderView];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(wireImage.mas_bottom);
        make.height.equalTo(@142.5);
        make.right.equalTo(weakSelf.mas_right);
    }];
    UIImageView * wire2 = [[UIImageView alloc] init];
    wire2.image = [UIImage imageNamed:@"wire"];
    [orderView addSubview:wire2];
    [wire2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(wireImage.mas_bottom).offset(50);
        make.height.equalTo(@1);
        make.right.equalTo(weakSelf.mas_right);
    }];
    
    
    
    UIImageView * orderIcon = [[UIImageView alloc] init];
    orderIcon.image = [UIImage imageNamed:@"dingdan"];
    [orderView addSubview:orderIcon];
    [orderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@15);
        make.top.equalTo(orderView.mas_top).offset(15);
        make.width.equalTo(@21);
        
    }];
    
    LNLabel * myOrderLable = [LNLabel addLabelWithTitle:@"我的订单" TitleColor:WordColor Font:18 BackGroundColor:[UIColor whiteColor]];
    [orderView addSubview:myOrderLable];
    [myOrderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderIcon.mas_right).offset(5);
        make.top.equalTo(wireImage.mas_bottom).offset(15);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"我的订单" AndFont:18]);
    }];
    //
    LNButton * seeAllBtn = [LNButton buttonWithType:UIButtonTypeCustom Title:nil TitleColor:nil Font:1 Target:self AndAction:@selector(toclick:)];
    seeAllBtn.tag = 500;
    [orderView addSubview:seeAllBtn];
    [seeAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderView.mas_left);
        make.right.equalTo(orderView.mas_right);
        make.top.equalTo(orderView.mas_top);
        make.bottom.equalTo(wire2.mas_bottom);
    }];
    //
    UIImageView * seeAllIcon = [[UIImageView alloc] init];
    seeAllIcon.image = [UIImage imageNamed:@"gengduo2"];
    [orderView addSubview:seeAllIcon];
    [seeAllIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(orderView.mas_right).offset(-15);
        make.top.equalTo(wireImage.mas_bottom).offset(20);
        make.height.equalTo(@10);
        make.width.equalTo(@10);
    }];
    
    
    int podding = (Width - 40 * 2)/3;
    LNButton * payMoneyBtn = [LNButton buttonWithType:UIButtonTypeCustom Title:nil TitleColor:nil Font:1 Target:self AndAction:@selector(toclick:)];
    [payMoneyBtn setImage:[UIImage imageNamed:@"fukuan"] forState:UIControlStateNormal];
    payMoneyBtn.tag = 501;
    [orderView addSubview:payMoneyBtn];
    [payMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderView.mas_left).offset(20);
        make.top.equalTo(wire2.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    LNLabel * payMoneylable = [LNLabel addLabelWithTitle:@"待付款" TitleColor:WordColor Font:15 BackGroundColor:[UIColor whiteColor]];
    [orderView addSubview:payMoneylable];
    [payMoneylable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderView.mas_left).offset(20);
        make.top.equalTo(payMoneyBtn.mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    //
    //
    UIButton * disGoodsBtn = [[UIButton alloc] init];
    disGoodsBtn.tag = 502;
    [disGoodsBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [disGoodsBtn setImage:[UIImage imageNamed:@"dier"] forState:UIControlStateNormal];
    [orderView addSubview:disGoodsBtn];
    [disGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payMoneyBtn.mas_left).offset(podding);
        make.top.equalTo(wire2.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    LNLabel * disGoogslable = [LNLabel addLabelWithTitle:@"待发货" TitleColor:WordColor Font:14 BackGroundColor:[UIColor whiteColor]];
    [orderView addSubview:disGoogslable];
    [disGoogslable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payMoneylable.mas_left).offset(podding);
        make.top.equalTo(disGoodsBtn .mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    UIButton * confirmBtn = [[UIButton alloc] init];
    [confirmBtn setImage:[UIImage imageNamed:@"queren1"] forState:UIControlStateNormal];
    confirmBtn.tag = 503;
    [confirmBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(disGoodsBtn.mas_left).offset(podding);
        make.top.equalTo(wire2.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    LNLabel * confirmlLable = [LNLabel addLabelWithTitle:@"待确认" TitleColor:WordColor Font:14 BackGroundColor:[UIColor whiteColor]];
    [orderView addSubview:confirmlLable];
    [confirmlLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(disGoodsBtn.mas_left).offset(podding);
        make.top.equalTo(disGoodsBtn .mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    
    UIButton * completeBtn = [[UIButton alloc] init];
    completeBtn.tag = 504;
    [completeBtn setImage:[UIImage imageNamed:@"wancheng"] forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_left).offset(podding);
        make.top.equalTo(wire2.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    LNLabel * completeLable = [LNLabel addLabelWithTitle:@"已完成" TitleColor:WordColor Font:14 BackGroundColor:[UIColor whiteColor]];
    [orderView addSubview:completeLable];
    [completeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmlLable.mas_left).offset(podding);
        make.top.equalTo(completeBtn .mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    UIImageView * wire3 = [[UIImageView alloc] init];
    wire3.image = [UIImage imageNamed:@"wire"];
    [orderView addSubview:wire3];
    [wire3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderView.mas_left);
        make.top.equalTo(orderView.mas_bottom);
        make.height.equalTo(@1);
        make.right.equalTo(orderView.mas_right);
    }];
   

    
}
#pragma mark - 按钮的点击事件实现
-(void)toclick:(UIButton *)button{
    
    NSInteger count = button.tag - 500;
    NSString * order = [NSString stringWithFormat:@"%ld",(long)count];
    
    //按钮的赋值 让bar的位置改变传值
    if (count<= 4) {
        [[NSUserDefaults standardUserDefaults] setObject:order forKey:@"order"];
    }
    
    if (UserId!=nil) {
        switch (button.tag - 500) {
                
            case 0:{
                
                MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
                orderView.hidesBottomBarWhenPushed = YES;
                orderView.informNum = 0;
                [self.popView.navigationController pushViewController:orderView animated:YES];
                
            }
                break;
                
            case 1:{
                
                MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
                orderView.hidesBottomBarWhenPushed = YES;
                orderView.informNum = 1;
                [self.popView.navigationController pushViewController:orderView animated:YES];
                
            }
                break;
            case 2:{
                MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
                orderView.hidesBottomBarWhenPushed = YES;
                orderView.informNum = 2;
                [self.popView.navigationController pushViewController:orderView animated:YES];
                
            }
                break;
            case 3:{
                
                MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
                orderView.hidesBottomBarWhenPushed = YES;
                orderView.informNum = 3;
                [self.popView.navigationController pushViewController:orderView animated:YES];
                
            }
                break;
            case 4:{
                MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
                orderView.hidesBottomBarWhenPushed = YES;
                orderView.informNum = 4;
                [self.popView.navigationController pushViewController:orderView animated:YES];
                
            }
                break;
                
            case 5:{
                MyCollectViewController * collect = [[MyCollectViewController alloc] init];
                collect.hidesBottomBarWhenPushed = YES;
                [self.popView.navigationController pushViewController:collect animated:YES];
                
            }
                break;
                
            default:
                break;
        }
        
        
    }else{
        
        [AlertTool alertMesasge:@"请先登录" confirmHandler:nil viewController:self.popView];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
