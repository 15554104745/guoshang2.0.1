//
//  GuoBiDetailTableViewCell.m
//  guoshang
//
//  Created by 陈赞 on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GuoBiDetailTableViewCell.h"

@implementation GuoBiDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 120)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        UILabel * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 60, 15)];
        lb1.text = @"操作时间";
        lb1.font = [UIFont systemFontOfSize:15];
        lb1.textColor = textColour;
        [backView addSubview:lb1];

        self.DateLB = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, Width-90, 15)];
        self.DateLB.text = @"2016-05-25  06:44:09";
         self.DateLB.font = [UIFont systemFontOfSize:15];
         self.DateLB.textColor = textColour;
        [backView addSubview:self.DateLB];

        UILabel * lb2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, 60, 15)];
        lb2.text = @"类型";
        lb2.font = [UIFont systemFontOfSize:15];
        lb2.textColor = textColour;
        [backView addSubview:lb2];

        self.TypeLB = [[UILabel alloc]initWithFrame:CGRectMake(80, 35, Width-90, 15)];
        self.TypeLB.text = @"国币增加";
        self.TypeLB.font = [UIFont systemFontOfSize:15];
        self.TypeLB.textColor = textColour;
        [backView addSubview:self.TypeLB];

        UILabel * lb3 = [[UILabel alloc]initWithFrame:CGRectMake(5, 65, 60, 15)];
        lb3.text = @"金额";
        lb3.font = [UIFont systemFontOfSize:15];
        lb3.textColor = textColour;
        [backView addSubview:lb3];

        self.JineLB = [[UILabel alloc]initWithFrame:CGRectMake(80, 65, Width-90, 15)];
        self.JineLB.text  =@"50.00";
        self.JineLB.font = [UIFont systemFontOfSize:15];
        self.JineLB.textColor = textColour;
        [backView addSubview:self.JineLB];

        UILabel * lb4 = [[UILabel alloc]initWithFrame:CGRectMake(5, 90, 60, 15)];
        lb4.text = @"备注";
        lb4.font = [UIFont systemFontOfSize:15];
        lb4.textColor = textColour;
        [backView addSubview:lb4];

        self.BeizhuLB = [[UILabel alloc]initWithFrame:CGRectMake(80, 90, Width-90, 15)];
        self.BeizhuLB.text = @"编辑订单1016040212034,改变使用预付款支付的金额";
        self.BeizhuLB.font = [UIFont systemFontOfSize:15];
        self.BeizhuLB.textColor = textColour;
        [backView addSubview:self.BeizhuLB];



      

    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
