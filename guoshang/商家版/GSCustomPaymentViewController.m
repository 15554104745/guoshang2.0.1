//
//  GSCustomPaymentViewController.m
//  guoshang
//
//  Created by 金联科技 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCustomPaymentViewController.h"
#import "SVProgressHUD.h"
#import "GSBusinessMineViewController.h"

@interface GSCustomPaymentViewController ()
//商品类型
@property (nonatomic,copy) NSString  *goods_type;
//商品订单号
@property (nonatomic,copy) NSString *order_number;
//商店号
@property (nonatomic,copy) NSString *shop_id;
@end

@implementation GSCustomPaymentViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在加载信息..."];
    [self pullRefresh];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"selectBtn"object:nil];
    [center addObserver:self selector:@selector(textfeildNotice:) name:@"textFiled"object:nil];
    [self defaultSetting];

    [self creatRefresh];
    
}

- (void)defaultSetting{
    self.goods_type = @"self";
    self.order_number = @"";
    self.page =1;
    self.shop_id = GS_Business_Shop_id;
//    self.shop_id = @"42";

    
}

#pragma  mark    =======通知
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

#pragma  mark    =======加载数据
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
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,page=%d,goods_type=%@,order_sn=%@,type=un_pay",self.shop_id,self.page,self.goods_type,self.order_number];
    encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/shop/shopOrderList") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
            if([responseObject[@"status"] isEqualToString:@"3"]){
            
            NSMutableArray *dataArr = [NSMutableArray array];
            
            for (NSDictionary *dic in responseObject[@"result"]) {
                
                GSCustomOrderModel *model = [GSCustomOrderModel mj_objectWithKeyValues:dic];
                
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
//我的订单
-(void)createUserData{
    
    NSString * encryptString;
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,page=%d,order_state=1", self.shop_id,self.page];
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



#pragma  mark    =======刷新
-(void)creatRefresh{
    
    // 下拉刷新
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据的接口
        [self pullRefresh];
    }];
    [self.myTableView.mj_header endRefreshing];
    
    // 上拉加载
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 请求加载接口
        [self pushRefresh];
    }];
    [self.myTableView.mj_footer endRefreshing];
    
    
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
#pragma mark  =========delegate=======
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
////    创建
//    GSFooterView *footerView = [[GSFooterView alloc] initWithFrame:CGRectMake(0, 0, Width, 40)  WithOrderType:self.orderType withStatus:nil];
//    //    为footerView设置数据
//    [GSDataDetailTool orderFooterView:footerView dataWithArray:self.dataArray ofSection:section withOrderType:self.orderType];
//    
//    __weak typeof(self) weakSelf = self;
//    footerView.loadData = ^(){
//        [weakSelf.dataArray removeAllObjects];
//        [weakSelf loadData];
//    };
//    return footerView;
//}



//移除监听
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"selectBtn"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"textFiled"];
}




@end
