//
//  TransactionViewController.m
//  guoshang
//
//  Created by JinLian on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "TransactionViewController.h"
#import "TranscationTableViewCell.h"
#import "TransactionModel.h"
#import "SDRefresh.h"
@interface TransactionViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableArray *_dataList;
    int page;
    BOOL _UIFinished;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) SDRefreshFooterView *refreshFooter;
@end

static NSString *cellIndentifier = @"cellIndentifier";

@implementation TransactionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"交易明细";
    page = 1;
    self.view.backgroundColor = MyColor;
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, Width, 64);
    navView.backgroundColor = GS_Business_NavBarColor;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 48, 48);
    [backBtn setImage:[UIImage imageNamed:@"back_jt"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    CGFloat titleX =CGRectGetMaxX(backBtn.frame);
    CGFloat titleY= 20;
    CGFloat titleW= Width-backBtn.frame.size.width*2;
    CGFloat titleH = 44;
    titleLabel.frame = CGRectMake(titleX, titleY,titleW,titleH);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"交易明细";
    [navView addSubview:titleLabel];
    [self.view addSubview:navView];
    
    
    [self loadData];
    //    [self creatRefresh];
}
-(void)toBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden= YES;
    
}
-(void)jiazai
{
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!=nil) {
        
        NSDictionary *dic = @{@"shop_id":GS_Business_Shop_id,@"page":[NSString stringWithFormat:@"%d",page],@"page_size":@"3"
                              };
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/ExchangeDetails") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
            //            NSLog(@"%@",[responseObject objectForKey:@"message"]);
            //  _dataList = [responseObject objectForKey:@"result"];
            
            if ([[responseObject objectForKey:@"result"] count] < 3) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                [weakSelf alertVeiw];
            }
            else
            {
                NSArray *array = [[NSArray alloc]  initWithArray:[responseObject objectForKey:@"result"]];
                
                [_dataList addObjectsFromArray:array];
                [weakSelf.tableView.mj_footer endRefreshing];
                [weakSelf.tableView reloadData];
                //                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                //                for (int i  = 0; i<[[responseObject objectForKey:@"result"] count]; i++) {
                //
                //                       dic = responseObject[@"result"][i];
                ////                      NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary: responseObject[@"result"][i]];
                //                    [_dataList addObject: [NSDictionary dictionaryWithDictionary:dic]];
                //                }
            }
            
            
            
        } failure:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
            //            NSLog(@"---%@",error);
        }];
        
    }
    
}
- (void)creatRefresh
{
    __weak typeof(self) weakSelf = self;
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        // 请求加载接口
        [weakSelf footerRefresh];
    }];
}
-(void)footerRefresh
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        page++;
        [weakSelf jiazai];
    });
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden= YES;
    
}
- (void)createUI {
    
    if (!_UIFinished) {
        [self.view addSubview:self.tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(64);
            make.left.right.bottom.mas_offset(0);
        }];
        _UIFinished = YES;
    }
    
}


#warning 接口数据 -------------------------------------

- (void)loadData {
    
    _dataList = [[NSMutableArray alloc]init];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!=nil) {
        
        NSDictionary *dic = @{@"shop_id":GS_Business_Shop_id,@"page":@"1",@"page_size":@"3"
                              };
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/ExchangeDetails") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
            //            NSLog(@"%@",[responseObject objectForKey:@"message"]);
            [_dataList addObjectsFromArray:[responseObject objectForKey:@"result"]];
            
            if (_dataList.count == 0) {
                
                [weakSelf alertVeiw];
            }
            [weakSelf createUI];
            
            
        } failure:^(NSError *error) {
            
            //            NSLog(@"---%@",error);
        }];
        
    }
    
}
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = MyColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"TranscationTableViewCell" bundle:nil] forCellReuseIdentifier:cellIndentifier];
        [self creatRefresh];
    }
    return _tableView;
}

- (void)navigationItemButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataList.count;
    //    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 175;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TranscationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = _dataList[indexPath.section];
    
    TransactionModel *model = [[TransactionModel alloc]initWithContentDic:dic];
    
    cell.model = model;
    
    return cell;
}

- (void)alertVeiw {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无数据" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:act];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}



@end
