//
//  SLFRechargeViewController.m
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SLFRechargeViewController.h"
#import "SLFRechargeHeaderView.h"

@interface SLFRechargeViewController ()

@end

@implementation SLFRechargeViewController
{
    SLFRechargeHeaderView *_HView;
    UIImageView *_imageV;
    UIButton *_recharge;
    UIButton *_Rdetail;
    UIButton *_BuyRecord;
    UIButton *_accountSafe;
    UIButton *_bindeCard;
    UILabel *_markLable;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addHeaderUI];
    [self addLongImageView];
    [self addFounctionButton];
}

-(void)addHeaderUI
{
    self.view.backgroundColor = MyColor;
    _HView = [[SLFRechargeHeaderView alloc] initWithFrame:CGRectMake(0, 0,Width, 150)];
    [self.view addSubview:_HView];
    
}

-(void)addLongImageView
{
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, _HView.endPointY + 7, Width, 50)];
    _imageV.image = [UIImage imageNamed:@""];
    _imageV.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_imageV];
}

-(void)addFounctionButton
{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageV.endPointY + 7, Width, 0.5)];
    lable.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lable];
    
    _recharge = [[UIButton alloc] initWithFrame:CGRectMake(0, lable.endPointY + 5, Width/5, 30)];
    [_recharge setTitle:@"一键充值" forState:UIControlStateNormal];
    _recharge.selected = YES;
    [_recharge setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_recharge setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _recharge.titleLabel.font = [UIFont systemFontOfSize:14];
    [_recharge addTarget:self action:@selector(rechargeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recharge];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(_recharge.endPointX, lable.endPointY + 10, 0.5, 20)];
    lable1.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lable1];
    
    _Rdetail = [[UIButton alloc] initWithFrame:CGRectMake(lable1.endPointX, lable.endPointY + 5, Width/5 - 0.5, 30)];
    [_Rdetail setTitle:@"充值卡明细" forState:UIControlStateNormal];
    [_Rdetail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_Rdetail setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _Rdetail.titleLabel.font = [UIFont systemFontOfSize:14];
    [_Rdetail addTarget:self action:@selector(RdetailClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_Rdetail];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(_Rdetail.endPointX, lable.endPointY + 10, 0.5, 20)];
    lable2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lable2];
    
    _BuyRecord = [[UIButton alloc] initWithFrame:CGRectMake(lable2.endPointX, lable.endPointY + 5, Width/5 - 0.5, 30)];
    [_BuyRecord setTitle:@"购买记录" forState:UIControlStateNormal];
    [_BuyRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_BuyRecord setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _BuyRecord.titleLabel.font = [UIFont systemFontOfSize:14];
    [_BuyRecord addTarget:self action:@selector(BuyRecordClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_BuyRecord];
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(_BuyRecord.endPointX, lable.endPointY + 10, 0.5, 20)];
    lable3.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lable3];
    
    _accountSafe = [[UIButton alloc] initWithFrame:CGRectMake(lable3.endPointX, lable.endPointY + 5, Width/5 - 0.5, 30)];
    [_accountSafe setTitle:@"账户安全" forState:UIControlStateNormal];
    [_accountSafe setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_accountSafe setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _accountSafe.titleLabel.font = [UIFont systemFontOfSize:14];
    [_accountSafe addTarget:self action:@selector(accountSafeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_accountSafe];
    
    UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(_accountSafe.endPointX, lable.endPointY + 10, 0.5, 20)];
    lable4.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lable4];
    
    _bindeCard = [[UIButton alloc] initWithFrame:CGRectMake(lable4.endPointX, lable.endPointY + 5, Width/5 - 0.5, 30)];
    [_bindeCard setTitle:@"绑定实体卡" forState:UIControlStateNormal];
    [_bindeCard setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bindeCard setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _bindeCard.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bindeCard addTarget:self action:@selector(bindeCardClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bindeCard];
    
    UILabel *lableEnd = [[UILabel alloc] initWithFrame:CGRectMake(0, _bindeCard.endPointY + 3, Width, 0.5)];
    lableEnd.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lableEnd];
    
    _markLable = [[UILabel alloc] initWithFrame:CGRectMake(0, _bindeCard.endPointY + 2, Width/5, 1)];
    _markLable.backgroundColor = [UIColor redColor];
    [self.view addSubview:_markLable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark ======================== 当button被点击的时候 ================
-(void)rechargeClicked:(UIButton *)button
{
    _BuyRecord.selected = NO;
    _Rdetail.selected = NO;
    _bindeCard.selected = NO;
    _accountSafe.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        _markLable.frame = CGRectMake(0, _bindeCard.endPointY + 2, Width/5, 1);
//        [_Rdetail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
    
    NSLog(@"一键充值");
}

-(void)RdetailClicked:(UIButton *)button
{
    button.selected = YES;
    _recharge.selected = NO;
    _bindeCard.selected = NO;
    _BuyRecord.selected = NO;
    _accountSafe.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        _markLable.frame = CGRectMake((Width/5), _bindeCard.endPointY + 2, Width/5, 1);
    }];
    NSLog(@"充值卡明细");
}

-(void)BuyRecordClicked:(UIButton *)button
{
    _recharge.selected = NO;
    _Rdetail.selected = NO;
    _bindeCard.selected = NO;
    _accountSafe.selected = NO;
     button.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        _markLable.frame = CGRectMake((Width/5) *2, _bindeCard.endPointY + 2, Width/5, 1);
    }];
    NSLog(@"交易记录");
}

-(void)accountSafeClicked:(UIButton *)button
{
     button.selected = YES;
    _BuyRecord.selected = NO;
    _Rdetail.selected = NO;
    _bindeCard.selected = NO;
    _recharge.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        _markLable.frame = CGRectMake((Width/5) *3, _bindeCard.endPointY + 2, Width/5, 1);
    }];
    NSLog(@"账户安全");
}

-(void)bindeCardClicked:(UIButton *)button
{
     button.selected = YES;
    _BuyRecord.selected = NO;
    _Rdetail.selected = NO;
    _recharge.selected = NO;
    _accountSafe.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        _markLable.frame = CGRectMake((Width/5) *4, _bindeCard.endPointY + 2, Width/5, 1);
    }];
    NSLog(@"绑定实体卡");
}



@end
