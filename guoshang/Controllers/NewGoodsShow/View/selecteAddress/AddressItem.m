//
//  AddressItem.m
//  ChooseLocation
//
//  Created by suntao on 16/9/13.
//  Copyright © 2016年 Hi. All rights reserved.
//

#import "AddressItem.h"

@implementation AddressItem

+ (instancetype)initWithName:(NSString *)name isSelected:(BOOL)isSelected{
    
    AddressItem * item = [[AddressItem alloc]init];
    item.name = name;
    item.isSelected = isSelected;
    return item;
}

@end
