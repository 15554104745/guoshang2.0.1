//
//  GSGoodsDetailViewController.m
//  guoshang
//
//  Created by 陈赞 on 16/9/8.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetailViewController.h"
#import "ShoppingCollectionViewCell.h"
#import "GoodsShowViewController.h"
#import "MBProgressHUD.h"
#import "ShoppingTableViewCell.h"
#import "GSGoodsSearchViewController.h"
#import "GoodsInfoViewController.h"
@interface GSGoodsDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    int current;
    BOOL pop;
    BOOL sal;
    BOOL pri;
     BOOL isChanged;
}
@property(nonatomic,strong)UIButton * PriceBt;
@property(nonatomic,strong)UIButton * salesButton;
@property(nonatomic,strong)UIButton *popularButton;
@property (strong,nonatomic) UICollectionView * collectionView;
@property (strong,nonatomic) UITableView * tableView;
@property (nonatomic, assign) NSInteger page; // 页码

@property (nonatomic,strong) NSDictionary *parameters;
@property (copy, nonatomic) NSString * keywords;
@property (copy, nonatomic) NSString * order;
@property (strong,nonatomic) NSMutableArray * dataArray;

@property (copy, nonatomic) NSString * sort;
@end

@implementation GSGoodsDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮

    self.view.backgroundColor = [UIColor whiteColor];
