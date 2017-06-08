//
//  GSReimburse ListViewController.m
//  guoshang
//
//  Created by 金联科技 on 16/9/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSReimburseListViewController.h"
#import "ShopStateView.h"
#import "GSReimburseCell.h"
#import "GSRefundViewController.h"
#import "MBProgressHUD.h"
#import "RequestManager.h"
#import "GSReimburseModel.h"
@interface GSReimburseListViewController ()<UITextFieldDelegate,ShopStateViewDelegate,UITableViewDelegate,UITableViewDataSource>
//搜索
@property (nonatomic,strong) UITextField *searchField;
//状态
@property (nonatomic,strong) ShopStateView *stateView;
//table
@property (nonatomic,strong) UITableView *tableView;
//table
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int state;
@property (nonatomic,strong) NSArray *statusArray;

@property (nonatomic,strong) UIView *customNavigitonBar;

@end

@implementation GSReimburseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSearchField];
    [self.view addSubview:self.customNavigitonBar];
    [self.view addSubview:self.stateView];
    [self.view addSubview:self.tableView];
    [self loadDataWithRefreshType:MJRefreshTypeClear WithType:self.statusArray[self.state] ];
  
    
}
-(UIView *)customNavigitonBar{
    if (!_customNavigitonBar) {
        _customNavigitonBar = [[UIView alloc] init];
        _customNavigitonBar.frame = CGRectMake(0, 0, Width, 64);
        _customNavigitonBar.backgroundColor = GS_Business_NavBarColor;
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 20, 48, 48);
        
        [backBtn setImage:[UIImage imageNamed:@"back_jt"] forState:UIControlStateNormal];
        
        [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
        [_customNavigitonBar addSubview:backBtn];
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        CGFloat titleX =CGRectGetMaxX(backBtn.frame);
        CGFloat titleY= 20;
        CGFloat titleW= Width-backBtn.frame.size.width*2;
        CGFloat titleH = 44;
        titleLabel.frame = CGRectMake(titleX, titleY,titleW,titleH);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"退款管理";
        [_customNavigitonBar addSubview:titleLabel];
    }
    return _customNavigitonBar;
}
-(NSArray *)statusArray{
    if (!_statusArray) {
        _statusArray = @[@"",@"WAIT",@"DEAL",@"PASS",@"REJECT",@"CANCEL"];
    }
    return _statusArray;
}
-(UITextField *)searchField{
    if (!_searchField) {
        _searchField =[[UITextField alloc]initWithFrame:CGRectMake(5, 74, self.view.bounds.size.width-10, 35)];
        _searchField.borderStyle = UITextBorderStyleRoundedRect;
        _searchField.textAlignment = NSTextAlignmentRight;
        _searchField.placeholder = @"搜索订单号";
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.delegate = self;

    }
    return _searchField;
}

- (void)createSearchField {
   
    //rightView
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 35)];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 1, 25)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha=.5f;
    [rightView addSubview:line];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 2.5, 40, 30)];
    //    searchBtn.backgroundColor = [UIColor redColor];
    [searchBtn setImage:[UIImage imageNamed:@"fangdajing"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:searchBtn];
    
    self.searchField.rightView = rightView;
    self.searchField .rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.searchField];
}

-(ShopStateView *)stateView{
    if (!_stateView) {
        _stateView = [[ShopStateView alloc]init];
        _stateView.frame =CGRectMake(0, CGRectGetMaxY(self.searchField.frame), self.view.bounds.size.width, 36);
        _stateView.titleSize = 14;
        _stateView.titles = @[@"全部",@"待确认",@"处理中",@"已退款",@"已拒绝",@"已取消"];
        _stateView.delegate = self;
    }
    return _stateView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.stateView.frame), Width, Height-CGRectGetMaxY(self.stateView.frame)-20)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
         __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataWithRefreshType:MJRefreshTypeClear WithType:self.statusArray[self.state]];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            [weakSelf loadDataWithRefreshType:MJRefreshTypeAdd WithType:self.statusArray[self.state] ];
        }];

        
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)loadDataWithRefreshType:(MJRefreshType)refreshType WithType:(NSString *)statusType {
    if (refreshType == MJRefreshTypeClear) {
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:GS_Business_Shop_id forKey:@"shop_id"];
    [params setObject:statusType forKey:@"order_state"];
    [params setObject:self.searchField.text forKey:@"order_id"];

    [params setObject:refreshType == MJRefreshTypeClear ? @"1" : [NSString stringWithFormat:@"%zi",self.dataArray.count / 5 + 1]  forKey:@"page"];
    
    NSLog(@"%@",[params addSaltParamsDictionary]);
        __weak typeof(self) weakSelf = self;
        [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/ShopReturnOrder/returnList") parameters:[params addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
            NSLog(@"%@",responseObject);
            if (refreshType == MJRefreshTypeClear) {
                [MBProgressHUD hideHUDForView:nil animated:YES];
            }
    
            if (responseObject) {
    
                if (refreshType == MJRefreshTypeClear) {
                    [weakSelf.tableView.mj_footer resetNoMoreData];
                    weakSelf.dataArray = [GSReimburseModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
    
                } else {
                    NSArray *array = [GSReimburseModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                    [weakSelf.dataArray addObjectsFromArray:array];
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
    
                if ([responseObject[@"result"] count] < 10) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [weakSelf.dataArray removeAllObjects];
            }
    
            [weakSelf.tableView.mj_header endRefreshing];
            if ([weakSelf.tableView.mj_footer isRefreshing]) {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView reloadData];
           
            
        }];
    
    
}

#pragma mark   -----------代理------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSReimburseCell *cell = [GSReimburseCell cellWithTabelView:tableView];
     __weak typeof(self) weakSelf = self;
    cell.btnStatus =^(NSString* status,NSString *returnId){
        NSLog(@"%@,%@",status,returnId);
        [weakSelf loadDataWithStatusOfBtnClick:status withReturnOrdersn:returnId];
        
    };
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 152;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GSRefundViewController *refoundInfoVc = [[GSRefundViewController alloc] init];
    GSReimburseModel * model = self.dataArray[indexPath.row];
    refoundInfoVc.order_sn =model.order_sn;
    [self.navigationController pushViewController:refoundInfoVc animated:YES];
}
- (void)didSelectedItem:(int)index{
    NSLog(@"%d",index);
    self.state = index;
    [self loadDataWithRefreshType:MJRefreshTypeClear WithType:self.statusArray[self.state]];
}
//搜索按钮
- (void)searchAction:(UIButton *)searchBtn {

    [self loadDataWithRefreshType:MJRefreshTypeClear WithType:self.statusArray[self.state] ];
}
//返回
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    NSLog(@"return");
    
    return YES;
}

-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadDataWithStatusOfBtnClick:(NSString*)btnStatus withReturnOrdersn:(NSString*)returnId{
    
    NSString * encryptString;
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,status=%@,order_id=%@",GS_Business_Shop_id,btnStatus,returnId];
    encryptString = [userId encryptStringWithKey:KEY];
         __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/ShopReturnOrder/changeReturn") parameters:@{@"token":encryptString} success:^(id responseObject) {
        NSLog(@"----%@",responseObject);
        if([responseObject[@"status"] isEqualToString:@"1"]){
            [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:^(UIAlertAction *action) {
                [weakSelf loadDataWithRefreshType:MJRefreshTypeClear WithType:weakSelf.statusArray[_state]];
                
            } viewController:weakSelf];
        }
       
    } failure:^(NSError *error) {
        

        
    }];
    

    
}
@end
