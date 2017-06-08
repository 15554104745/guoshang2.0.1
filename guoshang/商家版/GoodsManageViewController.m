
//  GoodsManageViewController.m
//  guoshang
//
//  Created by 孙涛 on 16/8/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsManageViewController.h"
#import "GoodsManageTableViewCell.h"
#import "IncomeViewController.h"
#import "BatchManageViewController.h"
#import "GoodsManageModel.h"
#import "GSBusinessGoodsShowViewController.h"
#import "AddGoodsViewController.h"
#import "GoodsInfoViewController.h"

#define ItemWidth ([UIScreen mainScreen].bounds.size.width -50)/4.0
#define STWeakSelf(type) __weak typeof(type) weak##type = type

@interface GoodsManageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton *_currentBtn;
    UITextField *searchTF;
    BOOL isUpSellHiden;//区分是否为库存列表，上架按钮的显示隐藏问题＝＝＝暂时弃用
    BOOL is_stock;
    
    NSMutableDictionary *dic1; //出售
    NSMutableDictionary *dic2; //异常审核
    NSMutableDictionary *dic3; //下架
    NSMutableDictionary *dic4; //库存
    NSMutableDictionary *dic5; //搜索

    NSInteger page;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataList;
@end
static NSString *identifier = @"identifier";


@implementation GoodsManageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataList;
}
- (void)createNavigationItem {
    
    //创建导航栏
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    navBarView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:navBarView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((Width -100)*0.5 , 20, 100, 44)];
    titleLabel.text = @"商品管理";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navBarView addSubview:titleLabel];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 22, 40, 40)];
    leftBtn.tag = 807;
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    
    [self createNavigationItem];
    [self createData];
//    [self loadDataWithParams:dic1 withPage:1 witiidentifier:@"header"];
    self.view.backgroundColor = MyColor;
    [self createUI];
    isUpSellHiden = YES;
}


#pragma mark - 加载数据

- (void)createData {
    dic1 = [NSMutableDictionary dictionaryWithDictionary:@{@"shop_id":GS_Business_Shop_id,   //从本地获取
                                                           @"is_onsale":@1
                                                           }];
    dic2 = [NSMutableDictionary dictionaryWithDictionary:@{@"shop_id":GS_Business_Shop_id,   //从本地获取
             @"is_check":@0,
             }];
    dic3 = [NSMutableDictionary dictionaryWithDictionary:@{@"shop_id":GS_Business_Shop_id,   //从本地获取
             @"is_onsale":@0,
             }];
    dic4 = [NSMutableDictionary dictionaryWithDictionary:@{@"shop_id":GS_Business_Shop_id,   //从本地获取
             @"type":@"stock"
             }];
}
#pragma mark - 加载数据

- (void)loadDataWithParams:(NSMutableDictionary *)paramsDic withPage:(NSInteger)index witiidentifier:(NSString *)identifier{
    

    if ([identifier isEqualToString:@"header"] && self.dataList.count > 0) {
        [self.dataList removeAllObjects];
        [self.tableView reloadData];
    }
    
    if (UserId) {
        [paramsDic setObject:[NSString stringWithFormat:@"%ld",index] forKey:@"page"];
        
        STWeakSelf(self);

        [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/GoodsList") parameters:@{@"token":[paramsDic paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
            if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                
                [weakself.dataList addObjectsFromArray:[responseObject objectForKey:@"result"]];
                
                if (weakself.dataList.count == 0) {
                    [weakself creteRemindView:[responseObject objectForKey:@"message"]];
                }
                
                [weakself.tableView reloadData];
                [weakself.tableView.mj_footer endRefreshing];
            } else if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [weakself.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
                [weakself.tableView.mj_header endRefreshing];
                [weakself creteRemindView:@"请求数据失败"];
        }];

    }
         
}

 /**
 *  创建顶部视图的输入框以及四个功能按钮
 */

