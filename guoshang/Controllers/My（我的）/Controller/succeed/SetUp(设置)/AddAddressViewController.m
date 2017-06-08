//
//  AddAddressViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/8.
//  Copyright © 2016年宗丽娜. All rights reserved.
//

#import "AddAddressViewController.h"
#import "MyAddressViewController.h"


@interface AddAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView * firTable;
    UITableView * secTable;
    UITableView * thrTable;
    UIScrollView * saveView;
    
    NSInteger index;
    NSNumber * isDefault;
    
    NSMutableArray * dataArray;
    
    //省
    NSMutableString * state;
    NSMutableString * state_id;
    //市
    NSMutableString * city;
    NSMutableString * city_id;
    //区、县
    NSMutableString * county;
    NSMutableString * county_id;

    //收件人
    NSMutableString * name;
    //电话
    NSMutableString * phoneNum;
    
    NSMutableString * region_id;
    NSMutableString * region_id_temp;
    UITextField * detailTF;
    UITextField * addresseeTF;
    UITextField * phoneTF;
    UIButton * siteButton;
}

@end

@implementation AddAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
    region_id = [NSMutableString stringWithString:@"1"];
    isDefault = @0;
    
    if (self.temp) {
        //编辑
        state = [NSMutableString stringWithString:_model.province];
        city = [NSMutableString stringWithString:_model.city];
        county = [NSMutableString stringWithString:_model.district];
        isDefault = _model.is_default;
        [self createSaveView];
        detailTF.text = [NSMutableString stringWithString:_model.address];
        addresseeTF.text = _model.consignee;
        phoneTF.text = _model.tel;
        
    }else{
        //添加
        [self dataArrayFir];
        
    }
}

-(void)dataArrayFir{
    dataArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=get_next_region") parameters:@{@"region_id":region_id} success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        for (NSDictionary * dic in responseObject[@"result"]) {
            MyAddressModel * model = [[MyAddressModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [dataArray addObject:model];
        }
        [weakSelf createFirTable];
    } failure:^(NSError *error) {
        
    }];

}

