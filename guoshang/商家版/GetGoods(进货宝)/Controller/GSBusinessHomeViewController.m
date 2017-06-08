//
//  GSBusinessHomeViewController.m
//  guoshang
//
//  Created by chenl on 16/7/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSBusinessHomeViewController.h"
#import "GSHomecell.h"
#import "HomeOtherHeaderCell.h"
#import "RequestManager.h"
//#import "GSSearchViewController.h"
@interface GSBusinessHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
{
    UICollectionView * _recommedCollection;
    UIButton * _searchBtn;
    int  _page;
    UIView * _backView;
    LNButton * _backBtn;
    
}
//监测范围的临界点,>0代表向上滑动多少距离,<0则是向下滑动多少距离
@property(nonatomic,assign)CGFloat threshold;
// 记录scrollView.contentInset.top
@property(nonatomic,assign)CGFloat marginTop;

@property (copy, nonatomic) NSString *keyword;

//@property (strong, nonatomic) UICollectionView * recommedCollection;

@property (strong, nonatomic) UITextField *searchTextfiled;

@property(nonatomic,strong)NSMutableArray  * bannerArray;
@end

@implementation GSBusinessHomeViewController

//-(NSMutableArray *)bannerArray{
//    
//    if (_bannerArray == nil) {
//        
//        _bannerArray = [NSMutableArray array];
//        
//        [HttpTool POST:@"http://124.133.255.187:60080/Apis/Api/Shop/ShopListTopAd" parameters:nil success:^(id responseObject) {
//
//            if ([responseObject[@"status"] isEqualToString:@"0"]) {
//
//                for (NSDictionary * dic in responseObject[@"result"]) {
//                    
//                    NSString * str = [NSString stringWithFormat:@"%@",dic[@"url"]];
//                    
//                    [_bannerArray addObject:str];
//                }
//               
//            }
//
//        [_recommedCollection reloadData];
//
//        } failure:^(NSError *error) {
//            
//    }];
//
//    }
//    
//      return  _bannerArray;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self createNaBarItem];
    
    if ([_isHiden isEqual:@"NO"]) {
        _backBtn.hidden = NO;
    }else {
        _backBtn.hidden = YES;
    }
}


/**
 *  搜索  返回
 */
-(void)createNaBarItem{
    
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 64)];
        _backView.backgroundColor = GS_Business_NavBarColor;
        [self.view addSubview:_backView];
        
        /*
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake((Width -(Width - 110)) * 0.5, 25, Width - 110, 27);
        //    _searchBtn.layer.borderWidth = 1;
        _searchBtn.layer.cornerRadius = 5;
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.layer.backgroundColor = COLOR(208, 208, 208, .5).CGColor;
        //    _searchBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
        //    _searchBtn.alpha = .5;
        [_searchBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_searchBtn];
         */
        
        if (!_backBtn) {
            _backBtn = [LNButton buttonWithFrame:CGRectMake(15, 30, 20, 20) Type:UIButtonTypeCustom Title:nil TitleColor:nil Font:17.0 BackgroundImage:@"fanhui" andBlock:^(LNButton *button) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        
        [_backView addSubview:_backBtn];
        [_backView addSubview:self.searchTextfiled];
        [_searchTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backBtn.mas_right).offset(20);
            make.centerY.equalTo(_backView.mas_centerY).offset(10);
            make.height.offset(30);
            make.right.offset(-70);
        }];
     
    }
    
}

- (void)getDataWithRefreshType:(MJRefreshType)refreshType keyword:(NSString *)keyword {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (refreshType == MJRefreshTypeClear) {
        [params setObject:@"1" forKey:@"page"];
    } else {
        [params setObject:[NSString stringWithFormat:@"%zi",(_dataArray.count/12 + 1)] forKey:@"page"];
    }
    [params setObject:@"12" forKey:@"page_size"];
    if (_keyword && ![_keyword isEqualToString:@""]) {
        [params setObject:_keyword forKey:@"keyword"];
    }
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Repository/GoodsList") parameters:[params addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        if (responseObject[@"result"]) {
            
            if (refreshType == MJRefreshTypeClear) {
                [_recommedCollection.mj_footer resetNoMoreData];
                weakSelf.dataArray = [HomeModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                
            } else {
                NSArray *array = [HomeModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                [weakSelf.dataArray addObjectsFromArray:array];
            }
            
            if ([responseObject[@"result"] count] < 12) {
                [_recommedCollection.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_recommedCollection.mj_footer endRefreshing];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_recommedCollection.mj_header endRefreshing];
            [_recommedCollection reloadData];
            if ([_recommedCollection.mj_footer isRefreshing]) {
                [_recommedCollection.mj_footer endRefreshing];
            }
        });
    }];
}

- (UITextField *)searchTextfiled {
    if (!_searchTextfiled) {
        //UITextFieldViewModeUnlessEditing
        _searchTextfiled = [[UITextField alloc] init];
        _searchTextfiled.placeholder = @"宝贝搜索";
        _searchTextfiled.font = [UIFont systemFontOfSize:14];
        _searchTextfiled.backgroundColor = COLOR(208, 208, 208, .5);
        _searchTextfiled.delegate = self;
        _searchTextfiled.returnKeyType = UIReturnKeySearch;
        _searchTextfiled.leftView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fangdajing"]];
        _searchTextfiled.leftViewMode = UITextFieldViewModeUnlessEditing;
        _searchTextfiled.layer.cornerRadius = 8.0f;
        _searchTextfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    }
    return _searchTextfiled;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _keyword = textField.text;
    [_recommedCollection.mj_header beginRefreshing];
    return YES;
}




