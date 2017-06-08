//
//  GSMyOrderHeaderView.m
//  guoshang
//
//  Created by 金联科技 on 16/8/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSMyOrderHeaderView.h"
#import "UIColor+HaxString.h"
#define LabelSize [UIFont systemFontOfSize:12]
#define LabelTextColor [UIColor colorWithHexString:@"595959"]
@interface GSMyOrderHeaderView ()
//订单编号
@property (nonatomic,strong) UILabel *orderLabel;
//显示订单号
@property (nonatomic,strong) UILabel *orderNumberLabel;
//订单状态
@property (nonatomic,strong) UILabel *orderStausLabel;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation GSMyOrderHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.orderLabel];
    [self addSubview:self.orderNumberLabel];
    [self addSubview:self.orderStausLabel];
    [self addSubview:self.lineView];
 
    
}
-(UILabel *)orderLabel{
    if(!_orderLabel){
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.textColor = LabelTextColor;
        _orderLabel.text = @"订单号:";
        _orderLabel.font = LabelSize;
    }
    return _orderLabel;
}
-(UILabel *)orderNumberLabel{
    if (!_orderNumberLabel) {
        _orderNumberLabel =[[UILabel alloc] init];
        _orderNumberLabel.textColor = LabelTextColor;
        _orderNumberLabel.font = LabelSize;
    }
    return _orderNumberLabel;
}

-(UILabel *)orderStausLabel{
    if (!_orderStausLabel) {
        _orderStausLabel = [[UILabel alloc] init];
        _orderStausLabel.font = LabelSize;
        _orderStausLabel.textColor = LabelTextColor;
        _orderStausLabel.textColor = [UIColor redColor];
        _orderStausLabel.textAlignment = NSTextAlignmentRight;
    }
    return _orderStausLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0  blue:229/255.0  alpha:1];
    }
    return _lineView;
}
-(void)layoutSubviews{
    [super  layoutSubviews];
    
      __weak typeof(self) weakSelf = self;
    [self.orderLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.height.mas_equalTo(weakSelf.mas_height);
       // make.width.mas_equalTo(@40);
    
    }];
    [self.orderStausLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.mas_top);
        make.right.equalTo(weakSelf.mas_right).offset(-8);
        make.height.mas_equalTo(weakSelf.mas_height);
       // make.width.mas_equalTo(@75);
    }];
    
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderLabel.mas_right).offset(0);
        make.top.equalTo(weakSelf.mas_top);
        make.height.mas_equalTo(weakSelf.mas_height);
        make.right.equalTo(_orderStausLabel.mas_left).offset(8);
        
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.left.equalTo(weakSelf.mas_left).offset(3);
        make.right.equalTo(weakSelf.mas_right).offset(-3);
        make.height.mas_equalTo(@1);
        
        
    }];

}
-(void)setOrderModel:(GSOrderModel *)orderModel{
    _orderModel = orderModel;
    self.orderNumberLabel.text = orderModel.order_sn;
    self.orderStausLabel.text = orderModel.o_status_desc;
}
@end
