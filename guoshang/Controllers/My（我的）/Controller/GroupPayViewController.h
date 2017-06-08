//
//  GroupPayViewController.h
//  guoshang
//
//  Created by JinLian on 16/8/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupPayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString * addressStr;
@property (nonatomic,strong)NSMutableArray *addressArray;
@property (nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray * totalArray;
@property(nonatomic,assign)BOOL  isGB;


-(void)toConfim;
//-(void)createData;
-(void)settingData;



//从上一界面获取数据
@property (nonatomic, strong)NSDictionary *dataList;
@property (nonatomic, strong)NSDictionary *goodsData;
//@property (nonatomic, strong)NSDictionary *addressDic;

@end
