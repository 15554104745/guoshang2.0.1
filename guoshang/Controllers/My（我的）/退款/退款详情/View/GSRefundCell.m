//
//  GSRefundCell.m
//  guoshang
//
//  Created by 金联科技 on 16/10/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSRefundCell.h"

@interface GSRefundCell ()
@property (weak, nonatomic) IBOutlet UILabel *message_type_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *message_info_Label;
//拒绝原因
@property (weak, nonatomic) IBOutlet UILabel *return_reson_Label;
//退款金额
@property (weak, nonatomic) IBOutlet UILabel *return_Money_Label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *money_label_Margin;


@end

@implementation GSRefundCell

+(instancetype)refundCellWithTableView:(UITableView*)tableView{
    GSRefundCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"GSRefundCell" owner:nil options:nil] lastObject];
  
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setConsultModel:(GSConsultModel *)consultModel{
    _consultModel = consultModel;
    self.message_type_label.text = consultModel.type;
    self.time_label.text = consultModel.created_at;
    self.message_info_Label.text = [NSString stringWithFormat:@"%@ %@ %@",consultModel.type,consultModel.operatorL,consultModel.remark];
    self.return_reson_Label.text = [consultModel.reason isEqualToString:@""]?@""
    :[NSString stringWithFormat:@"拒绝理由:%@",consultModel.reason];
    self.money_label_Margin.constant= [consultModel.reason isEqualToString:@""]?18:self.money_label_Margin.constant;
   

}

-(void)setReturn_Money:(NSString *)return_Money{
    _return_Money = return_Money;
    self.return_Money_Label.text = [NSString stringWithFormat:@"退款金额:%@",_return_Money];
    
}

@end
