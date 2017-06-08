//
//  GSChooseContactManager.h
//  guoshang
//
//  Created by Rechied on 16/9/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSAddAddressViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>

@interface GSAddAddressViewController (ChooseContact)<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate,UINavigationControllerDelegate>

- (void)showAddressManager;
@end
