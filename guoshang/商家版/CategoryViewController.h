//
//  CategoryViewController.h
//  guoshang
//
//  Created by JinLian on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void (^passValueB)(NSString *shopID);

@interface CategoryViewController : UIViewController

@property (nonatomic, copy)passValueB block;

- (void)returnValue:(passValueB)block;


@end
