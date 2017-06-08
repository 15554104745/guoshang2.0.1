//
//  AddressItem.h
//  ChooseLocation
//
//  Created by suntao on 16/9/13.
//  Copyright © 2016年 Hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressItem : NSObject

@property (nonatomic,copy) NSString * name;

@property (nonatomic,assign) BOOL  isSelected;

+ (instancetype)initWithName:(NSString *)name isSelected:(BOOL)isSelected;

@end
