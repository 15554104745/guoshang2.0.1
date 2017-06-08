//
//  GSChooseContactManager.m
//  guoshang
//
//  Created by Rechied on 16/9/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChooseContactManager.h"
#import "UIColor+HaxString.h"

@implementation GSAddAddressViewController (ChooseContact)


- (void)showAddressManager {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        [self showConnactUI];
    } else {
        [self showAddressBookUI];
    }
}

#pragma mark - iOS 9 之前
- (void)showAddressBookUI {
    // 1.创建选择联系人的控制器
    ABPeoplePickerNavigationController *ppnc = [[ABPeoplePickerNavigationController alloc] init];
    
    // 2.设置代理
    ppnc.peoplePickerDelegate = self;
    
    // 3.弹出控制器
    [self presentViewController:ppnc animated:YES completion:nil];
}

#pragma mark - <ABPeoplePickerNavigationControllerDelegate>
// 当用户选中某一个联系人时会执行该方法,并且选中联系人后会直接退出控制器
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    // 1.获取选中联系人的姓名
    CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // (__bridge NSString *) : 将对象交给Foundation框架的引用来使用,但是内存不交给它来管理
    // (__bridge_transfer NSString *) : 将对象所有权直接交给Foundation框架的应用,并且内存也交给它来管理
    NSString *lastname = (__bridge_transfer NSString *)(lastName);
    NSString *firstname = (__bridge_transfer NSString *)(firstName);
    
    NSLog(@"%@ %@", lastname, firstname);
    
    // 2.获取选中联系人的电话号码
    // 2.1.获取所有的电话号码
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phoneCount = ABMultiValueGetCount(phones);
    
    // 2.2.遍历拿到每一个电话号码
    for (int i = 0; i < phoneCount; i++) {
        // 2.2.1.获取电话对应的key
        NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
        
        // 2.2.2.获取电话号码
        NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        
        NSLog(@"%@ %@", phoneLabel, phoneValue);
    }
    
    // 注意:管理内存
    CFRelease(phones);
}



#pragma mark - iOS 9 之后
- (void)showConnactUI {
    CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
    // 2.设置代理
    contactVc.delegate = self;
    // 3.弹出控制器
    contactVc.view.tintColor = [UIColor colorWithHexString:@"e73736"];

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"icon_nav_background"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:contactVc animated:YES completion:nil];
    
    
}

#pragma mark - <CNContactPickerDelegate>
// 当选中某一个联系人时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    /*
    // 1.获取联系人的姓名
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    NSLog(@"%@ %@", lastname, firstname);
     */
    NSString *nameString = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    self.consigneeField.text = nameString;
    if (contact.phoneNumbers.count > 0) {
        
        CNLabeledValue *phoneValue = contact.phoneNumbers[0];
        CNPhoneNumber *phoneNumer = phoneValue.value;
        NSString *phoneNumberString = phoneNumer.stringValue;
        if ([phoneNumberString containsString:@"-"]) {
            phoneNumberString = [phoneNumberString stringByReplacingOccurrencesOfString:@"-" withString:@" "];
        }
        self.phoneNumberField.text = phoneNumberString;
    }
    /*
    // 2.获取联系人的电话号码
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        
        // 2.1.获取电话号码的KEY
        NSString *phoneLabel = labeledValue.label;
        
        // 2.2.获取电话号码
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        
        NSLog(@"%@ %@", phoneLabel, phoneValue);
    }
     */
}

// 当选中某一个联系人的某一个属性时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
}

// 点击了取消按钮会执行该方法
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    
}

#pragma mark - UINavigationViewControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark - 获取当前视图控制器

- (UIViewController *)getCurrentViewController {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end
