//
//  GoodsDetailTableViewDataSource.h
//  guoshang
//
//  Created by JinLian on 16/9/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GoodsDetailViewController.h"

@protocol paramasDelegate <NSObject>

- (void)passValueDelegate;

@end


@interface GoodsDetailTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong)NSDictionary *dataListDic;
@property (nonatomic, strong)GoodsDetailViewController *conreoller;
@property (nonatomic,  weak)id<paramasDelegate> delegate;

@end
