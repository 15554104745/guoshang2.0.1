//
//  GSAchieveViewController.m
//  guoshang
//
//  Created by 金联科技 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSAchieveViewController.h"
#import "SVProgressHUD.h"
@interface GSAchieveViewController ()
@property (nonatomic,copy) NSString * goods_type;
@property (nonatomic,copy) NSString * order_number;
//商店号
@property (nonatomic,copy) NSString *shop_id;
@end

@implementation GSAchieveViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在加载信息..."];
    [self pullRefresh];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"selectBtn"object:nil];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(textfeildNotice:) name:@"textFiled"object:nil];
    [self defaultSetting];
    [self creatRefresh];
}


-(void)defaultSetting{
    self.goods_type = @"self";
    self.order_number = @"";
    self.page = 1;
    self.shop_id = GS_Business_Shop_id;
//    self.shop_id = @"42";

}


#pragma mark    =====刷新
-(void)creatRefresh{
    
    // 下拉刷新
    self.myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据的接口
        [self pullRefresh];
    }];
    [self.myTableView.header endRefreshing];
    
    // 上拉加载
    self.myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 请求加载接口
        [self pushRefresh];
    }];
    [self.myTableView.footer endRefreshing];
    
    
}

-(void)pullRefresh{
    
    [self.dataArray removeAllObjects];
    self.page = 1;
    [self loadData];
}

-(void)pushRefresh{
    self.page++;
    [self loadData];
}


#pragma mark   -------数据处理
-(void)loadData{
    switch (self.orderType) {
        case GSOrderTypeUser:
            [self createUserData];
            
            break;
        case GSOrderTypeCustomer:
            [self createCustomData];
            break;
            
        default:
            break;
    }
    
}


//客户订单
-(void)createCustomData{
    NSString * encryptString;
  
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,page=%d,goods_type=%@,order_sn=%@,type=finish", self.shop_id,self.page,self.goods_type,self.order_number];
    encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/shop/shopOrderList") parameters:@{@"token":encryptString} success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
            if([responseObject[@"status"] isEqualToString:@"3"]){
           
            NSMutableArray *dataArr = [NSMutableArray array];
            
            for (NSDictionary *dic in responseObject[@"result"]) {
                
                GSCustomOrderModel *model = [GSCustomOrderModel mj_objectWithKeyValues:dic];
                
                [dataArr addObject:model];
                
            }
            [weakSelf.dataArray addObjectsFromArray:dataArr];
                   } else if ([responseObject[@"status"] isEqualToString:@"1"]){
           
            [AlertTool alertMesasge:@"没有更多数据" confirmHandler:nil viewController:self];
          
        } else {
            [AlertTool alertMesasge:@"获取数据失败" confirmHandler:nil viewController:self];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
            [self.myTableView.header endRefreshing];
            [self.myTableView.footer endRefreshing];
            [SVProgressHUD dismiss];
        });
        } failure:^(NSError *error) {
       
        [SVProgressHUD dismiss];
    }];

}
//我的订单
-(void)createUserData{
    
    NSString * encryptString;
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,page=%d,order_state=5", self.shop_id,self.page];
    encryptString = [userId encryptStringWithKey:KEY];
    
    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/Repository/PurchaseOrderList") parameters:@{@"token":encryptString} success:^(id responseObject) {
        //        NSLog(@"1111111111111111%@",responseObject[@"result"]);
        if([responseObject[@"status"] isEqualToString:@"0"]){
            
            NSMutableArray *dataArr = [NSMutableArray array];
            
            for (NSDictionary *dic in responseObject[@"result"]) {
                
                GSMyOrderModel *model = [GSMyOrderModel mj_objectWithKeyValues:dic];
                
                [dataArr addObject:model];
                
            }
            [weakSelf.dataArray addObjectsFromArray:dataArr];
           
        } else if ([responseObject[@"status"] isEqualToString:@"1"]){
           
            [AlertTool alertMesasge:@"没有更多数据" confirmHandler:nil viewController:self];
            
        }else {
            [AlertTool alertMesasge:@"获取数据失败" confirmHandler:nil viewController:self];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.myTableView reloadData];
            [weakSelf.myTableView.mj_header endRefreshing];
            [weakSelf.myTableView.mj_footer endRefreshing];
            [SVProgressHUD dismiss];
        });
        
          } failure:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
    
    
    
}


#pragma mark  -----通知
//通知
- (void)notice:(NSNotification *)notify{
    
//    NSLog(@"%@",notify.userInfo);
    [self.dataArray removeAllObjects];
    NSInteger index =[notify.userInfo[@"selectTag"] integerValue];
    if (index == 0){
        self.goods_type = @"self";
    }else if(index == 1){
        self.goods_type = @"consignment";
    }
    [self loadData];
    
}
- (void)textfeildNotice:(NSNotification*)notify{
    [self.dataArray removeAllObjects];
     self.order_number = @"";
    self.order_number = notify.userInfo[@"order_number"];
    [self loadData];
}

//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    GSFooterView *footerView = [[GSFooterView alloc] initWithFrame:CGRectMake(0, 0, Width, 45) WithOrderType:self.orderType withStatus:nil];
//// 数据处理
//    [GSDataDetailTool orderFooterView:footerView dataWithArray:self.dataArray ofSection:section withOrderType:self.orderType ];
//    
//    __weak typeof(self) weakSelf = self;
//    footerView.loadData = ^(){
////        NSLog(@"点击了");
//        [weakSelf.dataArray removeAllObjects];
//        [weakSelf loadData];
//    };
//    
//    return footerView;
//}




//移除监听
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"selectBtn"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"textFiled"];
}




@end