-(void)dataArraySec{
    dataArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=get_next_region") parameters:@{@"region_id":region_id} success:^(id responseObject) {
        for (NSDictionary * dic in responseObject[@"result"]) {
            MyAddressModel * model = [[MyAddressModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [dataArray addObject:model];
        }
        [weakSelf createSecTable];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)dataArrayThi{
    dataArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=get_next_region") parameters:@{@"region_id":region_id} success:^(id responseObject) {
        for (NSDictionary * dic in responseObject[@"result"]) {
            MyAddressModel * model = [[MyAddressModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [dataArray addObject:model];
        }
        [weakSelf createThrTable];
    } failure:^(NSError *error) {
        
    }];
    
}
//一级地址省
-(void)createFirTable{
    //
    firTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-60) style:UITableViewStylePlain];
    firTable.dataSource = self;
    firTable.delegate = self;
    firTable.bounces = NO;
    firTable.showsVerticalScrollIndicator = NO;
    firTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:firTable];
}
//二级地址市
-(void)createSecTable{
    //
    secTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-60) style:UITableViewStylePlain];
    secTable.dataSource = self;
    secTable.delegate = self;
    firTable.bounces = NO;
    secTable.showsVerticalScrollIndicator = NO;
    secTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:secTable];
}
//三级地址区县
-(void)createThrTable{
    //
    thrTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-60) style:UITableViewStylePlain];
    thrTable.dataSource = self;
    thrTable.delegate = self;
    firTable.bounces = NO;
    thrTable.showsVerticalScrollIndicator = NO;
    thrTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:thrTable];
}
//地址设置界面
-(void)createSaveView{
    //
    saveView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-65)];
    saveView.contentSize = CGSizeMake(Width, Height);
    saveView.showsVerticalScrollIndicator = NO;
    saveView.bounces = NO;
    [self.view addSubview:saveView];
    
    UILabel * siteLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 20)];
    siteLabel.text = @"所在地";
    siteLabel.textColor = [UIColor grayColor];
    [saveView addSubview:siteLabel];
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 80, 20)];
    detailLabel.text = @"详细地址";
    detailLabel.textColor = [UIColor grayColor];
    [saveView addSubview:detailLabel];
    
    UILabel * addresseeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 80, 20)];
    addresseeLabel.text = @"收件人";
    addresseeLabel.textColor = [UIColor grayColor];
    [saveView addSubview:addresseeLabel];
    
    UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 290, 80, 20)];
    phoneLabel.text = @"联系电话";
    phoneLabel.textColor = [UIColor grayColor];
    [saveView addSubview:phoneLabel];
    
    UILabel * carveLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, Width, 1)];
    carveLabel1.backgroundColor = [UIColor grayColor];
    [saveView addSubview:carveLabel1];
    
    UILabel * carveLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, Width, 1)];
    carveLabel2.backgroundColor = [UIColor grayColor];
    [saveView addSubview:carveLabel2];
    
    UILabel * carveLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 260, Width, 1)];
    carveLabel3.backgroundColor = [UIColor grayColor];
    [saveView addSubview:carveLabel3];
    
    UILabel * carveLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 350, Width, 1)];
    carveLabel4.backgroundColor = [UIColor grayColor];
    [saveView addSubview:carveLabel4];
    
    siteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    siteButton.frame = CGRectMake(20, 60, Width-40, 30);
    siteButton.tag = 10;
    [siteButton setTitle:[NSString stringWithFormat:@"%@-%@-%@",state,city,county] forState:UIControlStateNormal];
    [siteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    siteButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [siteButton addTarget: self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveView addSubview:siteButton];
    
    UIButton * defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    defaultButton.frame = CGRectMake(20, 372, 16, 16);
    if ([isDefault isEqualToNumber:@0]) {
        defaultButton.backgroundColor = [UIColor whiteColor];
    }else{
        defaultButton.backgroundColor = [UIColor redColor];
    }
    
    defaultButton.layer.borderWidth = 1;
    defaultButton.layer.borderColor = [UIColor blackColor].CGColor;
    defaultButton.tag = 11;
    [defaultButton addTarget: self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveView addSubview:defaultButton];
    
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(20, 430, Width-40, 40);
    saveButton.backgroundColor = [UIColor redColor];
    saveButton.layer.cornerRadius = 20;
    [saveButton setTitle:@"保 存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    saveButton.tag = 12;
    [saveButton addTarget: self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveView addSubview:saveButton];
    
    detailTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 130, Width-40, 50)];
    detailTF.font = [UIFont systemFontOfSize:19];
    detailTF.delegate = self;
    [saveView addSubview:detailTF];
    
    addresseeTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 230, Width-40, 30)];
    addresseeTF.font = [UIFont systemFontOfSize:19];
    addresseeTF.delegate = self;
    [saveView addSubview:addresseeTF];
    
    phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 320, Width-40, 30)];
    phoneTF.font = [UIFont systemFontOfSize:19];
    phoneTF.delegate = self;
    [saveView addSubview:phoneTF];
    if(_model != nil){
    detailTF.text = [NSMutableString stringWithString:_model.address];
    addresseeTF.text = _model.consignee;
    phoneTF.text = _model.tel;
    }

    UILabel * defaultLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 370, 150, 20)];
    defaultLabel.text = @"设置为默认地址";
    [saveView addSubview:defaultLabel];
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
    if ([tableView isEqual:firTable]) {
        // 1.添加标识
        static NSString * cellId = @"cellId";
        // 2.复用池中调用
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        // 3.找不到创建
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = [NSMutableString stringWithString:[[dataArray objectAtIndex:indexPath.row] region_name]];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }else if ([tableView isEqual:secTable]){
        // 1.添加标识
        static NSString * cellId = @"cellId";
        // 2.复用池中调用
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        // 3.找不到创建
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = [NSMutableString stringWithString:[[dataArray objectAtIndex:indexPath.row] region_name]];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        //头视图
        UIButton * secHeader = [UIButton buttonWithType:UIButtonTypeCustom];
        secHeader.frame = CGRectMake(0, 0, Width, 30);
        [secHeader setTitle:[NSString stringWithFormat:@"%@",state] forState:UIControlStateNormal];
        [secHeader setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        secHeader.titleLabel.textAlignment = NSTextAlignmentLeft;
        secHeader.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        secHeader.tag = 100;
        [secHeader addTarget:self action:@selector(headerButton:) forControlEvents:UIControlEventTouchUpInside];
        secTable.tableHeaderView = secHeader;
        return cell;
    }else if ([tableView isEqual:thrTable]){
        // 1.添加标识
        static NSString * cellId = @"cellId";
        // 2.复用池中调用
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        // 3.找不到创建
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = [NSMutableString stringWithString:[[dataArray objectAtIndex:indexPath.row] region_name]];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //头视图
        UIButton * thrHeader = [UIButton buttonWithType:UIButtonTypeCustom];
        thrHeader.frame = CGRectMake(0, 0, Width, 30);
        [thrHeader setTitle:[NSString stringWithFormat:@"%@, %@",state,city] forState:UIControlStateNormal];
        [thrHeader setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        thrHeader.titleLabel.textAlignment = NSTextAlignmentLeft;
        thrHeader.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        thrHeader.tag = 101;
        [thrHeader addTarget:self action:@selector(headerButton:) forControlEvents:UIControlEventTouchUpInside];
        thrTable.tableHeaderView = thrHeader;
        return cell;
    }
    return nil;
    
}
//每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:firTable]) {
        state = [NSMutableString stringWithString:[[dataArray objectAtIndex:indexPath.row] region_name]];
        region_id_temp = region_id;
        region_id = [NSMutableString stringWithString:[[dataArray objectAtIndex:indexPath.row] region_id]];
        state_id = region_id;
        [firTable removeFromSuperview];
        [self dataArraySec];
    }else if ([tableView isEqual:secTable]){
        city = [NSMutableString stringWithString:[[dataArray objectAtIndex:indexPath.row] region_name]];
        region_id_temp = region_id;
        region_id = [NSMutableString stringWithString:[[dataArray objectAtIndex:indexPath.row] region_id]];
        city_id = region_id;
        [secTable removeFromSuperview];
        [self dataArrayThi];
     
    }else if ([tableView isEqual:thrTable]){
        county = [NSMutableString stringWithString:[[dataArray objectAtIndex:indexPath.row] region_name]];
        region_id_temp = region_id;
        region_id = [NSMutableString stringWithString:[[dataArray objectAtIndex:indexPath.row] region_id]];
        county_id = region_id;
        [dataArray removeAllObjects];
        [thrTable removeFromSuperview];
        [self createSaveView];
    }
}

