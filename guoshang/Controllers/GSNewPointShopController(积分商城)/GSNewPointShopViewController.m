//
//  GSNewPointShopViewController.m
//  guoshang
//
//  Created by 时礼法 on 16/12/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNewPointShopViewController.h"
#import "GSShopSortToolsView.h"
#import "GSShopBaseSiftView.h"
#import "MBProgressHUD.h"
#import "GSShopBaseSiftView.h"
#import "GSShopBaseGoodsModel.h"
#import "RequestManager.h"
#import "MBProgressHUD.h"
#import "GSShopBaseBrandModel.h"
#import "GSShopBaseCategoryModel.h"
#import "ShoppingCollectionViewCell.h"
#import "GSGoodsDetailInfoViewController.h"
#import "ShoppingTableViewCell.h"

typedef NS_ENUM(NSInteger, GSShopShowType) {
    GSShopShowTypeCollection = 0,
    GSShopShowTypeTable,
};

@interface GSNewPointShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,GSShopSortToolsViewDelegate,GSShopBaseSiftViewDelegate>

@property (weak, nonatomic) GSShopSortToolsView *sortView;
@property (weak, nonatomic) GSShopBaseSiftView *siftView;
@property (strong, nonatomic) NSMutableDictionary *requestParams;
@property (assign, nonatomic) BOOL navButtonSelected;
@property (weak, nonatomic) UIButton *rightNavButton;
@property (strong, nonatomic) MJRefreshNormalHeader *refreshHeader;
@property (strong, nonatomic) MJRefreshBackNormalFooter *refreshFooter;

@property (strong, nonatomic) NSMutableArray *brandArray;
@property (strong, nonatomic) NSMutableArray *categoryArray;

@property (assign, nonatomic) BOOL showSiftView;
@property (weak, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) NSLayoutConstraint *heightLayoutConstant;

@end

@implementation GSNewPointShopViewController

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        [collectionView registerNib:[UINib nibWithNibName:@"ShoppingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShoppingCollectionViewCell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.alpha = 0;
        _collectionView = collectionView;
        return _collectionView;
    }
    return _collectionView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.alpha = 0;
        [tableView registerNib:[UINib nibWithNibName:@"ShoppingTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShoppingTableViewCell"];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        _tableView = tableView;
        
        
        return _tableView;
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}

- (NSMutableDictionary *)requestParams {
    if (!_requestParams) {
        _requestParams = [[NSMutableDictionary alloc] initWithCapacity:0];
        
    }
    return _requestParams;
}

- (MJRefreshNormalHeader *)refreshHeader {
    if (!_refreshHeader) {
        __weak typeof(self) weakSelf = self;
        _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.requestParams setObject:@"0" forKey:@"page"];
            
            [weakSelf sendRequestWithClearDataSource:YES completed:^{
                [_refreshHeader endRefreshing];
            }];
        }];
    }
    
    return _refreshHeader;
}

- (MJRefreshBackNormalFooter *)refreshFooter {
    if (!_refreshFooter) {
        __weak typeof(self) weakSelf = self;
        _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            NSInteger page = self.dataSourceArray.count;
            
            if (self.dataSourceArray.count < 10) {
                [_refreshFooter endRefreshingWithNoMoreData];
            } else {
                [weakSelf.requestParams setObject:[NSString stringWithFormat:@"%zi",page] forKey:@"page"];
                [weakSelf sendRequestWithClearDataSource:NO completed:nil];
            }
        }];
    }
    
    return _refreshFooter;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.cat_id) {
        self.cat_id = @"0";
    }
    [self.requestParams setObject:self.cat_id forKey:@"cat_id"];
    [self creatUI];
    
}

-(void)creatUI
{
    self.title = @"国币商城";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.requestURL = URLDependByBaseURL(@"?m=Api&c=Category&a=category&is_exchange=1");

    //功能区部分
    [self creatNavView];
    [self setupToolsView];
    [self setupCollectionView];
    [self.view bringSubviewToFront:self.hud];
    _collectionView.alpha = 1.0f;
    
}

