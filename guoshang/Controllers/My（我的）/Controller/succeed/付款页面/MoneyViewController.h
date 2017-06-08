//
//  MoneyViewController.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpTool.h"
@interface MoneyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString * tokenStr;
@property(nonatomic,strong)NSString * addressStr;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *addressArray;
@property (nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray * totalArray;
@property(nonatomic,assign)BOOL  isGB;
@property(nonatomic, strong)NSMutableArray *shippingArr;
@property(nonatomic, strong)NSMutableDictionary *shiping_id_arr;
@property(nonatomic, strong)NSMutableDictionary *shop_id_arr;

-(void)toConfim;
-(void)createDataMoney;
-(void)settingData;
-(void)createHeaderAndFooter;
@end
