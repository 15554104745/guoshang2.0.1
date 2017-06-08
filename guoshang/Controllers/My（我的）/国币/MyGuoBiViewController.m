//
//  MyGuoBiViewController.m
//  guoshang
//
//  Created by 陈赞 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "MyGuoBiViewController.h"
#import "SLFRechargeHeaderView.h"
#import "HYSegmentedControl.h"
#import "GuoBiDetailTableViewCell.h"
#import "HomeModel.h"
#import "GetPresentViewController.h"
#import "ShoppingCollectionViewCell.h"
#import "SDRefresh.h"
#import "SLFRechargeViewController.h"
#import "SLFRechargeModle.h"
#import "SVProgressHUD.h"
#define scale Width/414.0

@interface MyGuoBiViewController ()<HYSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
        SLFRechargeHeaderView *_HView;
    int page;
    int guobipage;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *headerArr;
@property (strong, nonatomic)HYSegmentedControl *segmentedControl;
@property(nonatomic,strong) UITableView  * MytableView;
@property (strong,nonatomic) UICollectionView * collectionView;
@property(nonatomic,strong)UIView * Myview;
@property(nonatomic,strong)NSMutableArray * GuobiArr;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshFooterView *ConrefreshFooter;
@end

@implementation MyGuoBiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    guobipage = 0;
    self.title = @"我的国币";
    self.view.backgroundColor = MyColor;
//    _HView = [[SLFRechargeHeaderView alloc] initWithFrame:CGRectMake(0, 0,Width, 150)];
//
//    [self.view addSubview:_HView];
    [SVProgressHUD showWithStatus:@"数据加载中"];

    [self creatHeaderData];
    self.segmentedControl = [[HYSegmentedControl alloc] initWithOriginY:150 Titles:@[@"国币商品推荐", @"国币明细"] delegate:self] ;
    [self.view addSubview:_segmentedControl];

    [self GetGuobidata];

    [self config3];
    [self GetguobiDetail];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)creatHeaderData
{
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]];
    encryptString = [userId encryptStringWithKey:KEY];
    _HView = [[SLFRechargeHeaderView alloc] initWithFrame:CGRectMake(0, 0,Width, 150)];
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/GetAllMoney") parameters:@{@"token":encryptString} success:^(id responseObject) {

        _HView.CRBalance = responseObject[@"result"][@"pay_points"];

        SLFRechargeModle *model = [[SLFRechargeModle alloc] initWithDictionary:responseObject[@"result"] error:nil];
        _headerArr = [[NSMutableArray alloc] init];
        [_headerArr addObject:model];
       _HView.headerArr = _headerArr;
        [self.view addSubview:_HView];
           [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
   [SVProgressHUD dismiss];
    }];
}


-(void)GetguobiDetail
{
    self.GuobiArr = [[NSMutableArray alloc]init];
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,type=pay_points,page=%d,page_size=5",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],page];
    encryptString = [userId encryptStringWithKey:KEY];

    [HttpTool POST:URLDependByBaseURL(@"/Api/User/MoneyDetail") parameters:@{@"token":encryptString} success:^(id responseObject) {

        [AlertTool alertTitle:@"提示" mesasge:responseObject[@"message"] preferredStyle:UIAlertControllerStyleActionSheet confirmHandler:nil viewController:nil];
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue]==0) {
            for (int i = 0; i<[responseObject[@"result"]count]; i++) {
                [self.GuobiArr addObject:responseObject[@"result"][i]];
            }
         //   self.GuobiArr = responseObject[@"result"];
              [self config2];
               [SVProgressHUD dismiss];
        }

    } failure:^(NSError *error) {
   [SVProgressHUD dismiss];
    }];
   }
