//
//  GSRefundViewController.m
//  guoshang
//
//  Created by JinLian on 16/9/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSRefundViewController.h"
#import "StepProgressView.h"
#import "GSRefoundHeaderView.h"
#import "GSRefundCell.h"
@interface GSRefundViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@property (nonatomic,strong) UIView *customNavigitonBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) GSRefoundHeaderView *headerView;
@property (nonatomic,strong) GSRefundInfoModel *refundModel;

@end

@implementation GSRefundViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.customNavigitonBar];
    self.customNavigitonBar.backgroundColor = self.enterType == GSEnteCurrentViewOfDefaultSeller?GS_Business_NavBarColor: NewRedColor;
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];

    [self loadData];
   }
//    navigation
-(GSRefoundHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"GSRefoundHeaderView" owner:nil options:nil] lastObject];
    }
    return _headerView;
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
        titleLabel.text = @"退款详情";
        [_customNavigitonBar addSubview:titleLabel];
    }
    return _customNavigitonBar;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,Width, Height-CGRectGetHeight(self.customNavigitonBar.frame)-40)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}
-(void)loadData{
    
    NSString * encryptString;
    
    NSString * userId = self.enterType==GSEnteCurrentViewOfDefaultSeller?[NSString stringWithFormat:@"shop_id=%@,status=returnDetail,order_id=%@",GS_Business_Shop_id,self.order_sn]:[NSString stringWithFormat:@"order_sn=%@",self.order_sn];
    
    encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    
    NSString *path = self.enterType==GSEnteCurrentViewOfDefaultSeller?@"/Api/ShopReturnOrder/changeReturn":@"/Api/User/my_order_refund_detail";
    [HttpTool POST:URLDependByBaseURL(path) parameters:@{@"token":encryptString} success:^(id responseObject) {
        NSLog(@"----%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
          
            weakSelf.refundModel= [GSRefundInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
            
            weakSelf.headerView.infoModel = _refundModel;
        }
        [weakSelf.tableView reloadData];

        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
    
}


-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.refundModel.consult.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GSRefundCell *cell =[GSRefundCell refundCellWithTableView:tableView];
    NSArray *consultArr = self.refundModel.consult;
    cell.consultModel =consultArr[indexPath.row];
    cell.return_Money = self.refundModel.total_fee;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      NSArray *consultArr = self.refundModel.consult;
    GSConsultModel *model =consultArr[indexPath.row];
    
    
    return model.reason.length>50? 87+model.reason.length/2: 87;
    return 87;
}
@end
