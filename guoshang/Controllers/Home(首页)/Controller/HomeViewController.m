//
//  HomeViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "HomeViewController.h"
#import "GSTabbarController.h"
#import "ClassifyViewController.h"
#import "RecommodCell.h"
#import "Masonry.h"
#import "HomeHeaderCell.h"
#import "HomeTitleViewcell.h"
#import "SearchViewController.h"
#import "HomeModel.h"
#import "BestModel.h"
#import "GoodsShowViewController.h"
#import "HomeCell.h"
#import "HomeOtherTitleViewcell.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "ShopBasicViewController.h"
#import "SVProgressHUD.h"
#import "GSCaptureScanViewController.h"
#import "MassaageCenterViewController.h"
#define iOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8.0

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,CLLocationManagerDelegate>

{
    NSInteger _count;
    
//    NSMutableArray * _dataArray;//数据源
    CLLocationManager * _locationManager;
    UIScrollView * _scrollView;
    UICollectionView * _recommedCollection;
    NSMutableArray * _bannerArr;//轮播图数组
//    NSMutableArray * _shuocengArr;
    UIButton * _searchBtn;
    NSArray * _titleArray;//每层的标题数组
    NSMutableDictionary * _buyDic;
//    NSMutableArray * _footArray;
    CGFloat  _cellHeight;
   NSArray * _goodsArray;//每个cell上的广告图片
    int  _page;
    
   NSMutableArray * _adArray;
}

//监测范围的临界点,>0代表向上滑动多少距离,<0则是向下滑动多少距离
@property(nonatomic,assign)CGFloat threshold;
@property(nonatomic,strong) NSMutableArray * dataArray;//数据源
// 记录scrollView.contentInset.top
@property(nonatomic,assign)CGFloat marginTop;
@property(nonatomic,strong)NSMutableArray * limitArray;

@end

@implementation HomeViewController



-(NSMutableArray *)limitArray{
    
    if (_limitArray == nil) {
        
        _limitArray = [NSMutableArray array];
        
        [HttpTool POST:URLDependByBaseURL(@"/Api/Index/MiaoshaGoods") parameters:nil success:^(id responseObject) {
            NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
//            NSLog(@"%@",responseObject);
            int newStaus = [str intValue];
            if (newStaus == 0) {
                NSArray * rootDic = [NSArray arrayWithArray:responseObject[@"result"]];
                    for (NSDictionary  * dic in rootDic) {
                        
                    HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
                        
                    [_limitArray addObject:model];
                        
                    }
                
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_recommedCollection reloadData];
            });
            
            
        } failure:^(NSError *error) {
            
        }];

        
    }
    return _limitArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = MyColor;
  
    _bannerArr = [NSMutableArray array];
    _titleArray = @[@"se",@"dianqi",@"meizhuanggehu@3x(1)",@"muying",@"chipinyinliao",@"zuixintuijian"];
    _goodsArray = [NSArray array];
    _adArray = [NSMutableArray array];
   
    [self createUI];
    [self createNaBarItem];
    [self creatRefresh];
    
}

-(void)creatRefresh{
    
    // 下拉刷新
  _recommedCollection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据的接口
        [self pullRefresh];
    }];
    [_recommedCollection.mj_header beginRefreshing];
    // 上拉加载
   _recommedCollection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 请求加载接口
        [self pushRefresh];
    }];

    
    //    [self.myTableView addHeaderWithTarget:self action:@selector(pullRefresh)];
    //    [self.myTableView addFooterWithTarget:self action:@selector(pushRefresh)];
}

-(void)pullRefresh{
    _page = 1;
    [_dataArray removeAllObjects];
    [self dataArray];
    [_recommedCollection.mj_header endRefreshing];
    
}
-(void)pushRefresh{
    //_page++;
//    [self.dataArray removeAllObjects];
    [self dataArray];
    //[SVProgressHUD showSuccessWithStatus:@"已加载全部数据"];
    //[_recommedCollection.footer endRefreshing];
    
}