- (void)createUI {
    
    UIView *titleBackView = [[UIView alloc]init];
    titleBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleBackView];
    [titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@120);
    }];
    
    searchTF = [[UITextField alloc]init];
    searchTF.placeholder = [NSString stringWithFormat:@"奶油蛋糕   "];
    searchTF.delegate = self;
    searchTF.textAlignment = NSTextAlignmentRight;
    searchTF.borderStyle = UITextBorderStyleRoundedRect;
    searchTF.font = [UIFont systemFontOfSize:14];
    searchTF.layer.cornerRadius = 5;
    searchTF.rightViewMode = UITextFieldViewModeAlways;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.rightView = (UIView *)[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fangdajing"]];
    searchTF.clipsToBounds = YES;
    [titleBackView addSubview:searchTF];
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleBackView.mas_left).offset(10);
        make.right.equalTo(titleBackView.mas_right).offset(-10);
        make.top.equalTo(titleBackView.mas_top).offset(10);
        make.height.equalTo(@30);
    }];
    
    
    UIButton *sellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sellButton.backgroundColor = [UIColor redColor];
    sellButton.layer.cornerRadius = 5;
    sellButton.clipsToBounds = YES;
    sellButton.tag = 801;
    _currentBtn = sellButton;
    sellButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sellButton setTitle:@"出售中" forState:UIControlStateNormal];
    [titleBackView addSubview:sellButton];
    [sellButton addTarget:self action:@selector(clickbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [sellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleBackView.mas_left).offset(10);
        make.bottom.equalTo(titleBackView.mas_bottom).offset(-30);
        make.width.mas_equalTo(ItemWidth);
        make.height.equalTo(@25);
    }];
    
    UIButton *examineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    examineButton.backgroundColor = [UIColor grayColor];
    examineButton.layer.cornerRadius = 5;
    examineButton.clipsToBounds = YES;
    examineButton.tag = 802;
    examineButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [examineButton setTitle:@"异常审核" forState:UIControlStateNormal];
    [titleBackView addSubview:examineButton];
    [examineButton addTarget:self action:@selector(clickbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [examineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sellButton.mas_left).offset(ItemWidth+10);
        make.bottom.equalTo(titleBackView.mas_bottom).offset(-30);
        make.width.mas_equalTo(ItemWidth);
        make.height.equalTo(@25);
    }];
    
    
    
    UIButton *undercarriageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    undercarriageButton.backgroundColor = [UIColor grayColor];
    undercarriageButton.layer.cornerRadius = 5;
    undercarriageButton.clipsToBounds = YES;
    undercarriageButton.tag = 803;
    undercarriageButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [undercarriageButton setTitle:@"下架" forState:UIControlStateNormal];
    [titleBackView addSubview:undercarriageButton];
    [undercarriageButton addTarget:self action:@selector(clickbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [undercarriageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(examineButton.mas_left).offset(ItemWidth+10);
        make.bottom.equalTo(titleBackView.mas_bottom).offset(-30);
        make.width.mas_equalTo(ItemWidth);
        make.height.equalTo(@25);
    }];
    
    
    UIButton *inventoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inventoryButton.backgroundColor = [UIColor grayColor];
    inventoryButton.layer.cornerRadius = 5;
    inventoryButton.clipsToBounds = YES;
    inventoryButton.tag = 804;
    inventoryButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [inventoryButton setTitle:@"库存" forState:UIControlStateNormal];
    [titleBackView addSubview:inventoryButton];
    [inventoryButton addTarget:self action:@selector(clickbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [inventoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(undercarriageButton.mas_left).offset(ItemWidth+10);
        make.bottom.equalTo(titleBackView.mas_bottom).offset(-30);
        make.width.mas_equalTo(ItemWidth);
        make.height.equalTo(@25);
    }];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, Height-35, Width, 35)];
    footerView.backgroundColor = MyColor;
    [self.view addSubview:footerView];
    
    //添加商品
    UIButton *addGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addGoodsButton.backgroundColor = [UIColor redColor];
    addGoodsButton.layer.cornerRadius = 5;
    addGoodsButton.clipsToBounds = YES;
    addGoodsButton.tag = 805;
    addGoodsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [addGoodsButton setTitle:@"添加商品" forState:UIControlStateNormal];
    [footerView addSubview:addGoodsButton];
    [addGoodsButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [addGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).offset(30);
        make.top.equalTo(footerView.mas_top);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    //批量管理
    UIButton *manageGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    manageGoodsButton.backgroundColor = [UIColor redColor];
    manageGoodsButton.layer.cornerRadius = 5;
    manageGoodsButton.clipsToBounds = YES;
    manageGoodsButton.tag = 806;
    manageGoodsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [manageGoodsButton setTitle:@"批量管理" forState:UIControlStateNormal];
    [footerView addSubview:manageGoodsButton];
    [manageGoodsButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [manageGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top);
        make.right.equalTo(footerView.mas_right).offset(-30);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
 

    
}

- (void)clickbuttonAction:(UIButton *)sender {
    STWeakSelf(self);
    if (_currentBtn!= sender) {
        _currentBtn.backgroundColor = [UIColor grayColor];
        sender.backgroundColor = [UIColor redColor];
    }
    // 连续刷新tableview偏移问题；强制归位
    if ([_tableView.mj_header isRefreshing]) {
        __weak typeof(self) weakSelf = self;
        [weakSelf.tableView.mj_header endRefreshing];
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.tableView.contentOffset = CGPointMake(0, 0);
        }];
    }
    NSInteger index = sender.tag - 800;
    
