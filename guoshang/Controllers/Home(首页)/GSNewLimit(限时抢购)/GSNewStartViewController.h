//
//  GSNewStartViewController.h
//  guoshang
//
//  Created by 时礼法 on 16/11/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSNewStartViewController : UIViewController

@property(nonatomic,weak)UIViewController * popView;
@property(nonatomic,assign)NSInteger page;
@property (nonatomic,strong) NSMutableArray *headerArr;
@property (nonatomic,strong)NSMutableArray *dataArray;


@end
