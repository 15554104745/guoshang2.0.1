//
//  GSBusinessCarViewController.m
//  guoshang
//
//  Created by chenlei on 16/7/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSBusinessCarViewController.h"
#import "GSCarCell.h"
#import "GSCarModel.h"
#import "GSCarEditCell.h"
//#import "FootAccountView.h"
//#import "LoginViewController.h"
#import "GSNewLoginViewController.h"
#import "GoodsShowViewController.h"
#import "GoodsDetailViewController.h"
#import "MBProgressHUD.h"
#import "GSChackOutOrderViewController.h"

#define DELEURL  URLDependByBaseURL(@"/Api/RepositoryCart/drop_cart_goods")
#define CHAGEURL URLDependByBaseURL(@"/Api/RepositoryCart/update_goods_cart")
@interface GSBusinessCarViewController ()<UIPopoverPresentationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _dataArray;//展示数据源
    UITableView * _tabelView;
    UIButton * _selectAllBtn;//全选按钮
    NSMutableArray * _selectGoods;//已选的商品信息
    UIView * _accontView;
    LNButton * _loginBtn;
    
}

@property(nonatomic,strong)UIButton *editBtn;//编辑按钮

@end

@implementation GSBusinessCarViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor  = GS_Business_NavBarColor;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"enter"]!= nil) {
        
        for (UIView * suView in self.view.subviews) {
            [suView removeFromSuperview];
        }
        _editBtn.selected = NO;
        _editBtn.userInteractionEnabled = YES;
        if (_dataArray.count>0) {
            [_dataArray removeAllObjects];
        }
        
        [self createData];
        //_selectGoods = [NSMutableArray arrayWithArray:_dataArray];
        if (_dataArray.count>0) {
            _selectAllBtn.selected = YES;
        }else{
            _selectAllBtn.selected = NO;
        }
        [self createUI];
        [self countPrice];
        
        
    }else{
        
        for (UIView * suView in self.view.subviews) {
            [suView removeFromSuperview];
        }
        _editBtn.userInteractionEnabled = NO;
        [self createLogin];
    }
    
    //开始时调用全选按钮，防止从下一个界面返回时价格不为空；
    [self toSelectAll:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    
    self.view.backgroundColor = MyColor;
    self.title = @"进货单";
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    //     [self createData];
    [self createItems];
    _editBtn.selected = NO;
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"] != nil) {
        _selectAllBtn.selected = YES;
        
        [self createUI];
        
    }else{
        
        [self createLogin];
    }
    
}


#pragma mark - 未登录的时候显示
-(void)createLogin{
    
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    backgroundView.tag = 100;
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noLogin"]];
    img.center = CGPointMake(Width/2.0, Height/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [backgroundView addSubview:img];
    _loginBtn = [LNButton buttonWithFrame:CGRectMake((Width-100)/2.0, Height/2.0 + 10, 100, 40) Type:UIButtonTypeSystem Title:@"请先登录" Font:17.0 Target:self AndAction:@selector(toLogin)];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    _loginBtn.backgroundColor = NewRedColor;
    _loginBtn.layer.cornerRadius = 10;
    _loginBtn.clipsToBounds = YES;
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_loginBtn];
    
}

-(void)toLogin{
    GSNewLoginViewController * myLogin =[[GSNewLoginViewController alloc] init];
    myLogin.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myLogin animated:YES];
    
}