isChanged = NO;
    // Do any additional setup after loading the view.
    //创建导航栏
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    navBarView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:navBarView];

    UITextField * SearchTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 25, Width-100, 30)];
    SearchTF.placeholder = @"棒球服";
    SearchTF.returnKeyType = UIReturnKeySearch;
    SearchTF.borderStyle = UITextBorderStyleRoundedRect;

    UIImageView *imageViewUserName=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 15, 15)];
    imageViewUserName.image=[UIImage imageNamed:@"fangdajing"];
    SearchTF.leftView=imageViewUserName;
    SearchTF.delegate = self;
    SearchTF.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    SearchTF.backgroundColor  = [UIColor whiteColor];
  [navBarView addSubview:SearchTF];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 22, 40, 40)];
    leftBtn.tag = 807;
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];

    UIView * buttonsView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, 35)];
    buttonsView.backgroundColor = MyColor;
    [self.view addSubview:buttonsView];

    NSInteger len = Width/5-2;

    self.popularButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.popularButton.frame = CGRectMake(10, 5, len-10, 25);
    [self.popularButton setTitle:@"按人气" forState:UIControlStateNormal];
    [self.popularButton setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    [self.popularButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.popularButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -len/5, 0, 0)];
    self.popularButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.popularButton.tag = 5;
    [self.popularButton addTarget:self action:@selector(popular:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:self.popularButton];
    //    self.PriceBt = [[UIButton alloc]initWithFrame:CGRectMake(Width/2, 64, Width/2, 40)];
    //    self.PriceBt.titleLabel.font = [UIFont  systemFontOfSize:13];
    //    [self.PriceBt setTitle:@"商品价格↑" forState:0];
    //    self.PriceBt.tag = 1;
    //    [self.PriceBt setTitleColor:[UIColor grayColor] forState:0];
    //    self.PriceBt.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    [self.PriceBt addTarget:self action:@selector(price:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:self.PriceBt];
    _salesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _salesButton.frame = CGRectMake(len+10, 5, len-10, 25);
    [_salesButton setTitle:@"按销量" forState:UIControlStateNormal];
    [_salesButton setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    [_salesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_salesButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -len/5, 0, 0)];
    _salesButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _salesButton.tag =3;
    [_salesButton addTarget:self action:@selector(time:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:_salesButton];

    _PriceBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _PriceBt.frame = CGRectMake(len*2+10, 5, len-10, 25);
    [_PriceBt setTitle:@"按价格" forState:UIControlStateNormal];
    [_PriceBt setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    [_PriceBt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_PriceBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -len/5, 0, 0)];
    _PriceBt.titleLabel.font = [UIFont systemFontOfSize:14];
    _PriceBt.tag = 1;
    [_PriceBt addTarget:self action:@selector(price:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:_PriceBt];

    //切换布局按钮
    UIButton * changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeButton setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
    [changeButton setImage:[UIImage imageNamed:@"iconfont"] forState:UIControlStateSelected];
    changeButton.frame = CGRectMake(len*4+40, 5, len-45, 25);
    changeButton.tag = 14;
    [changeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:changeButton];
    //    self.TimeBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, Width/2, 40)];
    //
    //    [self.TimeBt setTitleColor:[UIColor grayColor] forState:0];
    //    self.TimeBt.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    [self.TimeBt setTitle:@"商品销量↓" forState:0];
    //    self.TimeBt.titleLabel.font = [UIFont  systemFontOfSize:13];
    //
    //    self.TimeBt.tag = 3;
    //    [self.TimeBt addTarget:self action:@selector(time:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:self.TimeBt];

    //TableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, Width, Height-100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.backgroundColor = MyColor;
    _tableView.showsVerticalScrollIndicator = NO;

    //CollectionView
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=1;//左右间隔
    flowLayout.minimumLineSpacing=5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, Width, Height-100) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    _collectionView.backgroundColor = MyColor;
    _collectionView.showsVerticalScrollIndicator = NO;

    UINib *nib = [UINib nibWithNibName:@"ShoppingCollectionViewCell" bundle:nil];
    [self.collectionView registerNib: nib forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionView];
    _page = 1;
    _dataArray = [[NSMutableArray alloc]init];
    _order  = [NSMutableString stringWithString:@"DESC"];
    self.sort  =[NSMutableString stringWithString:@"add_time"];

    [self Getdata];
    [self refreshView];
}
-(void)buttonClick:(UIButton*)bt
{
    isChanged = !isChanged;
    bt.selected = isChanged;
    if (isChanged) {
        [_collectionView removeFromSuperview];
        [self.view addSubview:_tableView];


    }else{
        [_tableView removeFromSuperview];
        [self.view addSubview:_collectionView];


    }

}
-(void)Getdata
{
    //NSLog(@"%@",self.ID);

    //    NSDictionary * parameters;

    //    if (_keywords.length) {
    //        _parameters = @{@"cat_id":self.ID,
    //                        @"order":_order,
    //                        @"page":page,
    //                        @"keywords":_keywords};
    //    }else{
    //        _parameters = @{@"cat_id":self.ID, @"page":page,@"sort":@"add_time",@"order":@"DESC"};
    //
    //    }
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
    NSString * userId = [NSString stringWithFormat:@"cat_id=%@,page=%ld,page_size=10,sort=add_time,order=DESC",self.ID,(long)self.page];
    NSString * encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Repository/GoodsList") parameters:@{@"token":encryptString}  success:^(id responseObject) {
        if (weakSelf.page == 0) {
            [weakSelf.dataArray removeAllObjects];
        }

        for (NSDictionary * dic in responseObject[@"result"]) {
            GoodsDetailModel * model = [[GoodsDetailModel alloc]initWithDictionary:dic error:nil];
            //            _is_exchange = model.is_exchange;
            [weakSelf.dataArray addObject:model];
        }
        if (_dataArray.count==0) {
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"该类商品暂时无货,敬请期待!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [NSTimer scheduledTimerWithTimeInterval:3.0f
                                             target:self
                                           selector:@selector(timerFireMethod:)
                                           userInfo:promptAlert
                                            repeats:NO];
            [promptAlert show];
        }
        [weakSelf.collectionView reloadData];
        [weakSelf.tableView reloadData];



        // 停止刷新
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES ];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES ];
        // 停止刷新
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
}
-(void)popular:(UIButton*)bt//人气
{
    self.popularButton.selected = YES;
    if (bt.tag ==5) {
        current = 5;
        [self.popularButton setBackgroundImage:[UIImage imageNamed:@"zeng"] forState:UIControlStateSelected];
        _order = [NSMutableString stringWithString:@"DESC"];
        self.popularButton.tag = 6;

        self.sort  =[NSMutableString stringWithString:@"click_count"];
        [self gettada:current];
    }
    else if (bt.tag ==6)
    {
        current = 6;
        [self.popularButton setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateSelected];
        self.popularButton.tag = 5;
        _order = [NSMutableString stringWithString:@"ASC"];
        self.sort  =[NSMutableString stringWithString:@"click_count"];
        [self gettada:current];
    }

    self.salesButton.selected = NO;
    self.PriceBt.selected = NO;
    [self.salesButton setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    [self.PriceBt setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
}
-(void)price:(UIButton*)bt//价格
{
    self.PriceBt.selected = YES;
    if (bt.tag==1) {
        current = 1;


        [self.PriceBt setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateSelected];
        self.PriceBt.tag = 2;
        _order  = [NSMutableString stringWithString:@"DESC"];
        self.sort  =[NSMutableString stringWithString:@"shop_price"];
        [self gettada:current];
    }
    else
    {
        current = 2;


        [self.PriceBt setBackgroundImage:[UIImage imageNamed:@"zeng"] forState:UIControlStateSelected];
        self.PriceBt.tag = 1;
        _order  = [NSMutableString stringWithString:@"ASC"];
        self.sort  =[NSMutableString stringWithString:@"shop_price"];
        [self gettada:current];
    }

    self.salesButton.selected = NO;
    self.popularButton.selected = NO;
    [self.salesButton setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    [self.popularButton setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
}
-(void)time:(UIButton*)bt
{
    self.salesButton.selected = YES;
    if (bt.tag==3) {
        current = 3;


        [self.salesButton setBackgroundImage:[UIImage imageNamed:@"zeng"] forState:UIControlStateSelected];
        self.salesButton.tag = 4;
        _order  = [NSMutableString stringWithString:@"DESC"];
        self.sort  =[NSMutableString stringWithString:@"sale_number"];
        [self gettada:current];
    }
    else
    {
        current = 4;

        [self.salesButton setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateSelected];
        self.salesButton.tag = 3;
        _order  = [NSMutableString stringWithString:@"ASC"];
        self.sort  =[NSMutableString stringWithString:@"sale_number"];
        [self gettada:current];
    }
    self.PriceBt.selected = NO;
    self.popularButton.selected = NO;
    [self.PriceBt setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    [self.popularButton setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
}
-(void)gettada:(int)i
{

    NSString * encryptString;
    if (self.keywords) {
            NSString * userId = [NSString stringWithFormat:@"cat_id=%@,page_size=10,page=1,sort=%@,order=%@,keyword=%@",self.ID,self.sort,self.order,self.keywords];
            encryptString = [userId encryptStringWithKey:KEY];
    }
else
{
    NSString * userId = [NSString stringWithFormat:@"cat_id=%@,page_size=10,page=1,sort=%@,order=%@",self.ID,self.sort,self.order];
    encryptString = [userId encryptStringWithKey:KEY];
}
    //  }
    //    else

    //}
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
    __weak typeof(self) weakSelf = self;
    //http://192.168.1.168/Apis/index.php?Api/Repository/GoodsList
    [HttpTool POST:URLDependByBaseURL(@"/Api/Repository/GoodsList") parameters:@{@"token":encryptString} success:^(id responseObject) {

        [self.dataArray removeAllObjects];


        for (NSDictionary * dic in responseObject[@"result"]) {
            GoodsDetailModel * model = [[GoodsDetailModel alloc]initWithDictionary:dic error:nil];
            //            _is_exchange = model.is_exchange;
            [weakSelf.dataArray addObject:model];
        }
        if (_dataArray.count==0) {
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"该类商品暂时无货,敬请期待!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:weakSelf
                                           selector:@selector(timerFireMethod:)
                                           userInfo:promptAlert
                                            repeats:NO];
            [promptAlert show];
        }
        [weakSelf.collectionView reloadData];
        [weakSelf.tableView reloadData];


        // 停止刷新

        // 停止刷新
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES ];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES ];
        // 停止刷新
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}
-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
    //    self.navigationController pop
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)downloadData
{
    // 加载第一页数据
    self.page = 1;
    [self allDataInit];
}
-(void)allDataInit
{
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
    NSString * userId = [NSString stringWithFormat:@"cat_id=%@,page_size=10,page=%ld,sort=%@,order=%@",self.ID,(long)_page,self.sort,self.order];
    NSString * encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Repository/GoodsList") parameters:@{@"token":encryptString}  success:^(id responseObject) {

        [weakSelf.dataArray removeAllObjects];


        for (NSDictionary * dic in responseObject[@"result"]) {
            GoodsDetailModel * model = [[GoodsDetailModel alloc]initWithDictionary:dic error:nil];
            //            _is_exchange = model.is_exchange;
            [weakSelf.dataArray addObject:model];
        }
        if (_dataArray.count==0) {
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"该类商品暂时无货,敬请期待!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:weakSelf
                                           selector:@selector(timerFireMethod:)
                                           userInfo:promptAlert
                                            repeats:NO];
            [promptAlert show];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.collectionView reloadData];


        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES ];
        // 停止刷新

        // 停止刷新
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES ];
        // 停止刷新
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];

}
-(void)jiazai
{
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];

    NSString * encryptString;
    if (self.keywords) {

        NSString * userId = [NSString stringWithFormat:@"cat_id=%@,page_size=10,page=%ld,sort=%@,order=%@,keyword=%@",self.ID,(long)_page,self.sort,self.order,self.keywords];
        encryptString = [userId encryptStringWithKey:KEY];
    }
    else
    {
        NSString * userId = [NSString stringWithFormat:@"cat_id=%@,page_size=10,page=%ld,sort=%@,order=%@",self.ID,(long)self.page, self.sort,self.order];
        encryptString = [userId encryptStringWithKey:KEY];
    }
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Repository/GoodsList") parameters:@{@"token":encryptString}  success:^(id responseObject) {


        for (NSDictionary * dic in responseObject[@"result"]) {
            GoodsDetailModel * model = [[GoodsDetailModel alloc]initWithDictionary:dic error:nil];
            //            _is_exchange = model.is_exchange;
            [weakSelf.dataArray addObject:model];
        }
        if (_dataArray.count==0) {
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"该类商品暂时无货,敬请期待!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:weakSelf
                                           selector:@selector(timerFireMethod:)
                                           userInfo:promptAlert
                                            repeats:NO];
            [promptAlert show];
        }
        [weakSelf.collectionView reloadData];



        // 停止刷新

        // 停止刷新
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES ];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES ];
        // 停止刷新
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}
#pragma mark -上拉加载 下拉刷新
- (void)refreshView
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据的接口
        [weakSelf downloadData];
    }];
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据的接口
        [weakSelf downloadData];
    }];

    // 上拉加载
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 请求加载接口
        weakSelf.page++;
        [weakSelf jiazai];
    }];
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 请求加载接口
        weakSelf.page++;
        [weakSelf jiazai];
    }];


}
#pragma mark -collectionView的协议方法

