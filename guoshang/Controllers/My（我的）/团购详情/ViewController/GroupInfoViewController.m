//
//  GroupInfoViewController.m
//  guoshang
//
//  Created by JinLian on 16/9/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "GroupInfoTableViewCell.h"
#import "GroupInfoList.h"
#import "GroupInfoModel.h"
#import "GSCreateGroupViewController.h"

@interface GroupInfoViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    CGFloat lastRowHeight;
    GroupInfoModel *model;
    
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSDictionary *upLoadDataList;
@property (nonatomic, strong)GroupInfoTableViewCell *firstCell;
@end

@implementation GroupInfoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团购信息";
    [self loadData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((Width-200)/2, self.view.frame.size.height-110, 200, 30)];
    button.backgroundColor = NewRedColor;
    button.tag = 500;
    [button setTitle:@"立即开团" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(updataAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)loadData {
    //    self.tuan_id
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Groupon/TuanTmpInfo") parameters:@{@"token":[@{@"id":self.tuan_id} paramsDictionaryAddSaltString]} success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            model = [GroupInfoModel mj_objectWithKeyValues:[responseObject objectForKey:@"result"]];
            [weakSelf.tableView reloadData];
            
        }else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        GroupInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
        __weak typeof(self) weakSelf = self;
        cell.block = ^(NSDictionary *dataList) {
            
            weakSelf.upLoadDataList = [NSDictionary dictionaryWithDictionary:dataList];
        };
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell01"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell01"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 95, 40)];
            lab.text = @"  要团购的商品：";
            lab.font = [UIFont systemFontOfSize:12];
            [cell.contentView addSubview:lab];
            
            
            UILabel *group_desc = [[UILabel alloc]initWithFrame:CGRectMake(95, 0, Width-100, 40)];
            group_desc.font = [UIFont systemFontOfSize:12];
            group_desc.numberOfLines = 0;
            group_desc.tag = 501;
            [cell.contentView addSubview:group_desc];
            
            UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, Width, 30)];
            priceLab.backgroundColor = MyColor;
            [cell.contentView addSubview:priceLab];
            priceLab.font = [UIFont systemFontOfSize:12];
            priceLab.textColor = NewRedColor;
            priceLab.text = @"  价格阶梯：";
            
        }
        
        UILabel *group_desc = [cell.contentView viewWithTag:501];
        group_desc.text = [NSString stringWithFormat:@"%@",model.goods_name];
        
        return cell;
    }else if (indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell02"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell02"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CGFloat margin = 10.f;
            CGFloat width = self.view.frame.size.width -2*margin;
            GroupInfoList *DataGrid  = [[GroupInfoList alloc]initWithFrame:CGRectMake(margin,2*margin , width, 0) andColumnsWidths:@[@(width*0.4),@(width*0.6)]];
            DataGrid.block = ^(CGFloat rowHeight){
                lastRowHeight = rowHeight;
            };
            DataGrid.tag = 502;
            [cell.contentView addSubview:DataGrid];
            
        }
        
        GroupInfoList *DataGrid = [cell.contentView viewWithTag:502];
        
        for (NSDictionary *dic in model.rules) {
            NSArray *arr = [NSArray arrayWithObjects:[dic objectForKey:@"amount"],[dic objectForKey:@"price"], nil];
            NSString *num = [NSString stringWithFormat:@"数量：%@",[arr firstObject]];
            NSString *price = [NSString stringWithFormat:@"价格：%@元",[arr lastObject]];
            
            DataGrid.roundCorner = YES;
            [DataGrid addRecordWithArr:@[num,price]];
        }
        
        return cell;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 245;
            break;
        case 1:
            return 80;
            break;
        case 2:
            return lastRowHeight + 70;
            break;
            
        default:
            break;
    }
    return 100;
}

#pragma mark - 上传接口
- (void)updataAction {
    
    _firstCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [_firstCell passValueAction];
    
    //拼接团购规则   多个规则传参示例：rule=1-1#2-2#3-3,格式为：人数-价格
    NSMutableString *rulersStr = [[NSMutableString alloc]initWithCapacity:0];
    for (NSDictionary *dic in model.rules) {
        NSArray *keyArr = [dic allKeys];
        NSString *valueKey = [dic objectForKey:[keyArr firstObject]];
        NSString *value = [dic objectForKey:[keyArr lastObject]];
        NSString *appendingStr = [valueKey stringByAppendingFormat:@"-%@",value];
        if (rulersStr.length > 0) {
            [rulersStr appendString:@"#"];
        }
        [rulersStr appendString:appendingStr];
    }
    
    NSInteger all_num = [self.upLoadDataList allKeys].count == 6 ? [[self.upLoadDataList objectForKey:@"allPerson"] integerValue] : [model.max_user_amount integerValue];
    NSInteger all_goods = [self.upLoadDataList allKeys].count == 6 ? [[self.upLoadDataList objectForKey:@"allGoodsNum"] integerValue] : [model.max_copies_amount integerValue];
    NSInteger limit = [self.upLoadDataList allKeys].count == 6 ? [[self.upLoadDataList objectForKey:@"everoneBuyNum"] integerValue]: [model.each_amount integerValue];
    
    //设置限制 没人限购数量 <= 商品总数量
    if ( limit <= all_goods) {
        
        NSDictionary *params = @{
                                 @"user_id":UserId,
                                 @"tmp_id":model.ID,
                                 @"tuan_title":[self.upLoadDataList objectForKey:@"groupName"],
                                 @"start_time":[self.upLoadDataList objectForKey:@"startTime"],
                                 @"end_time":[self.upLoadDataList objectForKey:@"endTime"],
                                 @"max_num":[NSString stringWithFormat:@"%ld",all_num],
                                 @"total_num":[NSString stringWithFormat:@"%ld",all_goods],
                                 @"limit_num":[NSString stringWithFormat:@"%ld",limit],
                                 @"rule":rulersStr
                                 };
        
        //        NSLog(@"+++++%@",params);
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:URLDependByBaseURL(@"/Api/Groupon/SubmitTuanInfo") parameters:@{@"token":[params paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
            if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                
                [AlertTool alertTitle:@"提示" mesasge:[responseObject objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                    
                    
                    GSCreateGroupViewController *createGroupViewController = [weakSelf.navigationController viewControllers][weakSelf.navigationController.viewControllers.count - 2];
                    [createGroupViewController scrollToMyGroupWithRefresh:YES];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                    
                    
                    
                    
                } viewController:weakSelf];
                
                
            }else {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                //            [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }else {
        [self alertAction];
    }
    
    
}



#pragma mark - setter and getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.backgroundColor = MyColor;
        _tableView.separatorStyle = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alertAction {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"数量有误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

@end