-(void)createItems{
    
    //    UIBarButtonItem * backItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"fanhui"] highlightedImage:nil target:self action:@selector(toHome:) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = backItem;
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setBackgroundImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    [_editBtn setBackgroundImage:[UIImage imageNamed:@"selectIdit"] forState:UIControlStateSelected];
    _editBtn.frame = CGRectMake(0, 0, 20, 20);
    _editBtn.tag = 200;
    _editBtn.showsTouchWhenHighlighted = NO;
    
    [_editBtn addTarget:self action:@selector(toEdit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *idit = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    //    UIBarButtonItem * popItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"分类"] highlightedImage:nil target:self action:@selector(toPop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = idit;
}


-(void)createAccountBar{
    
    __weak typeof (self) weakSelf = self;
    _accontView = [[UIView alloc] init];
    _accontView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_accontView];
    [_accontView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.view.mas_width);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(@40);
    }];
    
    _selectAllBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [_selectAllBtn setImage:[UIImage imageNamed:@"newSele"] forState:UIControlStateNormal];
    [_selectAllBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    _selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_selectAllBtn setTitleColor:NewRedColor forState:UIControlStateNormal];
    [_selectAllBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [_selectAllBtn addTarget:self action:@selector(toSelectAll:) forControlEvents:UIControlEventTouchUpInside];
//    _selectAllBtn.selected = YES;
    
        if (_selectGoods.count == _dataArray.count) {
            _selectAllBtn.selected = YES;
        }else{
            _selectAllBtn.selected = NO;
        }

    [_accontView addSubview:_selectAllBtn];
    [_selectAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accontView.mas_top).offset(10);
        make.left.equalTo(_accontView.mas_left).offset(10);
        make.width.equalTo(@56);
        make.height.equalTo(@25);
    }];
    
    //    UILabel * allLable = [[UILabel alloc] init];
    //    allLable.text = @"全选";
    //    allLable.textColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0];
    //    allLable.font = [UIFont systemFontOfSize:15];
    //    [_accontView addSubview:allLable];
    //    [allLable mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_accontView.mas_top).offset(10);
    //        make.left.equalTo(_selectAllBtn.mas_right).offset(5);
    //        make.width.equalTo(@40);
    //        make.height.equalTo(@15);
    //    }];
    
    UIButton * buyButton = [[UIButton alloc] init];
    buyButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0];
    if (_editBtn.selected == NO ) {
        [buyButton setTitle:@"去结算" forState:UIControlStateNormal];
    }else{
        [buyButton setTitle:@"批量删除" forState:UIControlStateNormal];
    }
    [buyButton addTarget:self action:@selector(topPayMoney:) forControlEvents:UIControlEventTouchUpInside];
    [_accontView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accontView.mas_top);
        make.right.equalTo(_accontView.mas_right);
        make.bottom.equalTo(_accontView.mas_bottom);
        make.width.equalTo(@93);
    }];
    
    UIImageView *iamge = [[UIImageView alloc]init];
    iamge.image = [UIImage imageNamed:@"xuxian"];
    [_accontView addSubview:iamge];
    [iamge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buyButton.mas_top);
        make.left.equalTo(_accontView.mas_left);
        make.right.equalTo(buyButton.mas_left);
        make.height.equalTo(@1);
    }];
    
    UILabel * pricelabel = [[UILabel alloc] init];
    pricelabel.tag = 3;
    pricelabel.textAlignment = NSTextAlignmentRight;
    pricelabel.textColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0];
    pricelabel.font = [UIFont systemFontOfSize:15];
    [_accontView addSubview:pricelabel];
    [pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buyButton.mas_left).offset(-5);
        make.top.equalTo(_accontView.mas_top).offset(10);
        make.height.equalTo(@10);
        make.left.equalTo(_selectAllBtn.mas_right).offset(10);
    }];
    
    UILabel *freightLabel = [[UILabel alloc] init];
    freightLabel.tag = 4;
    freightLabel.textAlignment = NSTextAlignmentRight;
    freightLabel.textColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1.0];
    freightLabel.font = [UIFont systemFontOfSize:15];
    [_accontView addSubview:freightLabel];
    [freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buyButton.mas_left).offset(-5);
        make.top.equalTo(pricelabel.mas_bottom).offset(5);
        make.left.equalTo(_selectAllBtn.mas_right).offset(10);
        make.height.equalTo(pricelabel);
    }];
    
    [self countPrice];
    
}



-(void)toSelectAll:(UIButton *)button{
    button.selected = !button.selected;
    [_selectGoods removeAllObjects];
    if (button.selected) {
        for (NSArray * array in _dataArray) {
            for (GSCarModel *model in array) {
                model.isSelect = YES;
                [_selectGoods addObject:model];
            }
            
        }
    }else{
        
        for (NSArray * array in _dataArray) {
            for (GSCarModel *model in array) {
                model.isSelect = NO;
            }
        }
        
        [_selectGoods removeAllObjects];
    }
    
    if (_editBtn.selected ==YES) {
        
        [_tabelView reloadData];
        
    }else{
        
        [_tabelView reloadData];
        
    }
    
    
    [self countPrice];
}

