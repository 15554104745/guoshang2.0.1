//
//  GSChooseAddressViewController.h
//  guoshang
//
//  Created by Rechied on 16/9/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChackOutOrderAddressModel.h"

@protocol GSChooseAddressViewControllerDelegate;


@interface GSChooseAddressViewController : UIViewController

@property (copy, nonatomic) NSString *selectAddressID;
@property (weak, nonatomic) id <GSChooseAddressViewControllerDelegate> delegate;
@end

@protocol GSChooseAddressViewControllerDelegate <NSObject>

- (void)chooseAddressViewControllerDidSelectAddress:(GSChackOutOrderAddressModel *)addressModel;

@end
