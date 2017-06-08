//
//  MassaageCenterViewController.m
//  guoshang
//
//  Created by 陈赞 on 16/8/3.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MassaageCenterViewController.h"
#import "GSMessageSelectView.h"
#import "GSMessageCell.h"
#import "GSMessageModel.h"
@interface MassaageCenterViewController ()<UITableViewDelegate,UITableViewDataSource,GSMessageCellDelegate>
@property (nonatomic,strong) GSMessageSelectView *selectView;//订单消息、账户消息视图
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger MessageType;//选择的项目为
@end

@implementation MassaageCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
-(UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.selectView.frame.size.height+1, Width, Height-self.selectView.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self defalutSetting];

    [self createSelectView];
    //    加载数据
    [self createData];
}

#pragma mark    --创建视图---
- (void)defalutSetting{
    self.title = @"消息中心";
    self.view.backgroundColor =[UIColor whiteColor];
    self.MessageType = 1;
}

- (void)createSelectView {
    //    账户消息／订单消息
    self.selectView = [[GSMessageSelectView alloc] initWithFrame:CGRectMake(0, 0, Width, 48)];

    [self.view addSubview:self.selectView];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.selectView setCallbackBlock:^(NSInteger index) {

//        NSLog(@"%ld",(long)index);
        weakSelf.MessageType = index;
        [weakSelf createData];
    }];

}

#pragma mark       加载数据/刷新



-(void)createData{
    NSString * encryptString;

    NSString * userId = [NSString stringWithFormat:@"user_id=%@,type=%zi",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],self.MessageType];
    encryptString = [userId encryptStringWithKey:KEY];
//    NSLog(@"%@",encryptString);

    [HttpTool POST:URLDependByBaseURL(@"/Api/Message/MessageList") parameters:@{@"token":encryptString} success:^(id responseObject) {

        if (![responseObject[@"status"] isEqualToString:@"0"]) {

            [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:self];
            [self.tableView.header endRefreshing];
            return ;
        }else if ([responseObject[@"status" ] isEqualToString:@"0"]) {
            NSArray *dataA =responseObject[@"result"];
            NSMutableArray *subArr = [NSMutableArray array];
            for (NSDictionary *dic in dataA) {
                GSMessageModel *model = [[GSMessageModel alloc] initWithDictionary:dic error:nil];
                [subArr addObject:model];
            }
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:subArr];
            [self.tableView reloadData];
            [self .tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];

        }

    } failure:^(NSError *error) {

//        NSLog(@"失败");

    }];

}



#pragma mark   --delegate/datasource---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GSMessageCell" owner:nil options:nil] lastObject];
    }
    cell.delegate = self;
    cell.messageModel = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
#pragma mark     ---单元格代理----
//阅读
- (void)readMessage:(GSMessageCell *)cell withModel:(GSMessageModel *)model{
    [self readerDataWithModel:model];
}
//删除
- (void)deleteMessage:(GSMessageCell*)cell withModel:(GSMessageModel*) model withRow:(NSInteger)row{

    [self deleteDataWithModel:model withRow: row];
}
-(void)deleteDataWithModel:(GSMessageModel*)model withRow:(NSInteger)row{

    NSString * encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,message_id=%ld",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],model.message_id];
    encryptString = [userId encryptStringWithKey:KEY];
//    NSLog(@"%@",encryptString);

    [HttpTool POST:URLDependByBaseURL(@"/Api/Message/DelMessage") parameters:@{@"token":encryptString} success:^(id responseObject) {

        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            [self.dataArray removeAllObjects];
            [self createData];
        }



    } failure:^(NSError *error) {

//        NSLog(@"失败");

    }];



}
-(void)readerDataWithModel:(GSMessageModel*)model{
    NSString * encryptString;
//    NSLog(@"aaaa%ld",model.user_id);
//    NSLog(@"aaaaaa%ld",model.message_id);
    NSString * userId = [NSString stringWithFormat:@"user_id=%@, message_id=%ld",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],model.message_id];
    encryptString = [userId encryptStringWithKey:KEY];
//    NSLog(@"%@",encryptString);

    [HttpTool POST:URLDependByBaseURL(@"/Api/Message/ReadMessage") parameters:@{@"token":encryptString} success:^(id responseObject) {

        if ([responseObject[@"status"]isEqualToString:@"0"]) {
            [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:self];

        }

    } failure:^(NSError *error) {


    }];

    
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
