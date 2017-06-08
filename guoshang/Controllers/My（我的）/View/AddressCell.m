//
//  AddressCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/7.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import "AddressCell.h"
#import "AddAddressViewController.h"
#import "UIView+UIViewController.h"
@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellRow:(NSInteger)cellRow{
    _cellRow = cellRow;
    self.tag = cellRow;
}
-(void)setAddressModel:(MyAddressModel *)addressModel{
    _addressModel = addressModel;
    self.userName.text = addressModel.consignee;
    self.userPhone.text = addressModel.tel;
    
    self.userAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",addressModel.province,addressModel.city,addressModel.district,addressModel.address];
    if (addressModel.is_default.intValue == 1) {
        self.addressLabel.text = @"[默认]";
        
    }else{
        self.addressLabel.hidden = YES;
    }
    

}
- (IBAction)alterbtn:(UIButton *)sender {
    AddAddressViewController * aavc = [[AddAddressViewController alloc]init];
    aavc.temp = YES;
    aavc.model = self.addressModel;
    [self.viewController.navigationController pushViewController:aavc animated:YES];
}
@end
