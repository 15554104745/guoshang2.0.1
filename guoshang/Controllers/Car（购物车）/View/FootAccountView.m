//
//  FootAccountView.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "FootAccountView.h"

@implementation FootAccountView
+(id)createFootAccountView{
    return [[NSBundle mainBundle]loadNibNamed:@"FootAccountView" owner:nil options:nil];
}


- (IBAction)allSelectBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedBtn:)]) {
        [self.delegate didSelectedBtn:sender];
    }
}

- (IBAction)toPayBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didPaySelectedBtn:)]) {
        [self.delegate didPaySelectedBtn:sender];
    }

}

//按钮角度
-(void)awakeFromNib
{
    [super awakeFromNib];
    _payBtn.layer.cornerRadius=5;
    _payBtn.selected=YES;
}
@end
