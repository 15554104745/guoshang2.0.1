//
//  MyGSViewController.h
//  guoshang
//
//  Created by 宗丽娜 on 16/2/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"
@interface MyGSViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate>

@end


@interface GSCustomCellView : UIView



- (instancetype)initWithIcon:(NSString *)iconName title:(NSString *)title target:(id)target action:(SEL)action;

@end