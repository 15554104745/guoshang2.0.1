//
//  GSNewLimitingViewController.h
//  guoshang
//
//  Created by 时礼法 on 16/11/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnDataBlock)(NSString *timedata);


@interface GSNewLimitingViewController : UIViewController


@property(nonatomic,copy)returnDataBlock ReturnData;
@property(nonatomic,weak)UIViewController * popView;
@property(nonatomic,assign)NSInteger page;
@property (nonatomic,strong) NSMutableArray *headerArr;
@property (nonatomic,strong)NSMutableArray *dataArray;



@end
