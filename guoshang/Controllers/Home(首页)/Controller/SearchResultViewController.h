//
//  SearchResultViewController.h
//  guoshang
//
//  Created by 张涛 on 16/4/6.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ShopBasicViewController.h"

@interface SearchResultViewController : ShopBasicViewController

@property (copy, nonatomic) NSString * urlStr;
@property (copy, nonatomic) NSString * words;
@property (copy, nonatomic) NSDictionary *params;

@end
