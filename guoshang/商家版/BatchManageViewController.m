//
//  BatchManageViewController.m
//  guoshang
//
//  Created by 孙涛 on 16/8/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "BatchManageViewController.h"
#import "BatchManageModel.h"
#import "BatchTableViewCell.h"

@interface BatchManageViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_saveDateList; //保存用户选择的数据
    BOOL isSelected;
    int page;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *allSelectBtn;
@property (nonatomic, strong)NSMutableArray *goodsIdArr;
@property (nonatomic, strong)NSMutableArray *goodsArr;
//@property (nonatomic, strong)BatchManageModel *batchModel;
@end

static NSString *cellIdentifier = @"cellIndentifier";

@implementation BatchManageViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)createNavigationItem {
    //创建导航栏
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    navBarView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:navBarView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((Width -100)*0.5 , 20, 100, 44)];
    titleLabel.text = @"批量管理";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navBarView addSubview:titleLabel];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 22, 40, 40)];
    leftBtn.tag = 807;
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    [self.view addSubview:self.tableView];
    [self createNavigationItem];
    
    [self createFooterView];
}

- (void)loadData {
    
    page ++;
    [self loadDate1With:page];
}

- (NSString *)getGoodsIdString {
    
    NSString *goodsIdStr;
    for (NSString *str in self.goodsIdArr) {
        
        if ([str isEqualToString:[self.goodsIdArr firstObject]]) {
            goodsIdStr = [NSString stringWithFormat:@"%@",str];
        }else {
        goodsIdStr = [NSString stringWithFormat:@"%@#%@",goodsIdStr,str];
        }
    }
    return goodsIdStr;
}

//获取总的数据
- (void)loadDate1With:(int)pagetag {
    
    if (pagetag == 1) {
        [self.goodsArr removeAllObjects];
        [self.tableView reloadData];
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!=nil) {
        
        NSString *pagestr = [NSString stringWithFormat:@"%d",pagetag];
        NSDictionary *dic = @{@"shop_id":GS_Business_Shop_id,    //修改shopID 42
                              @"is_onsale":@1,
                              @"page":pagestr,
                              };
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/GoodsList") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
            if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                
                NSArray *dataList = [responseObject objectForKey:@"result"];
                
                for (int i = 0; i < dataList.count; i++) {
                    
                    BatchManageModel *model = [[BatchManageModel alloc]initWithContentDic:dataList[i]];
                    
                    [weakSelf.goodsArr addObject:model];
                }
                
                if (dataList.count < 10) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
                [weakSelf.tableView reloadData];
                
            }else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
            [weakSelf.tableView.mj_header endRefreshing];
            
        } failure:^(NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];

        }];
    }
    
}


/**
 *  下架选中的商品
 */
- (void)downGoods {
    
    NSString *str = [self getGoodsIdString];
//    NSLog(@"下架的商品ID为： %@",str);
    
    if (str != nil) {
        
        
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!=nil) {
        
        NSDictionary *dic = @{@"shop_id":GS_Business_Shop_id,
                              @"goods_id":str  //拼接商品ID  多个以#分开
                              };
        __weak typeof(self) weakSelf = self;
         [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/BatchStopSale") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
             if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            _dataList = [responseObject objectForKey:@"result"];
             
             [weakSelf loadDate1With:1]; //刷新数据
             
             [weakSelf underGoodsInfowith:[responseObject objectForKey:@"status"]]; //下架商品
            
             }
             
        } failure:^(NSError *error) {
            
        }];
     }
    }
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, Width, Height-44) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 8;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableFooterView = [self createFooterView];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self loadDate1With:1];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadData];
        }];
        [_tableView registerNib:[UINib nibWithNibName:@"BatchTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

- (void)createFooterView {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, Height - 40, Width, 40)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    //添加一个全选文本框标签
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"全选";
    [footView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footView.mas_right).offset(-80);
        make.top.equalTo(footView.mas_top).offset(5);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    
    //添加全选图片按钮
    _allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allSelectBtn.selected = NO;
    [_allSelectBtn setImage:[UIImage imageNamed:@"weixuanzhong.png"] forState:UIControlStateNormal];
    [_allSelectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_allSelectBtn];
    [_allSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lab.mas_left).offset(-10);
//        make.top.equalTo(lab.mas_top).offset(5);
        make.centerY.equalTo(lab.mas_centerY);
        make.width.height.mas_offset(30);
    }];
    
    //添加一个下架按钮
    UIButton *underButton = [UIButton buttonWithType:UIButtonTypeCustom];
    underButton.backgroundColor = [UIColor redColor];
    underButton.layer.cornerRadius = 5;
    underButton.clipsToBounds = YES;
    [underButton setTitle:@"下架" forState:UIControlStateNormal];
    [underButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [underButton addTarget:self action:@selector(underButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:underButton];
    [underButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footView.mas_right).offset(-10);
        make.top.equalTo(footView.mas_top).offset(5);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
        
    }];
    
}

-(void)selectBtnClick:(UIButton *)sender{
    
    [self.goodsIdArr removeAllObjects];
    //判断是否选中，是改成否，否改成是，改变图片状态
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        [sender setImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateNormal];
        for (int i=0; i<self.goodsArr.count; i++)
        {
            BatchManageModel *model = self.goodsArr[i];
            [self.goodsIdArr addObject:model.goods_id];
        }
        
    }else{
        [sender setImage:[UIImage imageNamed:@"weixuanzhong.png"] forState:UIControlStateNormal];
        
    }
    //改变单元格选中状态
    for (int i=0; i<self.goodsArr.count; i++)
    {
        BatchManageModel *model = self.goodsArr[i];
        model.selectState = sender.selected;
    }
    //刷新表格
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
     BatchManageModel *model = [self.goodsArr objectAtIndex:indexPath.section];
    
    cell.dateModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BatchManageModel *model = self.goodsArr[indexPath.section];
    if (model.selectState) {
        model.selectState = NO;
        [self.goodsIdArr removeObject:model.goods_id];
        
    }else {
        model.selectState = YES;
        [self.goodsIdArr addObject:model.goods_id];

    }
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 142;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ( self.goodsArr.count == section+1) {
        return 0.01;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.goodsArr.count;
}
//下架商品提示
- (void)underButtonAction:(UIButton *)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定下架该商品吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self downGoods]; //下架选中的商品
        
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

//下架商品成功提示
- (void)underGoodsInfowith:(NSString *)status {
    
    NSString *str;
    if ([status integerValue] == 0) {
        str = @"批量下架成功";
    }else {
        str = @"批量下架失败";
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}
- (void)addButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - settter and getter
- (NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}- (NSMutableArray *)goodsIdArr {
    if (!_goodsIdArr) {
        _goodsIdArr = [NSMutableArray array];
    }
    return _goodsIdArr;
}




@end
