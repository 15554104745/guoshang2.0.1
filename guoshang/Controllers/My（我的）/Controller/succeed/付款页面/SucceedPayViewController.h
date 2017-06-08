//
//  SucceedPayViewController.h
//  guoshang
//
//  Created by 宗丽娜 on 16/4/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GSOrderDetailViewController.h"
typedef void(^MoneyBlock)(NSString *);
@interface SucceedPayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) GSOrderType orderType;
@property (nonatomic,strong)MoneyBlock block;
@property(nonatomic,strong)NSString * orderId;
@property(nonatomic,strong)NSMutableDictionary * dic;
@property(nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic,strong)UILabel *showLabel;
- (void)paySuccessWithOrderType:(GSOrderType)orderType withPageIndex:(NSInteger) pageIndex;
@end
