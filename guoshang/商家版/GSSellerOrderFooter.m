//
//  GSSellerOrderFooter.m
//  guoshang
//
//  Created by 金联科技 on 16/8/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSSellerOrderFooter.h"
#import "GSSellerOrderHeader.h"
#import "UIView+UIViewController.h"
#import "GSMyOrderPayController.h"
@interface GSSellerOrderFooter ()
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy)  NSString *orderStatus;
@property (nonatomic,assign) GSOrderInfoType orderinfoType;

@end

@implementation GSSellerOrderFooter

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
     __weak typeof(self) weakSelf = self;
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(5);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@80);
        
    }];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top).offset(5);
        make.right.equalTo(_rightBtn.mas_left).offset(-10);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@30);
    }];
}
-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.backgroundColor =  [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        _leftBtn.layer.cornerRadius = 5;
        _leftBtn.titleLabel.textColor = [UIColor whiteColor];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _leftBtn;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
        _rightBtn.layer.cornerRadius = 5;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.titleLabel.textColor = [UIColor whiteColor];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    }
    return _rightBtn;
}


#pragma mark    =====action=====

-(void)setFooterInfoDic:(NSDictionary *)footerInfoDic{
    _footerInfoDic = footerInfoDic;
    self.orderId = footerInfoDic[@"order_id"];
    self.orderinfoType = [footerInfoDic[@"orderType"] intValue];
    self.orderStatus = footerInfoDic[@"status"];
    
    if (self.orderinfoType ==GSOrderTypeCustomer && [self.orderStatus isEqualToString:@"待发货"]) {
//        客户订单中的待发货状态

        [self leftBtnHidden:NO withLeftTitle:@"发货" andLeftAction:@selector(sendGoods:) rightBtnHidden:NO withRightTitle:@"退款" andRightAction:@selector(reimburseMoney:)];
        
    }else if (self.orderinfoType ==GSOrderTypeCustomer && [self.orderStatus isEqualToString:@"待收货"]){
        
//        客户订单中的待收货状态
        [self leftBtnHidden:YES withLeftTitle:@"" andLeftAction:nil rightBtnHidden:NO withRightTitle:@"确认退款" andRightAction:@selector(reimburseMoney:)];
        
    }else if (self.orderinfoType == GSOrderTypeUser && [self.orderStatus intValue] ==5){
//        我的订单中的已完成状态
        [self leftBtnHidden:YES withLeftTitle:@"" andLeftAction:nil rightBtnHidden:NO withRightTitle:@"入库" andRightAction:@selector(truku:)];
    }else if (self.orderinfoType == GSOrderTypeUser && [self.orderStatus intValue] ==1){

//        我的订单中的待付款状态
     [self leftBtnHidden:NO withLeftTitle:@"取消订单" andLeftAction:@selector(cancelOrder:) rightBtnHidden:NO withRightTitle:@"付款" andRightAction:@selector(payMoney:)];
  
        
    }else if (self.orderinfoType == GSOrderTypeUser && [self.orderStatus intValue] ==4){
//        我的订单中的待确认状态
    [self leftBtnHidden:YES withLeftTitle:nil andLeftAction:nil rightBtnHidden:NO withRightTitle:@"确认收货" andRightAction:@selector(takeGoods:)];
        
    }else{
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }
    
    
}
//处理状态
-(void)leftBtnHidden:(BOOL)leftHidden withLeftTitle:(NSString*)leftTitle andLeftAction:(SEL)leftAction rightBtnHidden:(BOOL)rightHidden withRightTitle:(NSString*)rightTitle andRightAction:(SEL)rightAction{
//    显示
    self.leftBtn.hidden = leftHidden;
    self.rightBtn.hidden = rightHidden;
    if (leftHidden == NO) {
        
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        
    [_leftBtn addTarget:self action:leftAction forControlEvents:UIControlEventTouchUpInside];
    }
    if (rightHidden == NO) {
        
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        
    [_rightBtn addTarget:self action:rightAction forControlEvents:UIControlEventTouchUpInside];
    }

    }

   
