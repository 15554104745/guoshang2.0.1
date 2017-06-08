//
//  GSChooseAddressTableViewCell.m
//  guoshang
//
//  Created by Rechied on 16/9/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChooseAddressTableViewCell.h"
#import "UIColor+HaxString.h"

@implementation GSChooseAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setAddressModel:(GSChackOutOrderAddressModel *)addressModel {
    _addressModel = addressModel;
    self.nameLabel.text = addressModel.consignee;
    self.phoneLabel.text = (addressModel.tel && [addressModel.tel isEqualToString:@""]) ? addressModel.tel : addressModel.mobile;;
    self.addressLabel.text = [addressModel getAppendAddress];
    if ([addressModel.is_default boolValue]) {
        self.isDefaultAddressLabel.hidden = NO;
    } else {
        self.isDefaultAddressLabel.hidden = YES;
    }
}


- (IBAction)editButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(editWithAddressInfoWithAddressModel:)]) {
        [_delegate editWithAddressInfoWithAddressModel:self.addressModel];
    }
}

- (void)setTextColorWithColorHexString:(NSString *)hexString {
    self.nameLabel.textColor = [UIColor colorWithHexString:hexString];
    self.phoneLabel.textColor = [UIColor colorWithHexString:hexString];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    if (selected == YES) {
        [self setTextColorWithColorHexString:@"E73736"];
        if (self.chackMarkViewWidth.constant == 0) {
            self.chackMarkViewWidth.constant = 25.0f;
        }
        //self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [self setTextColorWithColorHexString:@"000000"];
        if (self.chackMarkViewWidth.constant != 0) {
            self.chackMarkViewWidth.constant = 0;
        }
        //self.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the view for the selected state
}

@end
