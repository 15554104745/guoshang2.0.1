//
//  GSMessageCenterController.m
//  guoshang
//
//  Created by 金联科技 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSMessageCenterController.h"
#import "GSMessageSelectView.h"
#import "GSMessageCell.h"
#import "GSMessageModel.h"

@interface GSMessageCenterController ()<UITableViewDelegate,UITableViewDataSource,GSMessageCellDelegate>
@property (nonatomic,strong) GSMessageSelectView *selectView;//订单消息、账户消息视图
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger MessageType;//选择的项目为
@property (nonatomic,strong) UIView *customNavigitonBar;
@end

@implementation GSMessageCenterController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
//    navigation
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
        titleLabel.text = @"消息中心";
        [_customNavigitonBar addSubview:titleLabel];
    }
    return _customNavigitonBar;
}
//    账户消息／订单消息    该布局已废弃
-(GSMessageSelectView *)selectView{
    if (!_selectView) {
        _selectView = [[GSMessageSelectView alloc] initWithFrame:CGRectMake(0, 64, Width, 48)];
        __weak typeof(self) weakSelf = self;
        [_selectView setCallbackBlock:^(NSInteger index) {
            
            weakSelf.MessageType = index;
            [weakSelf createData];
        }];
    }
    return _selectView;
}
//   tableView
-(UITableView *)tableView{
    
    if (!_tableView) {
        // CGRectMake(0,CGRectGetMaxY(self.selectView.frame)+1, Width, Height-self.selectView.frame.size.height)
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.customNavigitonBar.frame)+1, Width, Height-self.customNavigitonBar.frame.size.height)];

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
    
    [self.view addSubview:self.customNavigitonBar];
//    [self.view addSubview:self.selectView];
    [self.view addSubview:self.tableView];
  
    //    加载数据
    [self createData];
}

- (void)defalutSetting{
    self.title = @"消息中心";
    self.view.backgroundColor =[UIColor whiteColor];
    self.MessageType = 2;
  
}

#pragma mark       加载数据/刷新

-(void)createData{
    
    NSString * encryptString;
 
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,type=%zi",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],self.MessageType];
    encryptString = [userId encryptStringWithKey:KEY];
//    NSLog(@"%@",encryptString);
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Message/MessageList") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        if (![responseObject[@"status"] isEqualToString:@"0"]) {
            [weakSelf.dataArray removeAllObjects];
            [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:nil viewController:self];
               [weakSelf.tableView reloadData];
        }else if ([responseObject[@"status" ] isEqualToString:@"0"]) {
            NSArray *dataA =responseObject[@"result"];
            NSMutableArray *subArr = [NSMutableArray array];
            for (NSDictionary *dic in dataA) {
                GSMessageModel *model = [[GSMessageModel alloc] initWithDictionary:dic error:nil];
                [subArr addObject:model];
            }
            [weakSelf.dataArray addObjectsFromArray:subArr];
            
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        });
        
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,message_id=%ld",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],(long)model.message_id];
    encryptString = [userId encryptStringWithKey:KEY];
//    NSLog(@"%@",encryptString);
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Message/DelMessage") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            [AlertTool alertMesasge:@"删除成功" confirmHandler:^(UIAlertAction *action) {
                [weakSelf.dataArray removeAllObjects];
                [weakSelf createData];
            } viewController:weakSelf];
        }
        
        
        
    } failure:^(NSError *error) {
        
//        NSLog(@"失败");
        
    }];
    
    
    
}
-(void)readerDataWithModel:(GSMessageModel*)model{
    NSString * encryptString;
//    NSLog(@"aaaa%ld",model.user_id);
//    NSLog(@"aaaaaa%ld",model.message_id);
    NSString * userId = [NSString stringWithFormat:@"user_id=%@, message_id=%ld",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],(long)model.message_id];
    encryptString = [userId encryptStringWithKey:KEY];
//    NSLog(@"%@",encryptString);
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Message/ReadMessage") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        if ([responseObject[@"status"]isEqualToString:@"0"]) {
            [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:^(UIAlertAction *action) {
                [weakSelf.dataArray removeAllObjects];
                [weakSelf createData];
            } viewController:weakSelf];
        
        }
        
    } failure:^(NSError *error) {

        
    }];
    
    
}

- (void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
