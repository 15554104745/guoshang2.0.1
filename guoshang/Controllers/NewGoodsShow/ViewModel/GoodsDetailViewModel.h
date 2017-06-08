//
//  GoodsDetailViewModel.h
//  guoshang
//
//  Created by JinLian on 16/9/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsDetailViewController.h"

typedef void(^passValueBlock)(NSDictionary *dic);

@interface GoodsDetailViewModel : NSObject

@property (nonatomic, copy)NSString *goodId;
@property (nonatomic, strong)GoodsDetailViewController *goodsDetailVC;

@property (nonatomic, copy)passValueBlock block;

- (void)passValueWithBlock:(passValueBlock)block;

@end
