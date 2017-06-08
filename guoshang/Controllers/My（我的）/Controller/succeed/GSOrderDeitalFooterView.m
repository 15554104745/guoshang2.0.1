//
//  GSOrderDeitalFooterView.m
//  guoshang
//
//  Created by Rechied on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSOrderDeitalFooterView.h"
#import "UIColor+HaxString.h"
#import "UIView+UIViewController.h"
@interface GSOrderDeitalFooterView()
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *moneyLabel;
@property (strong, nonatomic) UILabel *orderStatusLabel;
@property (strong, nonatomic) UIButton *payOrQuitMoneyButton;
@property (nonatomic,strong) GSOrderDetailModel *detailModel;
@end

@implementation GSOrderDeitalFooterView

- (instancetype)initWithHeight:(CGFloat)height orderDetailModel:(GSOrderDetailModel *)detailModel {
    height += 20;
//    if (![detailModel.o_status_desc isEqualToString:@"待付款"]) {
//        height -= 30;
//    }
    self = [super initWithFrame:CGRectMake(0, 10, Width, height)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
            make.top.offset(20);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.height.offset(20);
        }];
        
        [view addSubview:self.leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.top.offset(10);
        }];
        
        if ([detailModel.total.is_exchange_order isEqualToString:@"Y"]) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guobi"]];
            [view addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(10);
                make.size.sizeOffset(CGSizeMake(20, 20));
            }];
            
            [view addSubview:self.moneyLabel];
            _moneyLabel.text = [NSString stringWithFormat:@"x%@ (运费:¥%@)",detailModel.total.total_exchange_integral,detailModel.total.shipping_fee];
            [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(imageView.mas_centerY);
                make.left.equalTo(imageView.mas_right);
                make.right.offset(-20);
            }];
        } else {
            [view addSubview:self.moneyLabel];
            _moneyLabel.text = [NSString stringWithFormat:@"¥%@",detailModel.order_amount];
            [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-20);
                make.top.offset(10);
            }];
        }
        
        [view addSubview:self.orderStatusLabel];
        _orderStatusLabel.text = detailModel.o_status_desc;
        [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20);
            make.top.equalTo(_moneyLabel.mas_bottom).offset(15);
        }];
        
        self.payOrQuitMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_payOrQuitMoneyButton setTitle:@"立即付款" forState:UIControlStateNormal];
//        [_payOrQuitMoneyButton setTitle:@"立即付款" forState:UIControlStateSelected];
        _payOrQuitMoneyButton.layer.cornerRadius = 8.0f;
        _payOrQuitMoneyButton.layer.masksToBounds = YES;
        [_payOrQuitMoneyButton setBackgroundImage:[UIImage imageNamed:@"re_button_red"] forState:UIControlStateNormal];
        [_payOrQuitMoneyButton setBackgroundImage:[UIImage imageNamed:@"re_button_gray"] forState:UIControlStateSelected];
//        [_payOrQuitMoneyButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_payOrQuitMoneyButton];
        
        [_payOrQuitMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-20);
            make.left.offset(40);
            make.right.offset(-40);
            make.height.offset(40);
        }];
        switch ([detailModel.o_status integerValue]) {
            case 1:{
//                待付款
                [_payOrQuitMoneyButton setTitle:@"立即付款" forState:UIControlStateNormal];
                 [_payOrQuitMoneyButton setTitle:@"立即付款" forState:UIControlStateSelected];
                 [_payOrQuitMoneyButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 2:
//            待发货
            case 9:
//            待确认
            case 10:
//            已完成
            {
//                _payOrQuitMoneyButton.hidden = [_detailModel.show_refund isEqualToString:@"N"];
                _payOrQuitMoneyButton.hidden = YES;
                [_payOrQuitMoneyButton setTitle:@"申请退款" forState:UIControlStateNormal];
                [_payOrQuitMoneyButton setTitle:@"申请退款" forState:UIControlStateSelected];
                [_payOrQuitMoneyButton addTarget:self action:@selector(refound:) forControlEvents:UIControlEventTouchUpInside];

                
            }
                break;
                
            default:{
                _payOrQuitMoneyButton.hidden = YES;
            }
                break;
        }
//        if ([detailModel.o_status_desc isEqualToString:@"待付款"]) {
//            _payOrQuitMoneyButton.selected = NO;
//        } else {
//            _payOrQuitMoneyButton.selected = YES;
//            _payOrQuitMoneyButton.hidden = YES;
//        }
    }
    return self;
}

- (void)payButtonClick {
    if (!_payOrQuitMoneyButton.isSelected) {
        if (_payButtonClickBlock) {
            _payButtonClickBlock();
        }
    }
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = @"应付金额";
        _leftLabel.textColor = [UIColor lightGrayColor];
        _leftLabel.font = [UIFont systemFontOfSize:14];
    }
    return _leftLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        //_moneyLabel.text = @"应付金额";
        _moneyLabel.textColor = [UIColor lightGrayColor];
        _moneyLabel.font = [UIFont systemFontOfSize:14];
    }
    return _moneyLabel;
}

- (UILabel *)orderStatusLabel {
    if (!_orderStatusLabel) {
        _orderStatusLabel = [[UILabel alloc] init];
        //_moneyLabel.text = @"应付金额";
        _orderStatusLabel.textColor = [UIColor redColor];
        _orderStatusLabel.font = [UIFont systemFontOfSize:14];
    }
    return _orderStatusLabel;
}
//退款
-(void)refound:(UIButton*)button{
//    __weak typeof(self) weakSelf = self;
    [AlertTool alertTitle:@"温馨提示" mesasge:@"您确定退款吗？" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        
        NSString * encryptString;
        NSString * changeOrder = [NSString stringWithFormat:@"order_id=%@,user_id=%@",_detailModel.order_id,UserId];
        encryptString = [changeOrder encryptStringWithKey:KEY];
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:URLDependByBaseURL(@"/Api/User/my_order_refund") parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            
            if ([str isEqualToString:@"0"]) {
                [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:^(UIAlertAction *action) {
                
                    _payOrQuitMoneyButton.hidden = YES;
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
