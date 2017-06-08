//
//  BaseItemViewController.h
//  guoshang
//
//  Created by宗丽娜 on 16/2/20.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"
@interface BaseItemViewController : UIViewController<UIPopoverPresentationControllerDelegate,MyPopOverDelegate,UITextFieldDelegate>
@property(nonatomic)UIPopoverPresentationController * pop;
//@property(nonatomic)UITextField * searchBar;
@end
