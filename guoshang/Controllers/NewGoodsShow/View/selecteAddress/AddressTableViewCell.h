//
//  AddressTableViewCell.h
//  ChooseLocation
//
//  Created by suntao on 16/9/13.
//  Copyright © 2016年 Hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressItem;
@interface AddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectFlag;

@property (nonatomic,strong) AddressItem * item;
@end
