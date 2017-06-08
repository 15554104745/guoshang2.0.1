//
//  GSChooseAddressInfoCell.h
//  guoshang
//
//  Created by Rechied on 16/9/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChackOutOrderAddressModel.h"

@interface GSChooseAddressInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) GSChackOutOrderAddressModel *addressModel;

@end
