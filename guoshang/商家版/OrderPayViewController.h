//
//  OrderPayViewController.h
//  guoshang
//
//  Created by JinLian on 16/7/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString * orderId;
@property(nonatomic,strong)NSMutableDictionary * dic;
@property(nonatomic,strong)NSMutableDictionary * dataDic;

@end
