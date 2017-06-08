//
//  IncomeViewController.m
//  收入信息
//
//  Created by Mac on 16/7/19.
//  Copyright © 2016年 glodRoc. All rights reserved.
//

#import "IncomeViewController.h"
#import "TransactionViewController.h"
#import "GSCustomOrderViewController.h"

@interface IncomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_datalist;
    NSString *sellStr;
    UILabel *label;
    NSDictionary *allMoney;
}

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)UIView *tableHeaderView;
@end

@implementation IncomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];


}
//加载数据
- (void)loadData {
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!=nil) {
        
        NSDictionary *dic = @{@"shop_id":GS_Business_Shop_id};
        
        [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/Income") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
            allMoney = [responseObject objectForKey:@"result"];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
//            NSLog(@"---%@",error);
        }];
        
    }


}

///创建整体UI界面
- (void)createUI{
    
    [self.view addSubview:self.tableView];

    //创建导航栏
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    navBarView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self.view addSubview:navBarView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((Width -100)*0.5 , 20, 100, 44)];
    titleLabel.text = @"收入信息";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navBarView addSubview:titleLabel];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 22, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];

}

- (void)leftBtnAct:(UIButton *)legtBtn{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-懒加载
//创建头部视图
- (UIView *)tableHeaderView{

    if (!_tableHeaderView) {
        
        UIImageView *tableHeaderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, 200)];
        tableHeaderView.image = [UIImage imageNamed:@"tuceng11"];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(50, 100-25+22, Width -100, 50)];
        NSString *money = allMoney[@"amount"];
        label.text = [NSString stringWithFormat:@"已完成的交易：%.2f",[money floatValue]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
        label.tag = 200;
        [tableHeaderView addSubview:label];

        _tableHeaderView = tableHeaderView;
    }
    
    return _tableHeaderView;
}
//懒加载tableView
- (UITableView *)tableView{

    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width , Height) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tableHeaderView = self.tableHeaderView;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        //数据源数组
        _datalist = @[@"交易中的订单",@"交易明细"];
        _tableView = tableView;
    }
    
    return _tableView;
}


#pragma mark-UITableView数据源协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _datalist.count;
}
//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.textLabel.text = _datalist[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];

    UILabel *lab = [tableView.tableHeaderView viewWithTag:200];
    NSString *money = allMoney[@"amount"];
    lab.text = [NSString stringWithFormat:@"已完成的交易：%.2f",[money floatValue]];


    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {  //交易中的订单
        
        GSCustomOrderViewController *orderVC = [[GSCustomOrderViewController alloc] init];
        [self.navigationController pushViewController:orderVC animated:YES];

        
    }else { //交易明细
        TransactionViewController *transcationVC = [[TransactionViewController alloc]init];
        [self.navigationController pushViewController:transcationVC animated:YES];
        
    }
}

@end
