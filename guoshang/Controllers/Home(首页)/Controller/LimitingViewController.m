//
//  LimitingViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/30.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "LimitingViewController.h"
#import "LimitCell.h"
#import "LimitModel.h"
#import "GSGoodsDetailInfoViewController.h"
@interface LimitingViewController ()

@end

@implementation LimitingViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.tabBarController.tabBar.hidden= YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    self.myTableView.backgroundColor = MyColor;
//    self.page = 1;
    [self createTableView];
    [self createData];
//    [self creatRefresh];
}
//-(void)creatRefresh{
//    [self.myTableView addHeaderWithTarget:self action:@selector(pullRefresh)];
//    [self.myTableView headerEndRefreshing];
//    [self.myTableView addFooterWithTarget:self action:@selector(pushRefresh)];
//    [self.myTableView footerEndRefreshing];
//}
//
//-(void)pullRefresh{
//    
//    self.page = 1;
//    
//    [self.dataArray removeAllObjects];
//    
//    [self createData];
//    
//    
//    
//}
//
//-(void)pushRefresh{
//    self.page++;
//    [self createData];
//    
//}
-(void)createData{
//    NSString * urlStr = [NSString stringWithFormat:@"http://www.ibg100.com/Apiss/index.php?m=Api&c=Active&a=now&page=%ld",self.page];
    NSString * urlStr = URLDependByBaseURL(@"?m=Api&c=Active&a=now");
    [HttpTool GET:urlStr parameters:nil success:^(id responseObject) {
        NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        
        NSInteger status = [str integerValue];
        if (status == 0) {
            for ( NSDictionary * dic  in responseObject[@"result"]) {
                
                //[responseObject[@"result"][0] logDictionary];
                LimitModel * model = [LimitModel mj_objectWithKeyValues:dic];
                if (model) {
                   [_dataArray addObject:model];
                }
                
            }
            
            [_myTableView reloadData];
        
        }
        
//        [self.myTableView headerEndRefreshing];
//        [self.myTableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
     
        
    }];
    
}
-(void)createTableView{
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - 100) style:UITableViewStylePlain];
   [self.myTableView registerClass:[LimitCell class] forCellReuseIdentifier:@"cell"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    [self.view addSubview:self.myTableView];

}

#pragma mark -- UITableViewDelegate --


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
   
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LimitCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (self.dataArray.count> 0) {
    
        LimitModel * model = _dataArray[indexPath.row];
        cell.model = model;
        cell.popView = self.popView;

    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell  让颜色变回来
    LimitModel * model = _dataArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GSGoodsDetailInfoViewController * gsvc = [[GSGoodsDetailInfoViewController alloc] init];
    gsvc.recommendModel = model;
    gsvc.hidesBottomBarWhenPushed = YES;
    [self.popView.navigationController pushViewController:gsvc animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
////
    LimitModel * model = _dataArray[indexPath.row];
    CGFloat  size = [LNLabel calculateMoreLabelSizeWithString:model.name AndWith:(Width-30)/3 * 2-10 AndFont:15.0];
    
 return size += 140;

    
//   return Width /3 + 40;
//
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
