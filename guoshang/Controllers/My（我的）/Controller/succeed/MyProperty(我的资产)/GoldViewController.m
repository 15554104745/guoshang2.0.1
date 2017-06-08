//
//  GoldViewController.m
//  guoshang
//
//  Created by 张涛 on 16/3/2.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoldViewController.h"
#import "GoldTableViewCell.h"
#import "RecordModel.h"

@interface GoldViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * dataArray;
    UITableView * _tableView;
}
@end

@implementation GoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的金币";
    self.view.backgroundColor = MyColor;
    dataArray = [[NSMutableArray alloc]init];
    [self createUI];
    
    [self dataInit];
}

-(void)dataInit{
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,type=user_money",UserId];
    NSString * encryptString = [userId encryptStringWithKey:KEY];
//    NSLog(@"%@",encryptString);
    
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=user&a=get_account_log") parameters:@{@"token":encryptString} success:^(id responseObject) {
        if ([responseObject[@"status"]isEqual:@0]) {
            for (NSDictionary * dic in responseObject[@"result"]) {
                RecordModel * model =[[RecordModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [dataArray addObject:model];
            }
            [_tableView reloadData];
        }else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
}
#pragma mark -tableView协议方法

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
// 返回cell表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.添加标识
    static NSString * cellId = @"cellId";
    
    //xib
    GoldTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"GoldTableViewCell" owner:self options:nil]lastObject];
    }
    //时间戳转时间
    NSTimeInterval time=[[dataArray[indexPath.row] change_time] doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStr = [formatter stringFromDate:detaildate];
 
    cell.typeLabel.text = [dataArray[indexPath.row] change_desc];
    cell.dateLabel.text = timeStr;
    cell.costLabel.text = [dataArray[indexPath.row] user_money];
    return cell;
}
//每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
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