-(void)createData{
    
    
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:[[UIApplication sharedApplication].delegate window]];
    
    if (GS_Business_Shop_id) {
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:URLDependByBaseURL(@"/Api/RepositoryCart/cart") parameters:@{@"token":[@{@"shop_id":GS_Business_Shop_id} paramsDictionaryAddSaltString]} success:^(id responseObject) {
            //            NSLog(@"%@",[responseObject objectForKey:@"message"]);
            [MBProgressHUD hideHUDForView:weakSelf.navigationController.view.window animated:NO];
            
            if ([responseObject[@"status"]isEqualToNumber:@0]) {
                NSMutableDictionary * rootDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"result"]];
                NSArray * array = rootDic[@"goods_list"];
                
                if (array.count > 0) {
                    
                    NSMutableDictionary *shopTitleDic = [[NSMutableDictionary alloc] initWithCapacity:0];
                    for (NSDictionary * dic  in array) {
                        
                        NSMutableDictionary *  dict = [NSMutableDictionary dictionaryWithDictionary:dic];
                        NSNumber * boolNumber = [NSNumber numberWithBool:YES];
                        
                        [dict setValue:boolNumber forKey:@"isSelect"];
                        
                        GSCarModel * model = [GSCarModel ModelWithDict:dict];
                        //                        NSLog(@"%@",dic);
                        if (!_selectGoods) {
                            _selectGoods = [[NSMutableArray alloc] initWithCapacity:0];
                        }
                        [_selectGoods addObject:model];
                        if (![shopTitleDic objectForKey:model.shop_title]) {
                            NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:0];
                            [mArray addObject:model];
                            [shopTitleDic setObject:mArray forKey:model.shop_title];
                        } else {
                            [[shopTitleDic objectForKey:model.shop_title] addObject:model];
                        }
                    }
                    for (NSString *title in [shopTitleDic allKeys]) {
                        if (!_dataArray) {
                            _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
                        }
                        [_dataArray addObject:shopTitleDic[title]];
                    };
                    
                    
                    //设置全选的选中状态为全选状态
                    _selectAllBtn.selected = YES;
                    [_tabelView reloadData];
                    
                    [weakSelf createAccountBar];
                    
                }
                
                
            }else{
                _editBtn.userInteractionEnabled = NO;
                [weakSelf cartEmptyShow];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.navigationController.view.window animated:NO];
        }];
        
    }else {
        
        
        [AlertTool alertMesasge:@"确定" confirmHandler:nil viewController:self];
        
    }
    
}

#pragma mark -结算button的实现
-(void)topPayMoney:(UIButton *)sender{
    NSString * str = sender.currentTitle;
    
    //判断是否有商品，有商品才能结算，没有商品提示
    if(_selectGoods.count> 0){
        if ([str isEqualToString:@"去结算"] ) {
            
            
            GSChackOutOrderViewController *chackOutOrder = ViewController_in_Storyboard(@"Main", @"GSChackOutOrderViewController");
            chackOutOrder.chackOutOrderType = GSChackOutOrderTypeBusiness;
            chackOutOrder.hidesBottomBarWhenPushed = YES;
            
            NSString * tokenStr;
            
            for (int i = 0; i< _selectGoods.count; i++) {
                GSCarModel * model = _selectGoods[i];
                if (i==0) {
                    tokenStr = [NSString stringWithFormat:@"%@",model.rec_id];
                }else{
                    tokenStr = [tokenStr stringByAppendingFormat:@"#%@",model.rec_id];
                }
            }

            chackOutOrder.tokenStr = tokenStr;
            [self.navigationController pushViewController:chackOutOrder animated:YES];
            /*
            GSCarMoneyViewController * money = [[GSCarMoneyViewController alloc] init];
            money.hidesBottomBarWhenPushed = YES;
            money.tokenStr = tokenStr;
             */
        }else if([str isEqualToString:@"批量删除"]){
            [AlertTool alertTitle:@"确定要删除吗？" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                if (_selectAllBtn.selected == YES) {
                    
                    for (NSArray * array in _dataArray) {
                        for (GSCarModel *model in array) {
                            NSString *tokenStr = [NSString stringWithFormat:@"rec_id=%@,shop_id=%@",model.rec_id, GS_Business_Shop_id];
                            
                            [self httpWithHttpUrl:DELEURL AndToken:tokenStr];
                        }
                        
                    }
                    
                    [_selectGoods removeAllObjects];
                    [_dataArray removeAllObjects];
                    [_tabelView reloadData];
                    _selectAllBtn.selected = NO;
                    
                    if (_dataArray.count > 0) {
                        [self countPrice];
                    }else{
                        _editBtn.selected = NO;
                        _editBtn.userInteractionEnabled = NO;
                        _accontView.hidden = YES;
                        [self cartEmptyShow];
                    }
                    
                }else if (_selectGoods.count > 0){
                    for (GSCarModel * model  in _selectGoods) {
                        
                        NSString *tokenStr = [NSString stringWithFormat:@"rec_id=%@,shop_id=%@",model.rec_id, GS_Business_Shop_id];
                        
                        [self httpWithHttpUrl:DELEURL AndToken:tokenStr];
                        
                        for (NSMutableArray *array in _dataArray) {
                            if ([array containsObject:model]) {
                                [array removeObject:model];
                                if (array.count == 0) {
                                    [_dataArray removeObject:array];
                                }
                            }
                        }
                        
                        
                        
                        
                        
                    }
                    //删除选中商品中的数据
                    for (NSArray * array in _dataArray) {
                        for (GSCarModel *model in array) {
                            if (![_selectGoods containsObject:model]) {
                                
                                [_selectGoods removeObject:model];
                            }
                        }
                    }
                    [self countPrice];
                    
                }
                
            } cancleHandler:^(UIAlertAction *action) {
                
            } viewController:self];
            
            
        }
        
    }
    
}