-(void)buttonClick:(UIButton *)button{
    if (button.tag == 10) {
        [saveView removeFromSuperview];
        region_id = (NSMutableString *) @"1";
        [self dataArrayFir];
        state = nil;
        city = nil;
        county = nil;
    }else if(button.tag == 11){
        if ([isDefault isEqualToNumber:@0]) {
            isDefault = @1;
            button.backgroundColor = [UIColor redColor];
        }else{
            isDefault = @0;
            button.backgroundColor = [UIColor whiteColor];
        }
    }else{
        if (addresseeTF.text.length && phoneTF.text.length==11 && [self isPureInt:phoneTF.text] && detailTF.text.length) {
            if (_temp) {
                //编辑
                NSString * userId = [NSString stringWithFormat:@"user_id=%@,address_id=%@,consignee=%@,country=1,province=%@,city=%@,district=%@,address=%@,tel=%@,is_default=%@",UserId,_model.address_id,addresseeTF.text,_model.province_id,_model.city_id,_model.district_id,detailTF.text,phoneTF.text,isDefault];
                NSString * encryptString = [userId encryptStringWithKey:KEY];
                __weak typeof(self) weakSelf = self;
                [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=editaddress") parameters:@{@"token":encryptString} success:^(id responseObject) {
                    if ([responseObject[@"status"]integerValue] == 0) {
                        // 返回上一界面
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }else{
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }else{
                //添加
                NSString * userId = [NSString stringWithFormat:@"user_id=%@,consignee=%@,province=%@,city=%@,district=%@,address=%@,tel=%@,is_default=%@",UserId,addresseeTF.text,state_id,city_id,county_id,detailTF.text,phoneTF.text,isDefault];
                NSString * encryptString = [userId encryptStringWithKey:KEY];
                __weak typeof(self) weakSelf = self;
                [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=addaddress") parameters:@{@"token":encryptString} success:^(id responseObject) {
                    if ([responseObject[@"status"]integerValue] == 0) {
                        // 返回上一界面
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }else{
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"地址信息格式不正确!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

-(void)headerButton:(UIButton *)button{
    if (button.tag == 100) {
        [secTable removeFromSuperview];
        region_id = region_id_temp;
        [self dataArrayFir];
    }else{
        [thrTable removeFromSuperview];
        region_id = region_id_temp;
        [self dataArraySec];
    }
}
//判断字符串是否为数字
- (BOOL)isPureInt:(NSString *)string{
    
    NSScanner * scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}
//键盘收回
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITextField * textField in self.view.subviews) {
        // 回收键盘
        [textField resignFirstResponder];
    }
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
