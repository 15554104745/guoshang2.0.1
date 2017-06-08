//
//  GSStoreEditViewController.h
//  guoshang
//
//  Created by Rechied on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSStoreEditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (assign, nonatomic) NSInteger maxStringLength;
@property (copy, nonatomic) NSString *titleText;
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) void(^commitBlock)(NSString *commitStr);

@end