-(void)createUI{
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - 153) style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabelView.estimatedRowHeight = 68.0;  _tabelView.rowHeight = UITableViewAutomaticDimension;
    [_tabelView registerNib:[UINib nibWithNibName:@"GSCarEditCell" bundle:nil] forCellReuseIdentifier:@"GSEdit"];
    
    [_tabelView registerNib:[UINib nibWithNibName:@"GSCarCell" bundle:nil] forCellReuseIdentifier:@"GSCarCell"];
    
    [_tabelView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    
    [self.view addSubview:_tabelView];
    
    
}


//购物车为空时的默认视图
-(void)cartEmptyShow
{
    if (_accontView!=nil) {
        _accontView.hidden = YES;
    }
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    backgroundView.tag = 100;
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noLogin"]];
    img.center = CGPointMake(Width/2.0, Height/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.center = CGPointMake(Width/2.0, Height/2.0 - 10);
    warnLabel.bounds = CGRectMake(0, 0, Width, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车好空,买点什么呗!";
    warnLabel.font = [UIFont systemFontOfSize:17];
    warnLabel.textColor = kUIColorFromRGB(0x706F6F);
    [backgroundView addSubview:warnLabel];
    
    //默认视图按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.center = CGPointMake(Width/2.0, Height/2.0 + 40);
    btn.bounds = CGRectMake(0, 0,  110, 40);
    btn.layer.cornerRadius = 10;
    btn.clipsToBounds = YES;
    [btn setBackgroundColor:NewRedColor];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setTitle:@"去购买" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btn addTarget:self action:@selector(goToMainmenuView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    
}
-(void)goToMainmenuView
{
    self.tabBarController.selectedIndex = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    NSInteger index = [_dataArray[section] count];
    
    return [_dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSCarModel * model = _dataArray[indexPath.section][indexPath.row];
    
    if (_editBtn.selected == YES) {
        
        
        GSCarEditCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GSEdit" forIndexPath:indexPath];
        
        
        cell.model = model;
        
        
        
        if ([_selectGoods containsObject:[_dataArray objectAtIndex:indexPath.section][indexPath.row]]) {
            model.isSelect = YES;
            cell.delectBtn.userInteractionEnabled = YES;
            
            
        }else{
            model.isSelect = NO;
            cell.delectBtn.userInteractionEnabled = NO;
        }
        
        
        __block GSCarEditCell * weakCell = cell;
        
        weakCell.gsCarBlock = ^(BOOL isSelec){
            if (isSelec) {
                cell.delectBtn.userInteractionEnabled = YES;
                
                model.isSelect = YES;
                [_selectGoods addObject:[_dataArray objectAtIndex:indexPath.section][indexPath.row]];
            }else{
                
                cell.delectBtn.userInteractionEnabled = NO;
                model.isSelect = NO;
                [_selectGoods removeObject:[_dataArray objectAtIndex:indexPath.section][indexPath.row]];
            }
            
            NSInteger dataArrayCount = 0;
            for (NSArray *array in _dataArray) {
                dataArrayCount += array.count;
            }
            
            if (_selectGoods.count == dataArrayCount) {
                
                _selectAllBtn.selected = YES;
            }else{
                _selectAllBtn.selected = NO;
            }
            
            [self countPrice];
            
        };
        
        
        if (cell.delectBtn.userInteractionEnabled == YES) {
            __weak typeof(self) weakSelf = self;
            weakCell.gsDeleteBlock = ^(){
                [AlertTool alertTitle:@"确定要删除吗？" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                    for (NSMutableArray *array in _dataArray) {
                        
                        
                        //删除数据源数组中的数组
                        if ([array containsObject:model]) {
                            
                            //                        NSString *tokenStr = [NSString stringWithFormat:@"rec_id=%@,user_id=%@",model.rec_id, [[NSUserDefaults standardUserDefaults] objectForKey:@"enter"]];
                            //
                            NSDictionary *dic = @{@"rec_id":model.rec_id,
                                                  @"shop_id":GS_Business_Shop_id};
                            
                            [HttpTool POST:URLDependByBaseURL(@"/Api/RepositoryCart/drop_cart_goods") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
                                
                                //                            NSLog(@"%@",[responseObject objectForKey:@"message"]);
                                
                            } failure:^(NSError *error) {
                                
                            }];
                            
                            //                        [self httpWithHttpUrl:DELEURL AndToken:tokenStr];
                            [array removeObject:model];
                            
                            
                        }
                        
                        
                        
                        //删除选中商品数组中的数组
                        if ([_selectGoods containsObject:model]) {
                            
                            [_selectGoods removeObject:model];
                        }
                        
                        
                        if (_dataArray.count > 0) {
                            [weakSelf countPrice];
                        }else{
                            
                            _editBtn.selected = NO;
                            _editBtn.userInteractionEnabled = NO;
                            _accontView.hidden = YES;
                            [weakSelf cartEmptyShow];
                        }
                        
                        
                        
                        //[self performSelector:@selector(reloadTabel) withObject:nil afterDelay:0.5];
                    }
                    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj count] == 0) {
                            [_dataArray removeObject:obj];
                        }
                    }];
                    [_tabelView reloadData];
                    
                    
                } cancleHandler:^(UIAlertAction *action) {
                    
                } viewController:weakSelf];
                
            };
            
        }
        if (_dataArray.count > 0) {
            [self countPrice];
        }else{
            _editBtn.selected = NO;
            _accontView.hidden = YES;
            _editBtn.userInteractionEnabled = NO;
            [self cartEmptyShow];
        }
        [cell reloadDeleteDataWith:_dataArray[indexPath.section][indexPath.row]];
        return cell;
        
    }else{
        
        GSCarCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GSCarCell" forIndexPath:indexPath];
        cell.model = model;
        
        //判断选中状态
        if ([_selectGoods containsObject:[_dataArray objectAtIndex:indexPath.section][indexPath.row]]) {
            model.isSelect = YES;
            
        }
        __weak typeof(self) weakSelf = self;
        cell.gsCarBlock = ^(BOOL isSelec){
            if (isSelec) {
                model.isSelect = YES;
                [_selectGoods addObject:[_dataArray objectAtIndex:indexPath.section][indexPath.row]];
            }else{
                model.isSelect = NO;
                [_selectGoods removeObject:[_dataArray objectAtIndex:indexPath.section][indexPath.row]];
            }
            if (_selectGoods.count == [_dataArray[indexPath.section] count]) {
                _selectAllBtn.selected = YES;
            }else{
                _selectAllBtn.selected = NO;
            }
            
            [weakSelf countPrice];
        };
        
        
        __block GSCarCell * weakCell = cell;
        
        
        //加方法
        cell.numAddBlock = ^(){
            //数量
            NSString * str = weakCell.numLable.text;
            NSArray * countArray = [str componentsSeparatedByString:@"*"];
            NSString * countStr = [NSString stringWithFormat:@"%@",countArray[1]];
            NSInteger count = [countStr integerValue];
            count++;
            NSString  *numStr = [NSString stringWithFormat:@"%ld",(long)count];
            NSString * tokenStr = [NSString stringWithFormat:@"rec_id=%@,num=%@",model.rec_id,numStr];
            NSString * encryptString = [tokenStr encryptStringWithKey:KEY];
            [HttpTool POST:CHAGEURL parameters:@{@"token":encryptString} success:^(id responseObject) {
                if ([responseObject[@"status"] isEqualToNumber:@0]) {
                    GSCarModel * model = _dataArray[indexPath.section][indexPath.row];
                    weakCell.numLable.text = [NSString stringWithFormat:@"* %@",numStr];
                    weakCell.numberLable.text = numStr;
                    
                    // NSString * preStr = weakCell.priceLabel.text;
                    // NSArray * priceArray = [preStr componentsSeparatedByString:@"￥"];
                    // NSString * priceStr = [NSString stringWithFormat:@"%@",priceArray[1]];
//                    NSString *priceStr = model.d_price;
//                    CGFloat  price = [priceStr floatValue]/[model.goods_number integerValue];
//                    CGFloat  coin = price * count;
//                    weakCell.coinLabel.text = [NSString stringWithFormat:@"%.0f个",coin];
//                    model.d_price = [NSString stringWithFormat:@"%.0f",coin];
                    model.goods_number = [NSString stringWithFormat:@"%ld",(long)count];
                    NSMutableArray *modelArr = [NSMutableArray arrayWithArray:[_dataArray objectAtIndex:indexPath.section]];
                    [modelArr replaceObjectAtIndex:indexPath.row withObject:model];
                    [_dataArray replaceObjectAtIndex:indexPath.section withObject:modelArr];
                    if ([_selectGoods containsObject:model]) {
                        [_selectGoods removeObject:model];
                        [_selectGoods addObject:model];
                        
                        [weakSelf countPrice];
                    }
                    
                }else if ([responseObject[@"status"] isEqualToNumber:@1]){
                    
                }else if ([responseObject[@"status"] isEqualToNumber:@2]){
                    
                    
                    [AlertTool alertTitle:@"库存不足" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
                    } viewController:weakSelf];
                }
                
                
                
            } failure:^(NSError *error) {
                
            }];
            
            
            
        };
        
        
        
        //减方法
        cell.numCutBlock =^(){
            
            NSString * str = weakCell.numLable.text;
            NSArray * countArray = [str componentsSeparatedByString:@"*"];
            NSString * countStr = [NSString stringWithFormat:@"%@",countArray[1]];
            NSInteger count = [countStr integerValue];
            
            count--;
            if(count <= 0){
                return ;
            }
            NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
            
            GSCarModel *model = _dataArray[indexPath.section][indexPath.row];
            //            NSString * preStr = weakCell.priceLabel.text;
            //            NSArray * priceArray = [preStr componentsSeparatedByString:@"￥"];
            //            NSString * priceStr = [NSString stringWithFormat:@"%@",priceArray[1]];
//            NSString *priceStr = model.d_price;
//            CGFloat  price = [priceStr floatValue]/[model.goods_number integerValue];
//            CGFloat  coin = price * count;
//            weakCell.coinLabel.text = [NSString stringWithFormat:@"%.0f个",coin];
            
            weakCell.numLable.text = [NSString stringWithFormat:@"* %@",numStr];
            weakCell.numberLable.text = numStr;
            model.goods_number = [NSString stringWithFormat:@"%ld",count];
            
//            model.d_price = [NSString stringWithFormat:@"%.0f",coin];
            model.goods_number = [NSString stringWithFormat:@"%ld",count];
            NSMutableArray *modelArr = [NSMutableArray arrayWithArray:[_dataArray objectAtIndex:indexPath.section]];
            [modelArr replaceObjectAtIndex:indexPath.row withObject:model];
            [_dataArray replaceObjectAtIndex:indexPath.section withObject:modelArr];
            //判断已选择数组里有无该对象,有就删除  重新添加
            if ([_selectGoods containsObject:model]) {
                [_selectGoods removeObject:model];
                [_selectGoods addObject:model];
                [weakSelf countPrice];
            }
            
            NSString * tokenStr = [NSString stringWithFormat:@"rec_id=%@,num=%@",model.rec_id,numStr];
            
            [weakSelf httpWithHttpUrl:CHAGEURL AndToken:tokenStr];
        };
        
        [self countPrice];
        
        [cell reloadDataWith:[_dataArray[indexPath.section] objectAtIndex:indexPath.row]];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0f;
}