#pragma mark   ================我的订单
//入库
-(void)truku:(UIButton*)sender
{
//    NSLog(@"入库");
    NSString * encryptString;
    
    NSString *goodID = self.footerInfoDic[@"good_id"];
    
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,order_id=%@,goods_id=%@",GS_Business_Shop_id,self.orderId,goodID];
    encryptString = [userId encryptStringWithKey:KEY];
//    NSLog(@"%@",encryptString);
    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/Repository/addStock") parameters:@{@"token":encryptString} success:^(id responseObject) {
        //        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            UIViewController *vc  = weakSelf.viewController;
            
            [AlertTool alertMesasge:@"入库成功" confirmHandler:nil viewController:vc];
            weakSelf.loadData();
        }else{
            [AlertTool alertMesasge:@"入库失败" confirmHandler:nil viewController: weakSelf.viewController];
        }
        
    } failure:^(NSError *error) {
        
//        NSLog(@"%@",error);
    }];

}
//付款
- (void)payMoney:(UIButton*)sender{
//     NSLog(@"付款");
    //     NSLog(@"付款");
   
    GSMyOrderPayController *payVC = [[GSMyOrderPayController alloc] init];
    payVC.orderID = self.orderId;
    payVC.shopID = self.footerInfoDic[@"shop_id"];
    payVC.all_goods_price = self.footerInfoDic[@"goods_total_price"];
    payVC.all_goods_count = self.footerInfoDic[@"goods_num"];
    payVC.isOrder = NO;
    [self.viewController.navigationController pushViewController:payVC animated:YES];
}
//取消订单
-(void)cancelOrder:(UIButton*)sender{
//     NSLog(@"取消订单");
    NSString * encryptString;
    
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,order_id=%@",GS_Business_Shop_id,self.orderId];
    encryptString = [userId encryptStringWithKey:KEY];
    //    NSLog(@"%@",encryptString);
    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/Repository/CancelPurchaseOrder") parameters:@{@"token":encryptString} success:^(id responseObject) {
        //        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            UIViewController *vc  = weakSelf.viewController;
            
            [AlertTool alertMesasge:@"取消订单成功" confirmHandler:nil viewController:vc];
            weakSelf.loadData();
        } else {
            [AlertTool alertMesasge:@"取消订单失败" confirmHandler:nil viewController:weakSelf.viewController];
        }
        
    } failure:^(NSError *error) {
        
        //        NSLog(@"%@",error);
    }];

}

//确认收货
- (void)takeGoods:(UIButton *)sender{
//     NSLog(@"确认收货");
    NSString * encryptString;
    
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,order_id=%@",GS_Business_Shop_id,self.orderId];
    encryptString = [userId encryptStringWithKey:KEY];
    //    NSLog(@"%@",encryptString);
    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/Repository/ConfirmReceipt") parameters:@{@"token":encryptString} success:^(id responseObject) {
        //        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            [AlertTool alertMesasge:@"成功" confirmHandler:nil viewController:weakSelf.viewController];
        }else{
            [AlertTool alertMesasge:@"收货失败" confirmHandler:nil viewController:weakSelf.viewController];
        }
        weakSelf.loadData();
    } failure:^(NSError *error) {
        
        //        NSLog(@"%@",error);
    }];
    
    

}


#pragma mark   ---------客户订单

//发货
-(void)sendGoods:(UIButton*)sender{
//     NSLog(@"发货");
    NSString * encryptString;
    
    
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,order_id=%@",GS_Business_Shop_id,self.orderId];
    encryptString = [userId encryptStringWithKey:KEY];
//    NSLog(@"%@",encryptString);
    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/Shop/ChangeDeliveryStatus") parameters:@{@"token":encryptString} success:^(id responseObject) {
        //        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            UIViewController *vc  = weakSelf.viewController;
            
            [AlertTool alertMesasge:@"发货成功" confirmHandler:nil viewController:vc];
            weakSelf.loadData();
        }else{
            [AlertTool alertMesasge:@"发货失败" confirmHandler:nil viewController: weakSelf.viewController];
        }
        
    } failure:^(NSError *error) {
        
        //        NSLog(@"%@",error);
    }];
    
 
    
}
//退款
-(void)reimburseMoney:(UIButton*)sender{
//      NSLog(@"退款");
    NSString * encryptString;
    
    
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,order_id=%@",GS_Business_Shop_id,self.orderId];
    encryptString = [userId encryptStringWithKey:KEY];
    //    NSLog(@"%@",encryptString);
    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/Shop/RefundOrder") parameters:@{@"token":encryptString} success:^(id responseObject) {
        //        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            UIViewController *vc  = weakSelf.viewController;
            
            [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:vc];
            weakSelf.loadData();
        }else{
            [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:weakSelf.viewController];
        }
        
    } failure:^(NSError *error) {
        
//                NSLog(@"%@",error);
    }];
    

}




@end
