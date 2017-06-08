//
//  GSRefoundView.m
//  guoshang
//
//  Created by 金联科技 on 16/9/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSRefoundHeaderView.h"
#import "StepProgressView.h"
@interface GSRefoundHeaderView ()
@property (nonatomic,weak)StepProgressView *stepProgressView;
@property (weak, nonatomic) IBOutlet UIView *topView;
//退款时间
@property (weak, nonatomic) IBOutlet UILabel *time_Label;

@property (weak, nonatomic) IBOutlet UILabel *return_Money_Label;

//钱款去向
@property (weak, nonatomic) IBOutlet UILabel *found_label;
@property (weak, nonatomic) IBOutlet UILabel *status_label;

@property (weak, nonatomic) IBOutlet UILabel *money_Label;
@property (weak, nonatomic) IBOutlet UILabel *return_orderId_label;
@property (weak, nonatomic) IBOutlet UILabel *merchants_Label;
@property (weak, nonatomic) IBOutlet UILabel *orderId_Label;
@property (weak, nonatomic) IBOutlet UILabel *order_money_label;
//协商记录
@property (weak, nonatomic) IBOutlet UILabel *negotiation_Label;

@end

@implementation GSRefoundHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
  StepProgressView *stepProgressView   = [StepProgressView progressViewFrame:CGRectMake(0, 0, Width, 50) withTitleArray:@[@"买家申请退款",@"商家处理退款申请",@"退款完成"]];
    [stepProgressView setBackgroundColor:COLOR(201, 201, 201, 0.7)];
    self.stepProgressView = stepProgressView;
    [self.topView addSubview:stepProgressView];
    

}
-(void)setInfoModel:(GSRefundInfoModel *)infoModel{
    _infoModel= infoModel;
    self.time_Label.text = infoModel.add_time;
    self.return_Money_Label.text = infoModel.total_fee;
    self.found_label.text =infoModel.fund;
    self.money_Label.text =infoModel.total_fee;
    self.status_label.text = infoModel.status;
    self.return_orderId_label.text = [NSString stringWithFormat:@"退款编号:%@",infoModel.return_order_sn];
    self.merchants_Label.text =[NSString stringWithFormat:@"商家:%@",infoModel.shop_name];
    self.orderId_Label.text = [NSString stringWithFormat:@"订单编号:%@",infoModel.order_sn];
    self.order_money_label.text = [NSString stringWithFormat:@"订单金额:%@",infoModel.total_fee];
    self.negotiation_Label.hidden =infoModel.consult.count ==0 ?YES:NO;
    if ([infoModel.status isEqualToString:@"已退款"]) {
        
        self.stepProgressView.stepIndex = 2;
    }else if ([infoModel.status isEqualToString:@"待确认"]){
        self.stepProgressView.stepIndex = 0;
    }else {
     self.stepProgressView.stepIndex = 1;
     }
}
@end