-(void)reloadTabel{
    
    [_tabelView reloadData];
    
}
-(void)countPrice{
    double totlePrice = 0.0,totleFeight = 0.0;
    UILabel * priceLable = [self.view viewWithTag:3];
    UILabel * fieghtLable = (UILabel *)[self.view viewWithTag:4];
    for (GSCarModel *model in _selectGoods) {
        NSString * str = [model.goods_price substringFromIndex:1];
        double price = [str doubleValue];
        double fieght = [model.shipping_price isKindOfClass:[NSNull class]]?0:[model.shipping_price doubleValue];
        
        totlePrice += price * [model.goods_number floatValue];
        totleFeight += fieght;
    }
    priceLable.text = [NSString stringWithFormat:@"合计：%.2f",totlePrice+totleFeight];
    fieghtLable.text = [NSString stringWithFormat:@"（含运费：%.2f)",totleFeight];
    
}

//-(void)toHome:(UIButton *)button{
//
//    self.tabBarController.selectedIndex = 0;
//}

//编辑按钮的实现
-(void)toEdit:(UIButton *)button{
    
    [_tabelView reloadData];
    
    if (_accontView!=nil) {
        [_accontView removeFromSuperview];
    }
    button.selected = !button.selected;
    [self createAccountBar];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击cell  让颜色变回来
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //GSCarModel * model = _dataArray[indexPath.section][indexPath.row];
#warning 详情页
    
//    GoodsDetailViewController * goodsShow = [GoodsDetailViewController createGoodsDetailView];
//    goodsShow.hidesBottomBarWhenPushed = YES;
//    
//    goodsShow.goodsId = model.goods_id;
//    
//    [self.navigationController pushViewController:goodsShow animated:YES];
    
}

