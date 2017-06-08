//
//  MyAddressViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyAddressViewController.h"
#import "AddressCell.h"
#import "AddAddressViewController.h"


@interface MyAddressViewController ()<SecondViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _dataArray;
    MyAddressModel * _model;
}
@end

@implementation MyAddressViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [_dataArray removeAllObjects];
    [self dataInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"我的收货地址";
    
    _dataArray = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, Width, Height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
}

// 初始化数据源
-(void)dataInit{
    NSString * userId = [NSString stringWithFormat:@"user_id=%@",UserId];
    NSString * encryptString = [userId encryptStringWithKey:KEY];
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=myaddress") parameters:@{@"token":encryptString} success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"result"]) {
            _model = [[MyAddressModel alloc]init];
            [_model setValuesForKeysWithDictionary:dic];
            _model.allAddress = [NSString stringWithFormat:@"%@/%@/%@",_model.province,_model.city,_model.district];
            [_dataArray addObject:_model];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- UITableViewDelegate --
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressCell* cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    MyAddressModel * model = _dataArray[indexPath.row];
    cell.addressModel = model;
    cell.cellRow = indexPath.row;
//    model = _dataArray[indexPath.row];
      return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell  让颜色变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.Type isEqualToString:@"sel"]) {
//        NSLog(@"%@,", _dataArray[indexPath.row]);
        MyAddressModel * Model =_dataArray[indexPath.row];
        NSNotification * notice = [NSNotification notificationWithName:@"123" object:nil userInfo:@{@"id":Model.address_id}];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self settingDefultAddressWithIndexPath:indexPath];

        
   }
}


-(void)settingDefultAddressWithIndexPath:(NSIndexPath*)indexPath{
    
       MyAddressModel * model =_dataArray[indexPath.row];
 
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,address_id=%@,consignee=%@,country=1,province=%@,city=%@,district=%@,address=%@,tel=%@,is_default=1",UserId,model.address_id,model.consignee,model.province_id,model.city_id,model.district_id,model.address,model.tel];
    NSString * encryptString = [userId encryptStringWithKey:KEY];
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=editaddress") parameters:@{@"token":encryptString} success:^(id responseObject) {
        if ([responseObject[@"status"]integerValue] == 0) {
            // 返回上一界面
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        
    }];

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, Width, 90)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton * addAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, Width -  40, 40)];
    addAddressBtn.backgroundColor =[UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
    [addAddressBtn setTintColor:[UIColor whiteColor]];
    addAddressBtn.layer.cornerRadius = 20;
    [addAddressBtn setTitle:@"+ 新增收货地址" forState:UIControlStateNormal];
    [addAddressBtn addTarget:self action:@selector(toAddAddress) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addAddressBtn];
    return footerView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString * userId = [NSString stringWithFormat:@"user_id=%@,address_id=%@",UserId,[_dataArray[indexPath.row] address_id]];
        NSString * encryptString = [userId encryptStringWithKey:KEY];
//        NSLog(@"%@",encryptString);
        [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=deladdress") parameters:@{@"token":encryptString} success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
        [_dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)toAddAddress{
    AddAddressViewController * addAddress = [[AddAddressViewController alloc] init];
    addAddress.delegate = self;
    addAddress.temp = NO;
    [self.navigationController pushViewController:addAddress animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

//实现协议方法
-(void)sendValue:(MyAddressModel *)model{
    [_dataArray addObject:model];
    [_tableView reloadData];
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
