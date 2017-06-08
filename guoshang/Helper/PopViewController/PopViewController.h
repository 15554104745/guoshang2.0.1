//
//  PopViewController.h
//  guoshang
//
//  Created by 宗丽娜 on 16/2/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyPopOverDelegate <NSObject>

-(void)tabbarControllerSelectIndex:(NSInteger)number;

@end

@interface PopViewController : UITableViewController


@property(nonatomic,weak)id<MyPopOverDelegate>delegate;
@end