-(NSMutableArray *)dataArray{
    if (_dataArray.count == 0) {
        _dataArray = [NSMutableArray array];
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:[[UIApplication sharedApplication].delegate window]];
        [HttpTool POST:URLDependByBaseURL(@"/Api/Index/getIndexGoods") parameters:nil success:^(id responseObject) {
//            NSLog(@"-----%@",responseObject);
            [MBProgressHUD hideHUDForView:self.navigationController.view.window animated:NO];
            NSString * str = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            int newStaus = [str intValue];
            
            if (newStaus == 1) {
                NSMutableDictionary * rootDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"result"]];
                NSArray * rootArray = @[rootDic[@"jiatingriyong_floor"][@"goods_list"],
                                        rootDic[@"jiayongdianqi_floor"][@"goods_list"],
                                        rootDic[@"meizhuanggehu_floor"][@"goods_list"],
                                        rootDic[@"muyingyongpin_floor"][@"goods_list"],
                                        rootDic[@"shipinyinliao_floor"][@"goods_list"]];
                
                
              
                  NSArray *    adArray = @[rootDic[@"jiatingriyong_floor"],
                                           rootDic[@"jiayongdianqi_floor"],
                                           rootDic[@"meizhuanggehu_floor"],
                                           rootDic[@"muyingyongpin_floor"],
                                           rootDic[@"shipinyinliao_floor"]];
                _adArray = [adArray mutableCopy];
                
                
//                NSLog(@"%@",rootDic[@"jiatingriyong_top"]);
                
                NSArray * goodsRootArray = @[rootDic[@"jiatingriyong_top"],
                                             rootDic[@"jiayongdianqi_top"],
                                             rootDic[@"meizhuanggehu_top"],
                                             rootDic[@"muyingyongpin_top"],
                                             rootDic[@"shipinyinliao_top"]];
                
                _goodsArray = [NSArray arrayWithArray:goodsRootArray];
                
                //各个分类母婴等数据 good_list数组
                for (NSInteger i = 0; i< rootArray.count; i++) {
                    NSArray * array = rootArray[i];
                    NSMutableArray * subArray = [NSMutableArray array];
                    for (NSDictionary * dict in array) {
                        
                        HomeModel * model = [HomeModel mj_objectWithKeyValues:dict];
                        
                        [subArray addObject:model];
                    }
                    
                    [_dataArray addObject:subArray];
                }
                
                //轮播图片
                NSMutableArray * banner = [NSMutableArray arrayWithArray:rootDic[@"flash_images"]];
                for (NSDictionary  * dic in banner) {
                    HomeModel * model = [HomeModel mj_objectWithKeyValues:dic];
                    [_bannerArr addObject:model];
                    
                }
            }
            [_recommedCollection.footer noticeNoMoreData];
            //[_recommedCollection reloadData];
            [self creatNewData];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.navigationController.view.window animated:NO];
        }];

    }
    return _dataArray;
    
}
-(void)creatNewData{
    
    //最新推荐的数据
    NSArray * tokenArray = @[@"type=best",@"type=new",@"type=hot"];
    NSString * str= [NSString stringWithFormat:@"%@,amount=12",tokenArray[_page]];
    NSString * enStr = [str encryptStringWithKey:KEY];
    [HttpTool POST:URLDependByBaseURL(@"/Api/Index/get_recommend_goods") parameters:@{@"token":enStr} success:^(id responseObject) {
        
        NSNumber * status = responseObject[@"status"];
        
        int newStaus = [status intValue];
        
        if (newStaus == 0) {
            
            NSMutableArray * array = [NSMutableArray arrayWithArray:responseObject[@"result"]];
            NSMutableArray * subArr = [NSMutableArray array];
            for (NSDictionary * dic  in array) {
                
                BestModel * model = [[BestModel alloc] initWithDictionary:dic error:nil];
                
                [subArr addObject:model];
            }
            
            [_dataArray addObject:subArr];
        }
        
       [_recommedCollection reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
-(void)createUI{
    
    UICollectionViewFlowLayout * fowLayout = [[UICollectionViewFlowLayout alloc] init];
    fowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _recommedCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,Width,Height - 49) collectionViewLayout:fowLayout];
    _recommedCollection.backgroundColor = MyColor;
    _recommedCollection.delegate = self;
    _recommedCollection.dataSource = self;
     [_recommedCollection registerNib:[UINib nibWithNibName:@"RecommodCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [_recommedCollection registerClass:[HomeCell class] forCellWithReuseIdentifier:@"HomeCell"];
   
    [_recommedCollection registerClass:[HomeHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    [_recommedCollection registerClass:[HomeOtherTitleViewcell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"othertitle"];
    
    [_recommedCollection registerClass:[HomeTitleViewcell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"title"];
    
    [self.view addSubview:_recommedCollection];

    
}

//告诉多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    NSLog(@"coller%ld",_dataArray.count);
    return _dataArray.count;
    
}

//告诉每组有多少块
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 5) {
        
        NSArray * arr = [NSArray arrayWithArray:_dataArray[section]];
        return arr.count;
        
    }else{
        return 1;
    }
    
   
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 5) {
        static NSString * ID = @"cell";
        RecommodCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        if (_dataArray.count > 5) {
            NSArray * aar =_dataArray[indexPath.section];
            
            BestModel * model = aar[indexPath.row];
            cell.model = model;
            _cellHeight = cell.cellHeight;

        }
        return cell;
    }else{
        HomeCell * home = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
        home.headerImageTouchBlock = ^(NSString *cat_id) {
            ShopBasicViewController *basicViewController = [[ShopBasicViewController alloc] init];
            basicViewController.cat_id = cat_id;
            [self.navigationController pushViewController:basicViewController animated:YES];
        };
        
        if (_dataArray.count > 0) {
//            得到颜色
            NSDictionary *dic =   _goodsArray[indexPath.section];
            NSString *clolor= dic[@"color"];
            home.color = clolor;
            home.myArray = _dataArray[indexPath.row];
            
            home.myAdDic= _adArray[indexPath.section];
        
         
         
            
        }
      return home;
    }
    
}

//告诉每个Item有多大

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    if (indexPath.section == 5) {
        CGFloat  itemHieght = (self.view.frame.size.width - 30)/2.0;
        return CGSizeMake(itemHieght, itemHieght + 95.0);
        
    }else{
        
    return  CGSizeMake(self.view.bounds.size.width - 20, 385);
    }
    
  
}
//设置偏移
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
//返回一个可以复用的视图作为头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        
        if (indexPath.section == 0) {
            HomeHeaderCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
            //轮播图
            headerView.bannerArr = _bannerArr;
            headerView.popView = self;
            headerView.limitArray = self.limitArray;
            headerView.titleStr = _goodsArray[indexPath.section][@"top"];
            headerView.limitBtnClickBlock = ^(GoodsShowViewController *detailController) {
                detailController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailController animated:YES];
            };
            reusableview =  headerView;
        }else if(indexPath.section == 3||indexPath.section == 4){
            HomeOtherTitleViewcell * headerTitle = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"othertitle" forIndexPath:indexPath];
            headerTitle.string = _titleArray[indexPath.section];
            headerTitle.adVerString = _goodsArray[indexPath.section][@"top"];
            
            reusableview = headerTitle;
            
        }else{
            
            HomeTitleViewcell * headerTitle = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"title" forIndexPath:indexPath];
            
            //        [UIColor colorWithRed:234/255.0 green:232/255.0 blue:233/255.0 alpha:1];
            
            if (_titleArray.count > indexPath.section && _titleArray[indexPath.section]) {
                
                headerTitle.string = _titleArray[indexPath.section];
            }
            reusableview = headerTitle;
        }
        
    }
    return reusableview ? reusableview : nil;
        
 
}

