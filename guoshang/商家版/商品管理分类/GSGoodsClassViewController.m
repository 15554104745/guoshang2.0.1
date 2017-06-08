//
//  GSGoodsClassViewController.m
//  guoshang
//
//  Created by chenlei on 16/10/8.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsClassViewController.h"
#import "GSDragCellTableView.h"
#import "GSClassModel.h"
#import "GSAddShopClassViewController.h"
#import "GSChangeShopClassViewController.h"
#import "SVProgressHUD.h"

#define GSTableCellHeight 80
@interface GSGoodsClassViewController ()<GSDragCellTableViewDataSource,GSDragCellTableViewDelegate>
@property (nonatomic, strong) NSArray *data;

@end

@implementation GSGoodsClassViewController
{
    //是否是可排序状态
    BOOL _isSequence;
    NSInteger _currnet;//移动后的位置
    GSDragCellTableView *_tableView;
    UIButton  *_sequenceBtn; //排序按钮
    UISwitch *_sw;
    NSString *category_id_str_old;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
     _isSequence = NO;//默认不可拖动排序
    
    [self createNav];
    [self createAddShopClassManager];
    [self loadData];
   
    _tableView = [[GSDragCellTableView alloc] init];
    
    _tableView.allowsSelection = YES;
    
    _tableView.isSequence = _isSequence;
    
    _tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64*2);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];

}