// 返回多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _dataArray.count;
}
// 3.返回小单元cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加标识
    NSString * cellId = @"cellID";
    // Xib
    ShoppingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    // 赋值
    NSString * urlStr = [_dataArray[indexPath.row] goods_img];
    [cell.iconView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    cell.detailLabel.text = [_dataArray[indexPath.row] goods_name];
    //    if ([[_dataArray[0] is_exchange] isEqualToNumber:@0]) {
    //金币
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",[_dataArray[indexPath.row] purchase_price]];
    //    }else if ([[_dataArray[0] is_exchange] isEqualToNumber:@1]){
    //        //国币
    //        [cell.coinView setImage:[UIImage imageNamed:@"guobi"]];
    //        cell.priceLabel.text = [NSString stringWithFormat:@"%@个",[_dataArray[indexPath.row] shop_price]];
    //    }
    [cell.saledLabel removeFromSuperview];
    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}
// 选中某个item触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击item  让颜色变回来
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    GoodsShowViewController * gsvc = [[GoodsShowViewController alloc]init];
//    gsvc.hidesBottomBarWhenPushed = YES;
//    //    NSLog(@"%@",self.url);
//    gsvc.goodId = [_dataArray[indexPath.row] goods_id];
//
//    [self.navigationController pushViewController:gsvc animated:YES];
    GoodsInfoViewController *infoVC = [[GoodsInfoViewController alloc]init];

    infoVC.incomStyle = 1;
    //    GSBusinessGoodsShowViewController *infoVC = [[GSBusinessGoodsShowViewController alloc]init];
    infoVC.goodId =  [_dataArray[indexPath.row] goods_id];
    //    infoVC.goodId = model.goods_sn;
    infoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVC animated:YES];
}