//告知头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGSizeMake(self.view.frame.size.width, (self.view.frame.size.width - 20) / 3 * 1.26 + 340);
    }
        else if (section == 1|| section==2){
       return CGSizeMake(self.view.frame.size.width, 50.0f);
        }else if(section == 3|| section==4){
               return CGSizeMake(self.view.frame.size.width, 80.0f);
        }
     else  {
       return CGSizeMake(self.view.frame.size.width, 50.0f);
    }

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{

        return CGSizeMake(self.view.frame.size.width, 0);
    
}

-(void)createNaBarItem{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 60)];
    backView.tag = 30303030;
    backView.backgroundColor = [UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:0.5];
    [self.view addSubview:backView];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake((Width -(Width - 110)) * 0.5, 25, Width - 110, 27);
    _searchBtn.layer.borderWidth = 1;
    _searchBtn.layer.cornerRadius= 10;
    _searchBtn.layer.masksToBounds = YES;
    _searchBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_searchBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_searchBtn];
    
    LNButton * sweepBtn = [LNButton buttonWithFrame:CGRectMake(15, 30, 15, 15) Type:UIButtonTypeCustom Title:nil TitleColor:nil Font:17.0 BackgroundImage:@"saoyisao" andBlock:^(LNButton *button) {
//        NSLog(@"扫一扫");
        GSCaptureScanViewController *scan = ViewController_in_Storyboard(@"Main", @"captureScanViewController");
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scan animated:YES];
    }];
    UIImageView * imga = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fangdajing"]];
    imga.frame = CGRectMake(10, 5, 15, 15);
    [_searchBtn addSubview:imga];
    LNLabel * saoLb = [LNLabel addLabelWithTitle:@"扫啊扫" TitleColor:[UIColor whiteColor] Font:8.0f BackGroundColor:[UIColor clearColor]];
    saoLb.frame = CGRectMake(15, 45,30, 15);
    [backView addSubview:saoLb];
    [backView addSubview:sweepBtn];
    LNButton * messageBtn = [LNButton buttonWithFrame:CGRectMake(Width - 35, 30, 15, 15) Type:UIButtonTypeCustom Title:nil TitleColor:nil Font:17.0f BackgroundImage:@"news" andBlock:^(LNButton *button) {
//        NSLog(@"消息");
        if (([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!=nil)) {
            MassaageCenterViewController * cz = [[MassaageCenterViewController alloc]init];
            cz.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cz animated:YES];
        }
        else
        {
                 [AlertTool alertMesasge:@"没有登录，请先登录" confirmHandler:nil viewController:self];
        }

    }];
    
    LNLabel * newLb = [LNLabel addLabelWithTitle:@"消息" TitleColor:[UIColor whiteColor] Font:8.0f BackGroundColor:[UIColor clearColor]];
    newLb.frame = CGRectMake(Width - 35, 45, 20, 15);
    [backView addSubview:newLb];
    [backView addSubview:messageBtn];
    
}


