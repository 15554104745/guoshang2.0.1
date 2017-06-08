//
//  GSChooseAddressManager.h
//  guoshang
//
//  Created by Rechied on 16/9/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSChackOutOrderAddressModel.h"

@protocol GSChooseAddressManagerDelegate;

@interface GSChooseAddressManager : UIView

@property (weak, nonatomic) id <GSChooseAddressManagerDelegate> delegate;
@property (copy, nonatomic) NSString *selectAddressID;

+ (instancetype)manager;
- (void)showChooseAddressControl;
- (void)showAddNewAddressControl;
- (void)close;
@end

@protocol GSChooseAddressManagerDelegate <NSObject>

@optional
- (void)chooseAddressManager:(GSChooseAddressManager *)manager didSelectAddress:(GSChackOutOrderAddressModel *)addressModel;

- (void)chooseAddressManager:(GSChooseAddressManager *)manager didFinishSelectAddressInfo:(NSDictionary *)addressInfo;


@end
