//
//  GSChackOutOrderUserInfoView.m
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChackOutOrderUserInfoView.h"

@implementation GSChackOutOrderUserInfoView

- (void)updateAddressWithAddressModel:(GSChackOutOrderAddressModel *)orderAddressModel {
    
    self.nameLabel.text = orderAddressModel.consignee;
    self.phoneLabel.text = (orderAddressModel.tel && [orderAddressModel.tel isEqualToString:@""]) ? orderAddressModel.tel : orderAddressModel.mobile;
    self.addressLabel.text = [orderAddressModel getAppendAddress];
    self.hidden = NO;
}


@end
