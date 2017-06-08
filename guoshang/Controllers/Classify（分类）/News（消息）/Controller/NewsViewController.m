//
//  NewsViewController.m
//  guoshang
//
//  Created by宗丽娜 on 16/2/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "NewsDetailViewController.h"

@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * dataArray;
}
@end

@implementation NewsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"消息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    dataArray = [[NSMutableArray alloc]init];
    for (int i =0; i<5; i++) {
        NSString * str = [NSString stringWithFormat:@"%d",i];
        [dataArray addObject:str];
    }
    
    [self createUI];
}

-(void)createUI{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
    
}

#pragma mark -tableView协议方法

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}
// 返回cell表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.添加标识
    static NSString * cellId = @"cellId";
    //xib
    NewsTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil]lastObject];

    }

    
    return cell;
}
//每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailViewController * ndvc = [[NewsDetailViewController alloc]init];
    [self.navigationController pushViewController:ndvc animated:YES];
    
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
