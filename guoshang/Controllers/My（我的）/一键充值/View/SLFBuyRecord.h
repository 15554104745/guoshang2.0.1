//
//  SLFBuyRecord.h
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLFBuyRecord : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *OpTimeL;
@property (weak, nonatomic) IBOutlet UILabel *OpTime;

@property (weak, nonatomic) IBOutlet UILabel *MoneyL;
@property (weak, nonatomic) IBOutlet UILabel *Money;

@property (weak, nonatomic) IBOutlet UILabel *RemarkL;
@property (weak, nonatomic) IBOutlet UILabel *Remark;

@property (weak, nonatomic) IBOutlet UILabel *MRemarkL;
@property (weak, nonatomic) IBOutlet UILabel *Mmark;

@property (weak, nonatomic) IBOutlet UILabel *StatusL;
@property (weak, nonatomic) IBOutlet UILabel *Status;

@property (weak, nonatomic) IBOutlet UIButton *cancell;
@property (weak, nonatomic) IBOutlet UIButton *Sure;

@property (weak, nonatomic) IBOutlet UILabel *CanMoney;


@property (nonatomic,strong) UIViewController *popView;

-(instancetype)initWithFrame:(CGRect)frame;

@end
