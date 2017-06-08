//
//  GSChackOutOrderUserInfoView.h
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChackOutOrderAddressModel.h"

@interface GSChackOutOrderUserInfoView : UIView



@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (void)updateAddressWithAddressModel:(GSChackOutOrderAddressModel *)orderAddressModel;

@end
