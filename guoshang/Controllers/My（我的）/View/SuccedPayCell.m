//
//  SuccedPayCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/4/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SuccedPayCell.h"

@implementation SuccedPayCell
-(void)setArray:(NSArray *)array{
    
    _array = array;
    
    [self settingData];
}
-(void)settingData{
    _iconImage.image = [UIImage imageNamed:_array[0]];
    _payStyleLbale.text = _array[1];
    
    if (_array.count>= 3) {
        self.moneyLabel.text = _array[2];
        NSLog(@"%@",self.moneyLabel.text);
    }else{
        self.moneyLabel.hidden = YES;
    }
//    [_SleteBtn setBackgroundImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateNormal];
    
    
    [_SleteBtn setBackgroundImage:[UIImage imageNamed:@"payxuanzhong"] forState:UIControlStateSelected];
    
    
}

-(UILabel *)moneyLabel
{
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
    }
    return _moneyLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)seleBtn:(UIButton *)sender {
    //sender.selected = !sender.selected;
}
@end