-(void)creatNavView
{
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 20, 20);
    [barButton setImage:[UIImage imageNamed:@"icon_shop_list"] forState:UIControlStateNormal];
    [barButton setImage:[UIImage imageNamed:@"icon_shop_lump"] forState:UIControlStateSelected];
    [barButton addTarget:self action:@selector(RightBarButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBarButton.frame = CGRectMake(0, 0, 20, 20);
    [leftBarButton setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

}

- (void)setupToolsView {
    GSShopSortToolsView *toolsView = [[GSShopSortToolsView alloc] initWithDelegate:self];
    [self.view addSubview:toolsView];
    self.sortView = toolsView;
    __weak typeof(self) weakSelf = self;
    [toolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(weakSelf.mas_topLayoutGuide);
        make.height.offset(44.0f);
    }];
}

- (void)setupCollectionView {
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sortView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(weakSelf.mas_bottomLayoutGuide);
    }];
    [_collectionView reloadData];
    
    _collectionView.mj_header = [self refreshHeader];
    
    _collectionView.mj_footer = [self refreshFooter];
    
}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sortView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(weakSelf.mas_bottomLayoutGuide);
    }];
    [_tableView reloadData];
    
    _tableView.mj_header = [self refreshHeader];
    _tableView.mj_footer = [self refreshFooter];
}

#pragma mark =============getData ============
- (void)sendRequestWithClearDataSource:(BOOL)clearDataSource completed:(void(^)())complted {
    if (clearDataSource) {
        if (_refreshFooter) {
            [_refreshFooter resetNoMoreData];
        }
        [self.dataSourceArray removeAllObjects];
        [self reloadData];
    }
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
    self.hud = hud;
    
    
    [[RequestManager manager] requestWithMode:RequestModePost URL:self.requestURL parameters:self.requestParams completed:^(id responseObject, NSError *error) {
        if (responseObject[@"result"]) {
            
            NSArray *tempArray = [GSShopBaseGoodsModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"goods"]];
            weakSelf.categoryArray = [GSShopBaseCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"select"][@"category"]];
            weakSelf.brandArray = [GSShopBaseBrandModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"select"][@"brand"]];
            
            if (tempArray.count < 10) {
                [_refreshFooter endRefreshingWithNoMoreData];
            } else {
                [_refreshFooter endRefreshing];
            }
            [weakSelf.dataSourceArray addObjectsFromArray:tempArray];
        }
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf reloadData];
        if (complted) {
            complted();
        }
        
    }];
}

- (void)reloadData {
    if (_tableView) {
        [_tableView reloadData];
    }
    
    if (_collectionView) {
        [_collectionView reloadData];
    }
}

#pragma mark ================= 按钮点击相应事件 =============
//点击rightButton切换视图类型
-(void)RightBarButton:(UIButton *)button
{
    self.navButtonSelected = !self.navButtonSelected;
    GSShopShowType showType = self.navButtonSelected;
    switch (showType) {
        case GSShopShowTypeCollection: {
            [button setImage:[UIImage imageNamed:@"icon_shop_list"] forState:UIControlStateNormal];
            [self setupCollectionView];
            [self.view bringSubviewToFront:self.hud];
            [self animitionToChangedViewWithShowView:self.tableView willShowView:self.collectionView];
        }
            break;
            
        case GSShopShowTypeTable:
            [button setImage:[UIImage imageNamed:@"icon_shop_lump"] forState:UIControlStateNormal];
            [self setupTableView];
            [self.view bringSubviewToFront:self.hud];
            [self animitionToChangedViewWithShowView:self.collectionView willShowView:self.tableView];
            break;
            
        default:
            break;
    }

    
}

- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)animitionToChangedViewWithShowView:(UIView *)showView willShowView:(UIView *)willShowView {
    self.rightNavButton.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        showView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
    }];
    [UIView animateWithDuration:0.5 animations:^{
        //showView.alpha = 0;
        willShowView.alpha = 1;
    } completion:^(BOOL finished) {
        
        weakSelf.rightNavButton.userInteractionEnabled = YES;
    }];
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GSShopBaseGoodsModel *model = self.dataSourceArray[indexPath.item];
    GSGoodsDetailInfoViewController *goodsDe = ViewController_in_Storyboard(@"Main", @"GSGoodsDetailInfoViewController");
    goodsDe.recommendModel = model;
    [self.navigationController pushViewController:goodsDe animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShoppingCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.item < self.dataSourceArray.count) {
        cell.goodsModel = self.dataSourceArray[indexPath.row];
    }
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(((Width - 5) / 2), ((Width - 5) / 2) + 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GSShopBaseGoodsModel *model = self.dataSourceArray[indexPath.row];
    GSGoodsDetailInfoViewController *goodsDetail = [[GSGoodsDetailInfoViewController alloc] init];
    goodsDetail.recommendModel = model;
    [self.navigationController pushViewController:goodsDetail animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingTableViewCell" forIndexPath:indexPath];
    if (indexPath.item < self.dataSourceArray.count) {
        cell.goodsModel = self.dataSourceArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}


#pragma mark ================= BaseToolDelegate ============
- (void)shopSortToolsViewDidChangeSortWithSortParams:(NSString *)sortParams sortTypeStr:(NSString *)sortTypeStr {
    
    [self.requestParams setObject:sortTypeStr forKey:@"order"];
    [self.requestParams setObject:sortParams forKey:@"sort"];
    [self.requestParams setObject:@"0" forKey:@"page"];
    self.sortView.siftButton.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [self sendRequestWithClearDataSource:YES completed:^{
        weakSelf.sortView.siftButton.userInteractionEnabled = YES;
    }];
}

- (void)shopSiftButtonDidClick:(GSShopSortToolButton *)siftButton sortType:(GSShopSortButtonSortType)sortType {
    if (!self.showSiftView) {
        __weak typeof(self) weakSelf = self;
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.bounces = NO;
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sortView.mas_bottom);
            make.left.right.mas_offset(0);
            make.bottom.equalTo(weakSelf.mas_bottomLayoutGuide);
        }];
        
        
        GSShopBaseSiftView *siftView = [[GSShopBaseSiftView alloc] init];
        siftView.delegate = self;
        if (self.brandArray) {
            siftView.brandArray = self.brandArray;
        }
        
        if (self.categoryArray) {
            siftView.categoryArray = self.categoryArray;
        }
        
        [scrollView addSubview:siftView];
        self.siftView = siftView;
        
        
        [siftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            
        }];
        self.heightLayoutConstant = [NSLayoutConstraint constraintWithItem:siftView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:435];
        [siftView addConstraint:self.heightLayoutConstant];
        self.showSiftView = YES;
    } else {
        [_siftView.superview removeFromSuperview];
        [_siftView removeFromSuperview];
        self.showSiftView = NO;
    }
}

#pragma GSShopBaseSiftViewDelegate
- (void)siftViewDidUpdateHeight:(CGFloat)height {
    if (height != self.heightLayoutConstant.constant) {
        self.heightLayoutConstant.constant = height;
    }
}

- (void)siftView:(GSShopBaseSiftView *)siftView didFinishedSelctSiftWithCat_id:(NSString *)cat_id is_exchange:(BOOL)is_exchange brand_id:(NSString *)brand_id {
    [siftView.superview removeFromSuperview];
    [siftView removeFromSuperview];
    self.showSiftView = NO;
    //[self.requestParams setObject:[NSString stringWithFormat:@"%zi",is_exchange] forKey:@"is_exchange"];
    [self.requestParams setObject:cat_id forKey:@"cat_id"];
    if (brand_id) {
        [self.requestParams setObject:brand_id forKey:@"brand"];
    } else {
        [self.requestParams removeObjectForKey:@"brand"];
    }
    
    [self sendRequestWithClearDataSource:YES completed:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