#pragma mark - 侧滑删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_editBtn.selected == YES) {
        
        return UITableViewCellEditingStyleDelete;
        
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //服务器发送请求告诉服务请数据删除
    [AlertTool alertTitle:@"确定要删除吗？" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
        GSCarModel * model = _dataArray[indexPath.section][indexPath.row];
        
        //进行网络请求
        
        NSString *tokenStr = [NSString stringWithFormat:@"rec_id=%@,user_id=%@",model.rec_id, [[NSUserDefaults standardUserDefaults] objectForKey:@"enter"]];
        
        NSInteger stats =  [self httpWithHttpUrl:DELEURL AndToken:tokenStr];
        
        switch (stats) {
            case 0:{
                //删除tabView
                [_tabelView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self performSelector:@selector(reloadTabel) withObject:nil afterDelay:0.5];
                [_dataArray[indexPath.section] removeObjectAtIndex:indexPath.row];
                //删除数据源
                if ([_selectGoods containsObject:model]) {
                    
                    [_selectGoods removeObject:model];
                }
                
                
                if (_dataArray.count > 0) {
                    
                    _accontView.hidden = YES;
                    
                }else{
                    
                    [self countPrice];
                    
                }
            }
                
                break;
            case 1:{
                
                [AlertTool alertMesasge:@"删除失败,请重试" confirmHandler:^(UIAlertAction *action) {
                    
                } viewController:self];
                
            }
            default:
                break;
        }
        
    } cancleHandler:^(UIAlertAction *action) {
        
    } viewController:self];
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"从购物车移除";
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    [[header.contentView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopuser"]];
    [header.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(header.contentView.mas_centerY);
    }];
    
    GSCarModel *model = _dataArray[section][0];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor lightGrayColor];
    label.text = model.shop_title;
    [header.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(5);
        make.centerY.equalTo(header.contentView.mas_centerY);
    }];
    
    return header;
}


#pragma mark - 网络请求
-(NSInteger )httpWithHttpUrl:(NSString *)urlStr AndToken:(NSString *)tokenStr{
    
    NSString * encryptString = [tokenStr encryptStringWithKey:KEY];
    __block NSInteger  status ;
    [HttpTool POST:urlStr parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        //        NSLog(@"%@",responseObject[@"status"]);
        
        status =   [responseObject[@"status"] integerValue];
        
        if ([responseObject[@"status"] isEqualToNumber:@0]) {
            
            [_tabelView reloadData];
        }else if ([responseObject[@"status"] isEqualToNumber:@1]){
            [_tabelView reloadData];
            
        }else if ([responseObject[@"status"] isEqualToNumber:@2]){
            
            [_tabelView reloadData];
            //            [AlertTool alertTitle:@"库存不足" mesasge:nil preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *action) {
            //            } viewController:self];
            
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    return status;
    
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