#pragma mark 跳转到搜索页面
-(void)toSearch{
    SearchViewController * search = [[SearchViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    _searchBtn.hidden = YES;
    [self.navigationController pushViewController:search animated:YES];
    
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIView * backView = (UIView *)[self.view viewWithTag:30303030];
    if (self.marginTop != scrollView.contentInset.top) {
        self.marginTop = scrollView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat newoffsetY = offsetY + self.marginTop;
    
    if (newoffsetY >= 0 && newoffsetY <= 150) {
        
        backView.backgroundColor = [UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:0.5];
        
        
    }else if (newoffsetY >=150 && newoffsetY <=180){
         backView.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:55.0/255.0 blue:54.0/255.0 alpha:0.0 + newoffsetY/180];
        
    }else if (newoffsetY > 180){
        
  backView.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:55.0/255.0 blue:54.0/255.0 alpha:1.0];
    }else{
       backView.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:55.0/255.0 blue:54.0/255.0 alpha:0.0 ];
    }
}

-(void)toClassity:(UIButton *)button{

    ClassifyViewController * class = [[ClassifyViewController alloc] init];
    class.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:class animated:YES];

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 5) {
        
        NSArray * aar = _dataArray[indexPath.section];
        
        BestModel * model = aar[indexPath.row];
        
        GoodsShowViewController * goodsShow = [[GoodsShowViewController alloc] init];
        goodsShow.hidesBottomBarWhenPushed = YES;
        goodsShow.goodId = model.ID;
        
        [self.navigationController pushViewController:goodsShow animated:YES];
        

    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
      [self.navigationController setNavigationBarHidden:YES animated:YES];
    _searchBtn.hidden = NO;
    [self startLocation];

    
}

//
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _searchBtn.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 定位
- (void)startLocation {
    if([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        if (iOS8) {
            //使用应用程序期间允许访问位置数据
            [_locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [_locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
        
//        NSLog(@"%@",@"定位服务当前可能尚未打开，请设置打开！");
        
    }
}






@end