-(void)config3
{
    self.Myview = [[UIView alloc]initWithFrame:CGRectMake(0, 180, Width, Height-180-50-64)];

    [self.view addSubview:self.Myview];

    for (int i = 0; i<3; i++) {
        UIButton * bt = [[UIButton alloc]initWithFrame:CGRectMake(40, 50*i+30, Width-80, 40)];
        bt.tag = i;
        [bt addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        if(i==0)
        {    [bt setTitle:@"去充值" forState:1];
            [bt setTitle:@"去充值" forState:0];

        }
        if(i==1)
        {    [bt setTitle:@"去购物" forState:1];
            [bt setTitle:@"去购物" forState:0];

        }
        if(i==2)
        {    [bt setTitle:@"领取国币" forState:1];
            [bt setTitle:@"领取国币" forState:0];

        }


        [bt setTitleColor:[UIColor whiteColor] forState:0];
        [bt setTitleColor:[UIColor whiteColor] forState:1];
        bt.backgroundColor = COLOR(228, 58, 61, 1);
        bt.layer.masksToBounds = YES;
        bt.layer.cornerRadius = 20;
        [self.Myview addSubview:bt];
    }
    self.Myview.hidden = YES;

}
-(void)go:(UIButton*)bt
{
    if (bt.tag==0) {
        SLFRechargeViewController * sb = [[SLFRechargeViewController alloc]init];
        [self.navigationController pushViewController:sb animated:YES];
    }
    else if (bt.tag==1)

    {
         self.tabBarController.selectedIndex = 0;
    }
    else
    {
        GetPresentViewController * cz = [[GetPresentViewController alloc]init];
        [self.navigationController pushViewController:cz animated:YES];
    }
}

-(void)GetGuobidata
{
     _dataArray = [[NSMutableArray alloc]init];
    NSDictionary * parameters;
    parameters = @{@"cat_id":@"",
                   @"brand":@"",
                   @"order":@"",
                   @"sort":@"",
                   @"page":@"0"};
  NSString * url = URLDependByBaseURL(@"?m=Api&c=Category&a=category&is_exchange=1");
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
//        if (self.page == 0) {
//            [self.dataArray removeAllObjects];
//        }

        for (NSDictionary * dic in responseObject[@"result"][@"goods"]) {
            GoodsDetailModel * model = [[GoodsDetailModel alloc]initWithDictionary:dic error:nil];

            [self.dataArray addObject:model];
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
        [self config1];

   [SVProgressHUD dismiss];

      } failure:^(NSError *error) {
        // 停止刷新
   [SVProgressHUD dismiss];
    }];

}
-(void)config1
{
    //CollectionView
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=1;//左右间隔
    flowLayout.minimumLineSpacing=5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

//    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 180, Width, Height-180-50-64) collectionViewLayout:flowLayout];
    if(self.tabBarController.tabBar.isHidden)

    {
       _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 180, Width, Height-180-20-50) collectionViewLayout:flowLayout];

    }
    else
    {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 180, Width, Height-180-20-80) collectionViewLayout:flowLayout ];
    }
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    _collectionView.backgroundColor = MyColor;
    _collectionView.showsVerticalScrollIndicator = NO;

    UINib *nib = [UINib nibWithNibName:@"ShoppingCollectionViewCell" bundle:nil];
    [self.collectionView registerNib: nib forCellWithReuseIdentifier:@"ShoppingCollectionViewCell"];
    [self.view addSubview:_collectionView];
    [self setupConFooter];
}
-(void)config2
{
    if(self.tabBarController.tabBar.isHidden)

    {
        self.MytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 180, Width, Height-180-20-50)];

    }
    else
    {
 self.MytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 180, Width, Height-180-20-80)];
    }
       self.MytableView.delegate = self;
    self.MytableView.dataSource = self;
    self.MytableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.MytableView.backgroundColor = [UIColor whiteColor];


    // [LCCoolHUD hideInView:self.view];
    [self setupFooter];
    [self.view addSubview:self.MytableView];
      _MytableView.hidden = YES;
}
- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.MytableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}
- (void)setupConFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_collectionView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh1)];
    _ConrefreshFooter = refreshFooter;
}
-(void)guobishangpinjiazai
{
    NSDictionary * parameters;
    parameters = @{@"cat_id":@"",
                   @"brand":@"",
                   @"order":@"",
                   @"sort":@"",
                   @"page":[NSString stringWithFormat:@"%d",guobipage*10]};
    NSString * url = URLDependByBaseURL(@"?m=Api&c=Category&a=category&is_exchange=1");
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
        //        if (self.page == 0) {
        //            [self.dataArray removeAllObjects];
        //        }

        for (NSDictionary * dic in responseObject[@"result"][@"goods"]) {
            GoodsDetailModel * model = [[GoodsDetailModel alloc]initWithDictionary:dic error:nil];

            [self.dataArray addObject:model];
        }
        if (_dataArray.count==0) {
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"已加载全部商品" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];

            [promptAlert show];
        }
         [self.ConrefreshFooter endRefreshing];
        [self.collectionView reloadData];


        
    } failure:^(NSError *error) {
        // 停止刷新
                 [self.ConrefreshFooter endRefreshing];
        
    }];

}
-(void)guobijiazai
{
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,type=pay_points,page=%d,page_size=5",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],page];
    encryptString = [userId encryptStringWithKey:KEY];

    [HttpTool POST:URLDependByBaseURL(@"/Api/User/MoneyDetail") parameters:@{@"token":encryptString} success:^(id responseObject) {

        [AlertTool alertTitle:@"提示" mesasge:responseObject[@"message"] preferredStyle:UIAlertControllerStyleActionSheet confirmHandler:nil viewController:nil];
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"status"] integerValue]==0) {

            for (int i = 0; i<[responseObject[@"result"] count]; i++) {
                NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary: responseObject[@"result"][i]];
                [self.GuobiArr addObject:dic];
            }
            [self.MytableView reloadData];
        }
   [self.refreshFooter endRefreshing];
    } failure:^(NSError *error) {
        
    }];

}
-(void)footerRefresh1
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        guobipage++;
        [self guobishangpinjiazai];
    });
}
-(void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        page++;
        [self guobijiazai];
    });
}
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
//    NSLog(@"%d",index);
    if(index ==0)
    {
          _MytableView.hidden = YES;
        _collectionView.hidden = NO;
        self.Myview.hidden = YES;
    }
    else if (index==1)
    {
        _MytableView.hidden = NO;
        _collectionView.hidden = YES;
        self.Myview.hidden = YES;
    }
    else if (index==2)
    {
        _MytableView.hidden = YES;
        _collectionView.hidden = YES;
        self.Myview.hidden = NO;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.GuobiArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    GuoBiDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {

        cell = [[GuoBiDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.BeizhuLB.text = self.GuobiArr[indexPath.row][@"change_desc"];
    if ([self.GuobiArr[indexPath.row][@"change_type"] integerValue]==0) {
        cell.TypeLB.text = @"充值";
    }
  else  if ([self.GuobiArr[indexPath.row][@"change_type"] integerValue]==1) {
        cell.TypeLB.text = @"提现";
    }
   else if ([self.GuobiArr[indexPath.row][@"change_type"] integerValue]==2) {
        cell.TypeLB.text = @"管理员调节";
    }
   else if ([self.GuobiArr[indexPath.row][@"change_type"] integerValue]==99) {
       cell.TypeLB.text = @"其他";
   }
    cell.JineLB.text  =self.GuobiArr[indexPath.row][@"pay_points"];

    cell.DateLB.text  =self.GuobiArr[indexPath.row][@"change_time_datetime"];
    return cell;
}
-(NSString *)TimeStamp:(NSString *)strTime

{

    //实例化一个NSDateFormatter对象

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    //设定时间格式,这里可以设置成自己需要的格式

    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    //用[NSDate date]可以获取系统当前时间

    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];

    //输出格式为：2010-10-27 10:22:13



    //alloc后对不使用的对象别忘了release



    return currentDateStr;

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// 返回多少行
// 返回多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _dataArray.count;
}
// 3.返回小单元cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加标识
    NSString * cellId = @"ShoppingCollectionViewCell";
    // Xib
    ShoppingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    // 赋值
    NSString * urlStr = [_dataArray[indexPath.row] goods_img];
    [cell.iconView setImageWithURL:[NSURL URLWithString:urlStr]];
    cell.detailLabel.text = [_dataArray[indexPath.row] goods_name];
    if ([[_dataArray[0] is_exchange] isEqualToNumber:@0]) {
        //金币
        cell.priceLabel.text = [NSString stringWithFormat:@"%@",[_dataArray[indexPath.row] shop_price]];
    }else if ([[_dataArray[0] is_exchange] isEqualToNumber:@1]){
        //国币
        [cell.coinView setImage:[UIImage imageNamed:@"guobi"]];
        cell.priceLabel.text = [NSString stringWithFormat:@"%@个",[_dataArray[indexPath.row] shop_price]];
    }
    [cell.saledLabel removeFromSuperview];
    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}
// 选中某个item触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击item  让颜色变回来
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    GoodsDetailViewController * show = [GoodsDetailViewController createGoodsDetailView];
    show.goodsId = [_dataArray[indexPath.row] goods_id];
    show.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:show animated:YES];
}


#pragma mark- flowout的协议方法
// 设置每个视图与其他视图的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // 上左下右
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Width/2-15, 255*scale);
}

@end
