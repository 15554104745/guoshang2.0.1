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
#import "GSRefundViewController.h"
#define LabelTextColor [UIColor colorWithHexString:@"595959"]
@interface GSMyOrderFooterView ()
//左边按钮
@property (nonatomic,strong) UIButton *leftBtn;
//右边按钮
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UILabel *orderInfoLabel;
//进度按钮
@property (nonatomic,strong) UIButton *progressBtn;
@end

@implementation GSMyOrderFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        [self createUIWithStatus:@"2"];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.orderInfoLabel];
        [self addSubview:self.rightBtn];
        [self addSubview:self.leftBtn];
//        [self addSubview:self.progressBtn];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.orderInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.right.equalTo(weakSelf.mas_right).offset(-5);
        make.height.mas_equalTo(20);
        
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@80);
        
    }];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightBtn.mas_left).offset(-10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@30);
    }];
//    [self.progressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.mas_left).offset(8);
//        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5);
//        make.width.mas_equalTo(@80);
//        make.height.mas_equalTo(@30);
//    }];
    
    
}
//懒加载
-(UILabel *)orderInfoLabel{
    if (!_orderInfoLabel) {
        _orderInfoLabel = [[UILabel alloc] init];
        
        _orderInfoLabel.font = [UIFont systemFontOfSize:12];
        _orderInfoLabel.textAlignment = NSTextAlignmentRight;
        _orderInfoLabel.textColor = LabelTextColor;
    }
    return _orderInfoLabel;
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

-(UIButton *)progressBtn{
    if (!_progressBtn) {
        _progressBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _progressBtn.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        _progressBtn.layer.cornerRadius = 5;
        _progressBtn.layer.masksToBounds = YES;
        _progressBtn.titleLabel.textColor = [UIColor whiteColor];
        _progressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_progressBtn setTitle:@"退款进度" forState:UIControlStateNormal];
        [_progressBtn addTarget:self action:@selector(prgressAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _progressBtn;
}

-(void)setOrderModel:(GSOrderModel *)orderModel{
    _orderModel = orderModel;
   
    
    GSOrderTotalModel *totalModel = orderModel.total;

    NSString *infoStr= [totalModel.is_exchange_order isEqualToString:@"Y"]?[NSString stringWithFormat:@"共计%@件商品，合计%@个国币(运费%@元)",totalModel.goods_number,totalModel.total_exchange_integral,totalModel.shipping_fee]:[NSString stringWithFormat:@"共计%@件商品，合计￥%@(含运费%@元)",totalModel.goods_number,totalModel.order_amount,totalModel.shipping_fee];
    self.orderInfoLabel.text =infoStr;
    _progressBtn.hidden = [self.orderModel.is_show_detail isEqualToString:@"N"];
    
    switch ([orderModel.o_status integerValue]) {
        case 1:{
//            待付款
            
            [self.rightBtn setTitle:@"付款" forState:UIControlStateNormal];
            [self.rightBtn addTarget:self action:@selector(payMoney:) forControlEvents:UIControlEventTouchUpInside];
            [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.leftBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
             _rightBtn.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
        }
            break;
        case 2:{
//            待发货
            _leftBtn.hidden = YES;
//            _rightBtn.hidden = [_orderModel.is_refund isEqualToString:@"N"];
            _rightBtn.hidden = YES;
            [self.rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [self.rightBtn addTarget:self action:@selector(refound:) forControlEvents:UIControlEventTouchUpInside];
            self.rightBtn.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
            
        }
            break;
        case 9:{
            _leftBtn.hidden = YES;
//            _leftBtn.hidden = [_orderModel.is_refund isEqualToString:@"N"];
//            待确认
            [self.rightBtn setTitle:@"收货" forState:UIControlStateNormal];
            [self.rightBtn addTarget:self action:@selector(toConfirm:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.leftBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [self.leftBtn addTarget:self action:@selector(refound:) forControlEvents:UIControlEventTouchUpInside];
             _rightBtn.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
        }
            
            break;

        case 10:
        {
//            已完成
            _leftBtn.hidden = YES;
            
//            _rightBtn.hidden = [_orderModel.is_refund isEqualToString:@"N"];
//
            [self.rightBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            [self.rightBtn addTarget:self action:@selector(refound:) forControlEvents:UIControlEventTouchUpInside];
            self.rightBtn.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        }
            break;

        default:{
            _leftBtn.hidden = YES;
            _rightBtn.hidden = YES;
        }
            break;
    }
}

#pragma mark ---------------------点击方法---------------
//取消退款
-(void)reformCancelAction:(UIButton *)sender{
    NSLog(@"dfffff");
}
//退款进度
-(void)prgressAction:(UIButton *)button{
 
    GSRefundViewController *refoundInfoVc = [[GSRefundViewController alloc] init];

    refoundInfoVc.order_sn = self.orderModel.order_sn;
    refoundInfoVc.enterType = GSEnteCurrentViewOfBuyers;
    OrderBaseViewController *orderBaseVC =(OrderBaseViewController*)self.viewController;
    [orderBaseVC.delegate allPushToView: refoundInfoVc];
}
//取消订单
-(void)cancelOrder:(UIButton *)button{
//    NSLog(@"取消订单");
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
                    } viewController:weakSelf.viewController];
                    
                }else{
                    [AlertTool alertMesasge:@"取消订单失败，请重新取消" confirmHandler:nil viewController:weakSelf.viewController];
                    
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
                 } viewController:weakSelf.viewController];
              
            }else{
              
                [AlertTool alertMesasge:@"失败请稍后再试" confirmHandler:nil viewController:weakSelf.viewController];
                
            }
            
        }
    } failure:^(NSError *error) {
        
        
        
    }];

}
//付款
-(void)payMoney:(UIButton*)button{
//      NSLog(@"付款");
    OrderpayViewController * money = [[OrderpayViewController alloc] init];
    money.orderId = self.orderModel.order_id;
    
    OrderBaseViewController *orderBaseVC =(OrderBaseViewController*)self.viewController;
    [orderBaseVC.delegate allPushToView:money];

}
//退款
-(void)refound:(UIButton*)button{
    NSLog(@"退款");
    __weak typeof(self) weakSelf = self;
    [AlertTool alertTitle:@"温馨提示" mesasge:@"您确定退款吗？" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        NSString * encryptString;
        NSString * changeOrder = [NSString stringWithFormat:@"order_id=%@,user_id=%@",_orderModel.order_id,UserId];
        encryptString = [changeOrder encryptStringWithKey:KEY];
        
        [HttpTool POST:URLDependByBaseURL(@"/Api/User/my_order_refund") parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            
            if ([str isEqualToString:@"0"]) {
                [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:^(UIAlertAction *action) {
                    weakSelf.loadData();
                } viewController:weakSelf.viewController];
                
            }else{
                [AlertTool alertMesasge: responseObject[@"message"] confirmHandler:nil viewController:weakSelf.viewController];
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
    } cancleHandler:^(UIAlertAction *action) {
        
        
    } viewController:self.viewController];

}
@end
