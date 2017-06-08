//
//  OrderBaseViewController.m
//  guoshang
//
//  Created by宗丽娜 on 16/3/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "OrderBaseViewController.h"
#import "GSMyOrderFooterView.h"
static NSString *orderCellReuseIdentifier = @"GSWillPayOrderTableViewCell";

@interface OrderBaseViewController ()


@end

@implementation OrderBaseViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!= nil) {
        
        [self createTableView];
        [self loadDataWithRefreshType:MJRefreshTypeClear];
    }else{
        
        [AlertTool alertMesasge:@"没有登录，请先登录" confirmHandler:nil viewController:self];
    }
   
}


- (NSString *)payStatus {
    if (!_payStatus) {
        NSString *classString = NSStringFromClass([self class]);
        
        NSDictionary *dic = @{@"AllOrderViewController":@"all",@"PayMoneyViewController":@"unpay",@"DispatchGoodsViewController":@"wait_deliver",@"ConfirmViewController":@"wait_confirm",@"AccomplishViewController":@"finish"};
        _payStatus = dic[classString];
    }
    return _payStatus;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}

#pragma  -----------subView------------
-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-100) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GSWillPayOrderTableViewCell" bundle:nil] forCellReuseIdentifier:orderCellReuseIdentifier];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithRefreshType:MJRefreshTypeClear];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataWithRefreshType:MJRefreshTypeAdd];
    }];
    
    [self.view addSubview:self.tableView];
    
}
#pragma -----------loadData----------------------

-(void)loadDataWithRefreshType:(MJRefreshType)refreshType {
    if (refreshType == MJRefreshTypeClear) {
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:UserId forKey:@"user_id"];
    [params setObject:self.payStatus forKey:@"type"];
    [params setObject:refreshType == MJRefreshTypeClear ? @"1" : [NSString stringWithFormat:@"%zi",self.dataSourceArray.count / 5+ 1]  forKey:@"page"];
    
//    NSLog(@"%@",[params addSaltParamsDictionary]);
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/User/my_order_list") parameters:[params addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        
        if (refreshType == MJRefreshTypeClear) {
            [MBProgressHUD hideHUDForView:nil animated:YES];
        }
        
        if (responseObject) {
            
            if (refreshType == MJRefreshTypeClear) {
                [weakSelf.tableView.mj_footer resetNoMoreData];
                weakSelf.dataSourceArray = [GSOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                if (weakSelf.dataSourceArray.count < 10) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                NSArray *array = [GSOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                [weakSelf.dataSourceArray addObjectsFromArray:array];
                [weakSelf.tableView.mj_footer endRefreshing];
                if (array.count < 10) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            
        } else {
            [weakSelf.dataSourceArray removeAllObjects];
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        if ([weakSelf.tableView.mj_footer isRefreshing]) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
        
    }];

}






#pragma mark  ------------------tableViewDeleget/tableViewDatasource----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSourceArray.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section < self.dataSourceArray.count) {
        GSOrderModel *orderModel = self.dataSourceArray[section];
        return orderModel.shop_list.count;
    } else {
        return 0;
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.dataSourceArray.count) {
        GSOrderModel *orderModel = self.dataSourceArray[indexPath.section];
        if (indexPath.row < orderModel.shop_list.count) {
            GSOrderGoodsListModel *orderListModel = orderModel.shop_list[indexPath.row];
            return 30 + 90 * orderListModel.goods_list.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSWillPayOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.section < self.dataSourceArray.count) {
        GSOrderModel *orderModel = self.dataSourceArray[indexPath.section];
        if (indexPath.row < orderModel.shop_list.count) {
            cell.goodsListModel = orderModel.shop_list[indexPath.row];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < self.dataSourceArray.count) {
        GSOrderModel *model = self.dataSourceArray[indexPath.section];
        GSOrderDetailViewController *orderDeatilViewController = ViewController_in_Storyboard(@"Main", @"orderDetailViewController");
        orderDeatilViewController.order_id = model.order_id;
       
        if ([_delegate respondsToSelector:@selector(allPushToView:)]) {
            [_delegate allPushToView:orderDeatilViewController];
            
        }
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GSMyOrderHeaderView *header = [[GSMyOrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, Width, 30)];

    header.orderModel = self.dataSourceArray[section];
    return header;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    GSMyOrderFooterView *footer = [[GSMyOrderFooterView alloc] initWithFrame:CGRectMake(0, 0, Width, 60)];
    footer.orderModel =self.dataSourceArray[section];
    //    回调
    __weak typeof(self) weakSelf = self;
    footer.loadData = ^(){
    [weakSelf loadDataWithRefreshType:MJRefreshTypeClear];
      
    };

    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//      GSOrderModel *model = self.dataSourceArray[section];
//    if ([model.o_status intValue] == 1 ||[model.o_status intValue] ==9) {
//        
//        return 70;
//    }
//    return 0;
    return 70;
}
@end