- (void)createNav{
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, Width, 64);
    navView.backgroundColor = GS_Business_NavBarColor;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 48, 48);
    [backBtn setImage:[UIImage imageNamed:@"back_jt"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    _sequenceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _sequenceBtn.frame= CGRectMake(Width-68, 30, 60, 25);
    [_sequenceBtn setTitle:@"排序"forState:UIControlStateNormal];
    [_sequenceBtn setTitle:@"保存" forState:UIControlStateSelected];
    _sequenceBtn.layer.cornerRadius = 5;
    [_sequenceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sequenceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _sequenceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sequenceBtn addTarget:self action:@selector(AddOrRemoveLongGesture) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_sequenceBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    CGFloat titleX =CGRectGetMaxX(backBtn.frame);
    CGFloat titleY= 20;
    CGFloat titleW= Width-backBtn.frame.size.width*2;
    CGFloat titleH = 44;
    titleLabel.frame = CGRectMake(titleX, titleY,titleW,titleH);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"分类管理";
    [navView addSubview:titleLabel];
    [self.view addSubview:navView];
}
//返回按钮被点击
- (void)toBack{
    if (_isSequence == YES) {
        UIAlertController *Alert = [UIAlertController alertControllerWithTitle:@"温馨提示：" message:@"新排序尚未保存，确定退出？" preferredStyle:UIAlertControllerStyleAlert];
        
        [Alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [Alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:Alert animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}
//排序按钮点击事件
- (void)AddOrRemoveLongGesture {
    _isSequence = !_isSequence;
    _sequenceBtn.selected = _isSequence;
    _tableView.isSequence = _isSequence;
    if (_isSequence == NO) {//点击完成
        NSLog(@"点击完成");
        [self moveLoadData];
    }else{//点击排序
        NSLog(@"点击完成");
    }
}
//添加商品分类按钮
- (void)createAddShopClassManager {
    UIButton  *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(20, Height-50, Width-40, 40);
    [btn setTitle:@"添加商品分类"forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor= kUIColorFromRGB(0xE73736);
    [btn addTarget:self action:@selector(shopClassButttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
//添加商品分类按钮点击事件
- (void)shopClassButttonClick:(UIButton *)button {
    GSAddShopClassViewController *asClass = [[GSAddShopClassViewController alloc] init];
    asClass.GSAddShopClassViewControllerBlock = ^(NSString *addSC){
        [self loadData];
    };
    [self.navigationController pushViewController:asClass  animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dic = _data[indexPath.item];
    GSClassModel *model = [GSClassModel mj_objectWithKeyValues:dic];
    cell.textLabel.text = model.category_title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _sw = [[UISwitch alloc] initWithFrame:CGRectMake(Width-80, (GSTableCellHeight-30)/2, 30, 30)];

    _sw.transform = CGAffineTransformMakeScale(0.75, 0.75);
    _sw.tintColor = GS_Manager_Class_GreenColor;
    _sw.onTintColor = GS_Manager_Class_GreenColor;
    _sw.thumbTintColor = [UIColor whiteColor];
    _sw.tag = indexPath.row;
        [_sw addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    if ([model.status isEqualToString:@"1"]) {
        _sw.on = YES;
    }else {
        _sw.on = NO;
    }
    [cell.contentView addSubview:_sw];
    return cell;
}

- (NSArray *)originalArrayDataForTableView:(GSDragCellTableView *)tableView{
    return _data;
}

- (void)tableView:(GSDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    
    _data = newArray;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GSTableCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete; // 要实现左滑删除的那一行的编辑风格必须是Delete风格
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击删除按钮调用的方法
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _data[indexPath.item];
    GSClassModel *model = [GSClassModel mj_objectWithKeyValues:dic];
    // 删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self delegateLoadData:model.category_id];
    }];
    
    // 修改按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"修改"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        GSChangeShopClassViewController *csClass = [[GSChangeShopClassViewController alloc] init];
        csClass.category_id = model.category_id;
        csClass.status = model.status;
        csClass.category_title = model.category_title;
        csClass.GSChangeShopClassViewControllerBlock = ^(NSString *addSC){
            [self loadData];
        };
        [self.navigationController pushViewController:csClass  animated:YES];

    }];
    topRowAction.backgroundColor = [UIColor lightGrayColor];

    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, topRowAction];
    
}
//列表
- (void)loadData {
    NSString * encryptString = [[NSString stringWithFormat:@"shop_id=%@",GS_Business_Shop_id] encryptStringWithKey:KEY];
    [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/categoryList") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            
            NSArray * rootArray = responseObject[@"result"];
            _data = rootArray;
            [_tableView reloadData];
            
            category_id_str_old =@"";
            for (NSDictionary *dic in _data) {
                GSClassModel *model = [GSClassModel mj_objectWithKeyValues:dic];
                category_id_str_old = [category_id_str_old stringByAppendingString:[NSString stringWithFormat:@"%@#",model.category_id]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];

}
//删除
- (void)delegateLoadData:(NSString *)category_id {
    NSString * encryptString = [[NSString stringWithFormat:@"shop_id=%@,category_id=%@",GS_Business_Shop_id,category_id] encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/deleteCategory") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            [weakSelf loadData];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络故障，请重试"];
    }];
    
}
//拖动
- (void)moveLoadData {

    NSString *category_id_str =@"";
    for (NSDictionary *dic in _data) {
        GSClassModel *model = [GSClassModel mj_objectWithKeyValues:dic];
        category_id_str = [category_id_str stringByAppendingString:[NSString stringWithFormat:@"%@#",model.category_id]];
    }
    if ([category_id_str isEqualToString:category_id_str_old]) {
        [SVProgressHUD showErrorWithStatus:@"您的排序方式未发生改变"];
        return;
    }
    NSString * encryptString = [[NSString stringWithFormat:@"shop_id=%@,category_id=%@",GS_Business_Shop_id,category_id_str] encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/editOrder") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        [weakSelf loadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络故障，请重试"];
    }];
    
}
- (void)switchValueChange:(UISwitch *)sw {
    NSString *status = @"";
    if(sw.on)//判断switch是开还是管
    {//开
      status = @"1";
    }
    else
    {//关
      status = @"0";
    }
    GSClassModel *model = [GSClassModel mj_objectWithKeyValues:_data[sw.tag]];

    NSString * category_id = model.category_id;
    [self switchClickData:status andCategory_id:category_id];
    
}
//开关状态改变
- (void)switchClickData:(NSString *)status andCategory_id:(NSString *)category_id{
     NSString * encryptString = [[NSString stringWithFormat:@"shop_id=%@,category_id=%@,status=%@",GS_Business_Shop_id,category_id,status] encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/editStatus") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];

        }
        [weakSelf loadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络故障,请重试"];

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
