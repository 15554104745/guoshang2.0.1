//
//  GSChooseAddressInfoCell.m
//  guoshang
//
//  Created by Rechied on 16/9/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChooseAddressInfoCell.h"
#import "UIColor+HaxString.h"

@implementation GSChooseAddressInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setAddressModel:(GSChackOutOrderAddressModel *)addressModel {

    self.nameLabel.text = addressModel.consignee;
    self.phoneLabel.text = (addressModel.tel && [addressModel.tel isEqualToString:@""]) ? addressModel.tel : addressModel.mobile;;
    self.addressLabel.text = [addressModel getAppendAddress];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected == YES) {
        [self setTextColorWithColorHexString:@"E73736"];
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [self setTextColorWithColorHexString:@"4D4D4D"];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)setTextColorWithColorHexString:(NSString *)hexString {
    self.nameLabel.textColor = [UIColor colorWithHexString:hexString];
    self.phoneLabel.textColor = [UIColor colorWithHexString:hexString];
    self.addressLabel.textColor = [UIColor colorWithHexString:hexString];
}




@end
