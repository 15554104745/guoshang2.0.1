//
//  GSMyOrderFooterView.m
//  guoshang
//
//  Created by 金联科技 on 16/8/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSMyOrderFooterView.h"
#import "UIView+UIViewController.h"
#import "OrderpayViewController.h"
#import "OrderBaseViewController.h"
#import "UIColor+HaxString.h"
#import "GSOrderTotalModel.h"
#define LabelTextColor [UIColor colorWithHexString:@"595959"]
@interface GSMyOrderFooterView ()

@property (nonatomic,strong) UIButton *cancelOrderBtn;
@property (nonatomic,strong) UIButton *payMoneyBtn;
@property (nonatomic,strong) UILabel *orderInfoLabel;
//收货
@property (nonatomic,strong) UIButton *confirmGoods;


@end

@implementation GSMyOrderFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        [self createUIWithStatus:@"2"];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.orderInfoLabel];
        [self addSubview:self.confirmGoods];
        [self addSubview:self.cancelOrderBtn];
        [self addSubview:self.payMoneyBtn];
    }
    return self;
}
-(UILabel *)orderInfoLabel{
    if (!_orderInfoLabel) {
        _orderInfoLabel = [[UILabel alloc] init];
        
        _orderInfoLabel.font = [UIFont systemFontOfSize:12];
        _orderInfoLabel.textAlignment = NSTextAlignmentRight;
        _orderInfoLabel.textColor = LabelTextColor;
    }
    return _orderInfoLabel;
}

-(UIButton *)cancelOrderBtn{
    if (!_cancelOrderBtn) {
        _cancelOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelOrderBtn.layer.cornerRadius = 5;
        _cancelOrderBtn.layer.masksToBounds = YES;
        _cancelOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelOrderBtn setBackgroundImage:[UIImage imageNamed:@"huikuang"] forState:UIControlStateNormal];
       [_cancelOrderBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        
    }
    return _cancelOrderBtn;
}
-(UIButton *)payMoneyBtn{
    if (!_payMoneyBtn) {
        _payMoneyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _payMoneyBtn.layer.cornerRadius = 5;
        _payMoneyBtn.layer.masksToBounds = YES;
        _payMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _payMoneyBtn.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
        [_payMoneyBtn addTarget:self action:@selector(payMoney:) forControlEvents:UIControlEventTouchUpInside];
        [_payMoneyBtn setTitle:@"付款" forState:UIControlStateNormal];
        
        
    }
    return _payMoneyBtn;
}
-(UIButton *)confirmGoods{
    if (!_confirmGoods) {
        _confirmGoods =[UIButton buttonWithType:UIButtonTypeCustom];
        _confirmGoods.layer.cornerRadius = 5;
        _confirmGoods.layer.masksToBounds = YES;
        _confirmGoods.titleLabel.font = [UIFont systemFontOfSize:14];
        _confirmGoods.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
        [_confirmGoods addTarget:self action:@selector(toConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmGoods setTitle:@"收货" forState:UIControlStateNormal];

    }
    return _confirmGoods;
}



-(void)layoutSubviews{
    [super layoutSubviews];
   
     __weak typeof(self) weakSelf = self;
    [self.orderInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.right.equalTo(weakSelf.mas_right).offset(-5);
        make.height.mas_equalTo(20);
        
    }];
    [self.payMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@80);
        
    }];
    [self.confirmGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@80);
 
    }];
    [self.cancelOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_payMoneyBtn.mas_left).offset(-10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@30);
    }];
    
}

-(void)setOrderModel:(GSOrderModel *)orderModel{
    _orderModel = orderModel;
   
    
    GSOrderTotalModel *totalModel = orderModel.total;

    NSString *infoStr= [totalModel.is_exchange_order isEqualToString:@"Y"]?[NSString stringWithFormat:@"共计%@件商品，合计%@个国币(运费%@元)",totalModel.goods_number,totalModel.total_exchange_integral,totalModel.shipping_fee]:[NSString stringWithFormat:@"共计%@件商品，合计￥%@(含运费%@元)",totalModel.goods_number,totalModel.order_amount,totalModel.shipping_fee];
    self.orderInfoLabel.text =infoStr;
    if ([orderModel.o_status integerValue] == 1) {
        self.confirmGoods.hidden = YES;
        self.payMoneyBtn.hidden = NO;
        self.cancelOrderBtn.hidden = NO;
    }else if([orderModel.o_status integerValue] ==9){
        self.confirmGoods.hidden = NO;
        self.payMoneyBtn.hidden = YES;
        self.cancelOrderBtn.hidden = YES;
    }else{
        self.confirmGoods.hidden = YES;
        self.payMoneyBtn.hidden = YES;
        self.cancelOrderBtn.hidden = YES;
    }
    
}

#pragma mark ---------------------点击方法---------------
//取消订单
#pragma mark - 取消订单实现的方法
-(void)cancelOrder:(UIButton *)button{
    NSLog(@"取消订单");
    __weak typeof(self) weakSelf = self;
    [AlertTool alertTitle:@"温馨提示" mesasge:@"您确定要取消订单吗？" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        NSString * encryptString;
        NSString * changeOrder = [NSString stringWithFormat:@"order_id=%@,user_id=%@",_orderModel.order_id,UserId];
        encryptString = [changeOrder encryptStringWithKey:KEY];
        
        [HttpTool POST:URLDependByBaseURL(@"/Api/User/my_order_cancel") parameters:@{@"token":encryptString} success:^(id responseObject) {
            
             NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
                if ([str isEqualToString:@"0"]) {
                    [AlertTool alertMesasge:@"取消成功" confirmHandler:^(UIAlertAction *action) {
                        
                         weakSelf.loadData();
                    } viewController:self.viewController];
                    
                    
                }else{
                    [AlertTool alertMesasge:@"取消订单失败，请重新取消" confirmHandler:nil viewController:self.viewController];
                    
                }
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
    } cancleHandler:^(UIAlertAction *action) {
        
        
    } viewController:self.viewController];
}
//收货
-(void)toConfirm:(UIButton*)button{
//    NSLog(@"收货");
    __weak typeof(self) weakSelf = self;
    NSString * encryptString;
    
    NSString * changeOrder = [NSString stringWithFormat:@"order_id=%@,user_id=%@",_orderModel.order_id,UserId ];
    encryptString = [changeOrder encryptStringWithKey:KEY];
    
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/my_order_confirm") parameters:@{@"token":encryptString} success:^(id responseObject) {
        if (responseObject[@"result"]!=nil) {
            
            NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            
            if ([str isEqualToString:@"0"]) {
                 [AlertTool alertMesasge:@"收货成功" confirmHandler:^(UIAlertAction *action) {
                     
                    weakSelf.loadData();
                 } viewController:self.viewController];
              
            }else{
              
                [AlertTool alertMesasge:@"失败请稍后再试" confirmHandler:nil viewController:self.viewController];
                
            }
            
        }
    } failure:^(NSError *error) {
        
        
        
    }];

}
//付款
-(void)payMoney:(UIButton*)button{
      NSLog(@"付款");
    OrderpayViewController * money = [[OrderpayViewController alloc] init];
    money.orderId = self.orderModel.order_id;
    
    OrderBaseViewController *orderBaseVC =(OrderBaseViewController*)self.viewController;
    [orderBaseVC.delegate allPushToView:money];

}



@end
