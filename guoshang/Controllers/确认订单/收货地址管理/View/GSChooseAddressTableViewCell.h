//
//  GSChooseAddressTableViewCell.h
//  guoshang
//
//  Created by Rechied on 16/9/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChackOutOrderAddressModel.h"

@protocol GSChooseAddressTableViewCellDelegate <NSObject>

- (void)editWithAddressInfoWithAddressModel:(GSChackOutOrderAddressModel *)addressModel;

@end

@interface GSChooseAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chackMarkViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *isDefaultAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) id <GSChooseAddressTableViewCellDelegate> delegate;

@property (strong, nonatomic) GSChackOutOrderAddressModel *addressModel;

@end