#pragma mark- flowout的协议方法
// 设置每个视图与其他视图的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // 上左下右
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#define scale Width/414.0
// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Width/2-15, 255*scale);
}


#pragma mark -tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  [MBProgressHUD hideHUDForView:self.view animated:YES ];
    return 1;
}
// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  [MBProgressHUD hideHUDForView:self.view animated:YES ];
        return _dataArray.count;

}
// 返回cell表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        // 添加标识
        static NSString * cellId = @"cellId";
        // 在复用池中查找
        ShoppingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        // 找不到创建
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingTableViewCell" owner:self options:nil] lastObject];
        }

            //金币
            [cell configGoldCellWithModel:_dataArray[indexPath.row]];

        cell.backgroundColor = [UIColor whiteColor];
      [MBProgressHUD hideHUDForView:self.view animated:YES ];
        return cell;

}
//cell高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


        return 120;
  }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.delaysContentTouches = NO;

        //点击cell  让颜色变回来
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsShowViewController * gsvc = [[GoodsShowViewController alloc]init];
    gsvc.hidesBottomBarWhenPushed = YES;
    //    NSLog(@"%@",self.url);
    gsvc.goodId = [_dataArray[indexPath.row] goods_id];

    [self.navigationController pushViewController:gsvc animated:YES];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    GSGoodsSearchViewController * cz  =[[GSGoodsSearchViewController alloc]init];
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    [self.navigationController pushViewController:cz animated:YES];
    return NO;
}
- (void)tongzhi:(NSNotification *)text{
    //NSLog(@"%@",text.userInfo[@"text"]);
    self.keywords =text.userInfo[@"text"];
    [self gettada:1];
    NSLog(@"－－－－－接收到通知------");

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
