//
//  GSAlreadyGroupViewController.m
//  WYP
//
//  Created by 金联科技 on 16/7/21.
//  Copyright © 2016年 RY. All rights reserved.
//

#import "GSAlreadyGroupViewController.h"
#import "GSCustomOrderCell.h"
#import "GSOrderDetailViewController.h"
@interface GSAlreadyGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) int page;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation GSAlreadyGroupViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];

    [self pullRefresh];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self creatRefresh];

   }

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, self.view.frame.size.height-20)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

#pragma    mark ======刷新
-(void)creatRefresh{
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据的接口
        [self pullRefresh];
    }];
    [self.tableView.mj_header endRefreshing];
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 请求加载接口
        [self pushRefresh];
    }];
    [self.tableView.mj_footer endRefreshing];
    
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



-(void)loadData{
    
    NSString * encryptString;
    
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,page=%d,status=end",UserId,self.page++];
    encryptString = [userId encryptStringWithKey:KEY];
//    NSLog(@"%@",encryptString);
    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/Groupon/TuanOrder") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
//        NSLog(@"---%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"10000"]) {
            
            NSArray *orderArray = responseObject[@"result"];
            NSMutableArray *subOrderArray = [NSMutableArray array];
            for (NSDictionary *dic in orderArray) {
                
                GSGroupOrderModel *orderModel = [GSGroupOrderModel mj_objectWithKeyValues:dic];
                [subOrderArray addObject:orderModel];
            }
            [self.dataArray addObjectsFromArray:subOrderArray];
            
            if (orderArray.count < 3) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
        }else if ([responseObject[@"status"] isEqualToString:@"10003"]){
            [AlertTool alertMesasge:@"暂时还没团购" confirmHandler:nil viewController:weakSelf];
        }else{
            [AlertTool alertMesasge:@"数据请求失败，请稍后重试" confirmHandler:nil viewController:weakSelf];
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            
        });
    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSCustomOrderCell *cell =[GSCustomOrderCell createCellWithTableView:tableView];
    cell.orderModel = self.dataArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 165;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GSOrderDetailViewController *orderDetailViewController = ViewController_in_Storyboard(@"Main", @"orderDetailViewController");
    
    GSGroupOrderModel *orderModel =  self.dataArray[indexPath.row];
    orderDetailViewController.order_id  = orderModel.order_id;
//    NSLog(@"==%@",orderModel.order_id);
    orderDetailViewController.orderType = GSOrderTypeGroupOrder;
    [self.navigationController pushViewController:orderDetailViewController animated:YES];
}
@end