-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    /*
        NSMutableArray * array = [NSMutableArray array];
        NSString *  en = [[NSString stringWithFormat:@"page=%d,page_size=12",_page] encryptStringWithKey:KEY];
        [HttpTool POST:URLDependByBaseURL(@"/Api/Repository/GoodsList") parameters:@{@"token":en} success:^(id responseObject) {
            [_recommedCollection.mj_header endRefreshing];
            
            if ([responseObject[@"status"] isEqualToString:@"0"]) {
                NSArray * rootArray = responseObject[@"result"];
                for (NSDictionary * dic  in rootArray) {

                    HomeModel * model = [[HomeModel alloc] initWithDictionary:dic error:nil];
                    [array addObject:model];
            }
                [_dataArray addObjectsFromArray:array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_dataArray.count < _page * 10) {
                        [_recommedCollection.mj_footer endRefreshingWithNoMoreData];
                    }
                    [_recommedCollection reloadData];
                });
            }

        } failure:^(NSError *error) {
         
        }];
    */
    
    return _dataArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createUI];
    _bannerArray = [NSMutableArray array];
    [self creatBannerData];
      _page = 1;
      [self creatRefresh];
    [_recommedCollection.mj_header beginRefreshing];
}
-(void)creatBannerData{
    [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/ShopListTopAd") parameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"0"]) {

            for (NSDictionary * dic in responseObject[@"result"]) {

                NSString * str = [NSString stringWithFormat:@"%@",dic[@"image_url"]];

                [_bannerArray addObject:str];
            }

        }
        [_recommedCollection reloadData];

        } failure:^(NSError *error) {
            
    }];
}

-(void)creatRefresh{

    // 下拉刷新
    _recommedCollection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据的接口
        [self getDataWithRefreshType:MJRefreshTypeClear keyword:_keyword];
    }];
    
    // 上拉加载
    _recommedCollection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 请求加载接口
        [self getDataWithRefreshType:MJRefreshTypeAdd keyword:_keyword];
    }];
    
}

/*
-(void)pullRefresh{
    _page = 1;
    [_dataArray removeAllObjects];
    [self dataArray];
    [_recommedCollection.mj_header endRefreshing];
}
-(void)pushRefresh{
    _page++;
    [self dataArray];
    [_recommedCollection.mj_footer endRefreshing];
}
 */

-(void)createUI{
    UICollectionViewFlowLayout * fowLayout = [[UICollectionViewFlowLayout alloc] init];
    fowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _recommedCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,Width,Height) collectionViewLayout:fowLayout];
    
    _recommedCollection.backgroundColor = MyColor;
    _recommedCollection.delegate = self;
    _recommedCollection.dataSource = self;
    [_recommedCollection registerClass:[GSHomecell class] forCellWithReuseIdentifier:@"HomeCell"];
    [_recommedCollection registerClass:[HomeOtherHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [self.view addSubview:_recommedCollection];

}

//返回一个可以复用的视图作为头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        HomeOtherHeaderCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        
            //轮播图

//        NSString * imageStr = [NSString stringWithFormat:@"%@",self.bannerDic[@"url"]];
//
//        NSLog(@"shouyeshuz%@",imageStr);
        
//        NSArray * bannerArray = [NSArray arrayWithObject:imageStr];
//        NSLog(@"shuju1111 %ld",self.bannerArray.count);
        
        headerView.bannerArray = _bannerArray;
        
        reusableview =  headerView;
        
    }
    return reusableview;
    
    
}
//告知头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
        return CGSizeMake(Width,JHHeight);
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
//告诉每个组有多少个 item（块）
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
        GSHomecell * home = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    if (indexPath.item < _dataArray.count) {
        HomeModel * model = _dataArray[indexPath.row];
        home.dataModel = model;
        
    }
    
        return home;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat  itemHieght = (self.view.frame.size.width - 30)/3.0;
    
    return CGSizeMake(itemHieght, itemHieght  +  65.0);
}
//设置偏移
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchTextfiled resignFirstResponder];
    
    if (self.marginTop != scrollView.contentInset.top) {
        self.marginTop = scrollView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat newoffsetY = offsetY + self.marginTop;
    
    if (newoffsetY >= 0 && newoffsetY <= 150) {
        
        _backView.backgroundColor = COLOR(125.0, 125.0, 122.0, .4);
        
        
    }else if (newoffsetY >=150 && newoffsetY <=180){
        _backView.backgroundColor = COLOR(125.0, 125.0, 122.0, 0.4 + newoffsetY/180);
        
    }else if (newoffsetY > 180){
        
        _backView.backgroundColor = GSNavColor;
        
    }else{
        _backView.backgroundColor = COLOR(125.0, 125.0, 122.0, .4);
//        self.navigationController.navigationBar
    }
}
#pragma mark 跳转到搜索页面
-(void)toSearch{
//    GSSearchViewController * search = [[GSSearchViewController alloc] init];
//    search.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:search animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_searchTextfiled resignFirstResponder];
     
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