//            isUpSellHiden = YES;
    switch (index) {
            //出售中
        case 1: {
            is_stock = NO;

            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                // 刷新数据的接口
                [self loadDataWithParams:dic1 withPage:1 witiidentifier:@"header"];
            }];
            [self.tableView.mj_header beginRefreshing];

            page = 1;
            _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakself createRefreshDataWith:dic1];
            }];
        }
            break;
            //异常审核
        case 2:
        {
            is_stock = NO;

            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self loadDataWithParams:dic2 withPage:1 witiidentifier:@"header"];
            }];
            [self.tableView.mj_header beginRefreshing];
            
            page = 1;
            _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakself createRefreshDataWith:dic2];
            }];
        }
            break;
            //下架
        case 3:{
            is_stock = NO;

            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self loadDataWithParams:dic3 withPage:1 witiidentifier:@"header"];
            }];
            [self.tableView.mj_header beginRefreshing];
            
            page = 1;
            _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakself createRefreshDataWith:dic3];
            }];
        }
            break;
            //库存
        case 4:{
            
            is_stock = YES;
//            isUpSellHiden = NO;

            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [self loadDataWithParams:dic4 withPage:1 witiidentifier:@"header"];
            }];
            [self.tableView.mj_header beginRefreshing];
            
            page = 1;
            _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakself createRefreshDataWith:dic4];
            }];
        }
            break;
            
        default:
            break;
    }
    
    _currentBtn = sender;
}

- (void)createRefreshDataWith:(NSMutableDictionary *)pageparams {
    STWeakSelf(self);
        page++;
        [weakself loadDataWithParams:pageparams withPage:page witiidentifier:@"footer"];

}

- (UITableView *)tableView {
    
    STWeakSelf(self);
    if (!_tableView) {
         _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 160, Width, Height-170-35)  style:UITableViewStylePlain];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself loadDataWithParams:dic1 withPage:1 witiidentifier:@"header"];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakself createRefreshDataWith:dic1];
        }];
        _tableView.contentOffset = CGPointMake(0, 20);
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"GoodsManageTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView.hidden = YES;
        _tableView.separatorStyle = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 138;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSDictionary *dic = [self.dataList objectAtIndex:indexPath.row];
    GoodsManageModel *model = [[GoodsManageModel alloc]initWithContentDic:dic];
    cell.model = model;
    
    //
//    if (isUpSellHiden == YES) {//非库存列表，不显示上架按钮
//        cell.goods_Upsell.hidden = isUpSellHiden;
//    }else {
//        if ([model.enable_onsale isEqual:@"Y"]) {//可上架；不隐藏
//            cell.goods_Upsell.hidden = NO;
//        }else {
//            cell.goods_Upsell.hidden = YES;
//        }
//    }
    
    //  判断上架成功后的刷新
    cell.GoodsManageCellBlock = ^(BOOL isSaveClick){
        //库存上架
        if (isSaveClick ==YES) {
            [self loadDataWithParams:dic4 withPage:1 witiidentifier:@"header"];
        }else {
            //下架上架
            [self loadDataWithParams:dic3 withPage:1 witiidentifier:@"header"];
        }
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [self.dataList objectAtIndex:indexPath.row];
    GoodsManageModel *model = [[GoodsManageModel alloc]initWithContentDic:dic];
    
    if ([model.goods_type isEqualToString:@"goods"]) {
        
        GSBusinessGoodsShowViewController *infoVC = [[GSBusinessGoodsShowViewController alloc]init];
        infoVC.goodId = model.goods_id;
        //    infoVC.goodId = model.goods_sn;
//        infoVC.price = model.market_price;
        infoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    }else if ([model.goods_type isEqualToString:@"stock"]){
        GoodsInfoViewController *infoVC = [[GoodsInfoViewController alloc]init];
        
        infoVC.incomStyle = 0;
        //    GSBusinessGoodsShowViewController *infoVC = [[GSBusinessGoodsShowViewController alloc]init];
        infoVC.goodId = model.goods_id;
        //    infoVC.goodId = model.goods_sn;
        infoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
    
    
}

//创建提示框
- (void)creteRemindView:(NSString *)message {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertVC addAction:action1];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
//- (void)createRemindView2 {
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无商品" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"添加商品" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        AddGoodsViewController *addGoods = [AddGoodsViewController new];
//        [self.navigationController pushViewController:addGoods animated:YES];
//    }];
//    UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//    }];
//    [alertVC addAction:action1];
//    [alertVC addAction:action2];
//    [self presentViewController:alertVC animated:YES completion:nil];
//    
//}


- (void)addButtonAction:(UIButton *)sender {
    
    NSInteger index = sender.tag - 800;
    switch (index) {
            //添加商品
        case 5:{
            
            AddGoodsViewController *addGoods = [AddGoodsViewController new];
            [self.navigationController pushViewController:addGoods animated:YES];
            
        }
            break;
        case 6: //批量管理
        {
            BatchManageViewController *batchManegeVC = [[BatchManageViewController alloc]init];
//            batchManegeVC.dataList = [NSMutableArray arrayWithArray:_batchArr];
            [self.navigationController pushViewController:batchManegeVC animated:YES];
        }
            break;
        case 7: {
            [self.navigationController popViewControllerAnimated:YES];
        }
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [searchTF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    dic5 = [NSMutableDictionary dictionaryWithDictionary:@{@"shop_id":GS_Business_Shop_id,   //从本地获取
             @"keywords":searchTF.text
             }];
    is_stock = NO;
    [self loadDataWithParams:dic5 withPage:1 witiidentifier:@"header"]; //加载搜索数据
    
    return YES;
}


@end
