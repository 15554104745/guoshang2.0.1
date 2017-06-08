//
//  AddressTableViewCell.m
//  ChooseLocation
//
//  Created by suntao on 16/9/13.
//  Copyright © 2016年 Hi. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "AddressItem.h"
#import "UIColor+HaxString.h"
@interface AddressTableViewCell ()

@end
@implementation AddressTableViewCell

- (void)setItem:(AddressItem *)item{
    
    _item = item;
    _addressLabel.text = item.name;
    _addressLabel.textColor = item.isSelected ? [UIColor colorWithHexString:@"#E73736"] : [UIColor blackColor] ;
    _selectFlag.hidden = !item.isSelected;
//    _selectFlag.hidden = NO;
}
@end
