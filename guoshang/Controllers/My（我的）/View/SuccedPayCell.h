//
//  SuccedPayCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/4/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccedPayCell : UITableViewCell
@property(nonatomic,strong)NSArray * array;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *payStyleLbale;
//@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *SleteBtn;//选中图片
- (IBAction)seleBtn:(UIButton *)sender;
@property(nonatomic,strong) UILabel *moneyLabel;

@end
