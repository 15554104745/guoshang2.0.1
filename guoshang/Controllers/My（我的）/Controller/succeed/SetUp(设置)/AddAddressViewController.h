//
//  AddAddressViewController.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/8.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAddressModel.h"

// 制定的规则
@protocol SecondViewDelegate <NSObject>
// 想做的事
- (void)sendValue:(MyAddressModel *)model;

@end

@interface AddAddressViewController : UIViewController

@property (nonatomic, strong) MyAddressModel * model;
@property (nonatomic, assign) BOOL temp;

// 设置代理   assign 或者 weak 防止循环引用
@property (nonatomic, weak)  id<SecondViewDelegate> delegate;


@end
