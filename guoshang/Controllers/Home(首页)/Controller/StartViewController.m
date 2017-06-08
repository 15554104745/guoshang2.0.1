//
//  StartViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/30.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "StartViewController.h"
#import "LimitModel.h"
#import "LimitCell.h"
@interface StartViewController ()

@end

@implementation StartViewController
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    if (self.dataArray.count > 0) {
//        
//        
//        [self pullRefresh];
//    }
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self createData];
//    [self creatRefresh];
    // Do any additional setup after loading the view.
}
//
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
//    
//    [self createData];
//    
//}


-(void)createData{
    __weak typeof(self) weakSelf = self;
    [HttpTool GET:@"http://www.ibg100.com/Apiss/index.php?m=Api&c=Active&a=will" parameters:nil success:^(id responseObject) {
        NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        NSInteger status = [str integerValue];
        if (status == 0) {
            for ( NSDictionary * dic  in responseObject[@"result"]) {
                LimitModel * model = [LimitModel mj_objectWithKeyValues:dic];
                [weakSelf.dataArray addObject:model];
            }
            
            
            [weakSelf.myTableView reloadData];
            
          
        }
//        [self.myTableView headerEndRefreshing];
//        
//        [self.myTableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        
    }];

    
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
