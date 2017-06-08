//
//  GSNewCarViewController.m
//  guoshang
//
//  Created by Rechied on 2016/11/17.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNewCarViewController.h"
#import "GSCarSettleToolsView.h"
#import "GSCarShopSectionHeader.h"

#import "GSCarProtocolManager.h"
#import "GSCarRequestManager.h"
#import "GSNavigationViewDropView.h"
#import "GSNewLoginViewController.h"

#import "MBProgressHUD.h"

#import "GSChackOutOrderViewController.h"
#import "MJRefresh.h"

@interface GSNewCarViewController ()<GSCarProtocolManagerDelegate, GSCarSettleToolsViewDelegate, GSNavigationViewDropViewDelegate>

@property (weak, nonatomic) IBOutlet GSCarSettleToolsView *settleToolsView;

@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;

@property (weak, nonatomic) IBOutlet UITableView *carTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *recommendCollectionView;

@property (weak, nonatomic) IBOutlet UIView *notLoginView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noGoodsViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carToolsViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property (weak, nonatomic) UIBarButtonItem *editBarButton;
@property (weak, nonatomic) UIBarButtonItem *seeMoreButton;

@property (strong, nonatomic) MJRefreshNormalHeader *refreshHeader;
@property (strong, nonatomic) MJRefreshAutoNormalFooter *refreshFooter;

@property (strong, nonatomic) GSCarProtocolManager *protocolManager;
@property (strong, nonatomic) GSCarTotalModel *totalModel;


@property (weak, nonatomic) GSNavigationViewDropView *dropView;

@property (assign, nonatomic) BOOL isNoGoods;
@end

@implementation GSNewCarViewController

- (instancetype)init {
    self = ViewController_in_Storyboard(@"Main", @"GSNewCarViewController");
    return self;
}

- (GSCarProtocolManager *)protocolManager {
    if (!_protocolManager) {
        _protocolManager = [[GSCarProtocolManager alloc] init];
        _protocolManager.tableView = self.carTableView;
        _protocolManager.delegate = self;
    }
    return _protocolManager;
}

- (MJRefreshNormalHeader *)refreshHeader {
    if (!_refreshHeader) {
        __weak typeof(self) weakSelf = self;
        _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf initCarDatas];
            [weakSelf getDefaultRecommendGoodsList];
        }];
    }
    return _refreshHeader;
}

- (MJRefreshAutoNormalFooter *)refreshFooter {
    if (!_refreshFooter) {
        __weak typeof(self) weakSelf = self;
        _refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [GSCarRequestManager getRecommendGoodsListWithPage:weakSelf.protocolManager.recommendGoodsArray.count page_size:6 completed:^(NSArray<__kindof GSHomeRecommendModel *> *goodsArray, BOOL noMoreData, NSError *error) {
                if (!error) {
                    [weakSelf.protocolManager.recommendGoodsArray addObjectsFromArray:goodsArray];
                    
                    if (noMoreData) {
                        [weakSelf.refreshFooter endRefreshingWithNoMoreData];
                    } else {
                        [weakSelf.refreshFooter endRefreshing];
                    }
                    [weakSelf.recommendCollectionView reloadData];
                }
            }];
        }];
        _refreshFooter.nomoDataViewBGColor = [UIColor clearColor];
    }
    return _refreshFooter;
}

- (UIBarButtonItem *)seeMoreButton {
    if (!_seeMoreButton) {
        UIButton *seeMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        seeMoreButton.frame = CGRectMake(0, 0, 30, 40);
        seeMoreButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [seeMoreButton setImage:[UIImage imageNamed:@"icon_goodsDetail_point"] forState:UIControlStateNormal];
        
        [seeMoreButton addTarget:self action:@selector(navigationSeeMoreAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *seeMoreBarButton = [[UIBarButtonItem alloc] initWithCustomView:seeMoreButton];
        _seeMoreButton = seeMoreBarButton;
        return _seeMoreButton;
    }
    return _seeMoreButton;
}

- (UIBarButtonItem *)editBarButton {
    if (!_editBarButton) {
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editButton.frame = CGRectMake(0, 0, 30, 40);
        editButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editButton setTitle:@"完成" forState:UIControlStateSelected];
        [editButton addTarget:self action:@selector(navigationEditAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
        _editBarButton = editBarButton;
        return _editBarButton;
    }
    return _editBarButton;
}

- (GSNavigationViewDropView *)dropView {
    if (!_dropView) {
        GSNavigationViewDropView *dropView = [[GSNavigationViewDropView alloc] initWithFrame:CGRectMake(Width - 20, 0, 0, 0)];
        dropView.delegate = self;
        _dropView = dropView;
        [self.view addSubview:dropView];
        return _dropView;
    }
    return _dropView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.carTableView registerClass:[GSCarShopSectionHeader class] forHeaderFooterViewReuseIdentifier:@"GSCarShopSectionHeader"];
    [self setupNavigationBar];
    [self setupProtocol];
    [self registerObservers];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged) name:@"GSUserLoginStatusChangedNotifcationName" object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loginStatusChanged];
    [self resetNavigationBar];
    
}

- (void)loginStatusChanged {
    if (UserId) {
        [self hideNotLoginView];
        [self initCarDatas];
        [self getDefaultRecommendGoodsList];
    } else {
        [self showNotLoginView];
        [self clearAllDatas];
    }
}

/**
 设置导航栏
 */
- (void)setupNavigationBar {
    self.title = @"购物车";
}

- (void)resetNavigationBar {
    NSMutableArray *rightBarButtonItems = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (self.hidesBottomBarWhenPushed) {
        [rightBarButtonItems addObject:self.seeMoreButton];
    }
    
    if (!self.isNoGoods) {
        [rightBarButtonItems addObject:self.editBarButton];
    }
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
}

/**
 设置tableView、collectionView的代理和数据源
 */
- (void)setupProtocol {
    self.settleToolsView.delegate = self;
    self.carTableView.delegate = self.protocolManager;
    self.carTableView.dataSource = self.protocolManager;
    self.recommendCollectionView.delegate = self.protocolManager;
    self.recommendCollectionView.dataSource = self.protocolManager;
}

/**
 设置scrollView刷新控件
 */
- (void)setupHeaderAndFooter {
    self.baseScrollView.mj_header = self.refreshHeader;
    self.baseScrollView.mj_footer = self.refreshFooter;
}

/**
 清除刷新控件
 */
- (void)clearRefreshHeaderAndFooter {
    self.baseScrollView.mj_header = nil;
    self.baseScrollView.mj_footer = nil;
}

/**
 初始化购物车数据
 */
- (void)initCarDatas {
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
    [GSCarRequestManager getCarGoodsList:^(NSArray<__kindof GSCarShopModel *> *shop_list, GSCarTotalModel *totalModel, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.protocolManager.carGoodsArray = [[NSMutableArray alloc] initWithArray:shop_list];
        
        [weakSelf.refreshHeader endRefreshing];
        weakSelf.isNoGoods = weakSelf.protocolManager.carGoodsArray.count == 0;
        weakSelf.totalModel = totalModel;
        [weakSelf.carTableView reloadData];
    }];
}

/**
 获取购物车推荐数据
 */
- (void)getDefaultRecommendGoodsList {
    __weak typeof(self) weakSelf = self;
    [self.refreshFooter resetNoMoreData];
    [GSCarRequestManager getRecommendGoodsListWithPage:0 page_size:6 completed:^(NSArray<__kindof GSHomeRecommendModel *> *goodsArray, BOOL noMoreData, NSError *error) {
        if (!error) {
            weakSelf.protocolManager.recommendGoodsArray = [[NSMutableArray alloc] initWithArray:goodsArray];
            
            [weakSelf setupHeaderAndFooter];
            
            if (noMoreData) {
                [weakSelf.refreshFooter endRefreshingWithNoMoreData];
            }
            [weakSelf.recommendCollectionView reloadData];
        }
    }];
}

/**
 清除所有数据（一般用于退出登录后）
 */
- (void)clearAllDatas {
    [self.protocolManager resetAllData];
    [self clearRefreshHeaderAndFooter];
    [self.carTableView reloadData];
    [self.recommendCollectionView reloadData];
}

/**
 显示未登录画面
 */
- (void)showNotLoginView {
    self.notLoginView.hidden = NO;
    self.notLoginView.userInteractionEnabled = YES;
}

/**
 隐藏未登录画面
 */
- (void)hideNotLoginView {
    self.notLoginView.hidden = YES;
    self.notLoginView.userInteractionEnabled = NO;
}

/**
 重置编辑按钮状态
 */
- (void)resetEdit {
    [self navigationEditAction:(UIButton *)self.navigationItem.rightBarButtonItem.customView];
}

/**
 购物车是否没有商品，用于确定是否要展示去逛逛
 */
- (void)setIsNoGoods:(BOOL)isNoGoods {
    _isNoGoods = isNoGoods;
    self.noGoodsViewHeightConstraint.constant = isNoGoods ? 60.0f : 0.0f;
    self.carToolsViewHeightConstraint.constant = isNoGoods ? 0.0f : 50.0f;
    if (!isNoGoods) {
        [self.baseScrollView setContentOffset:CGPointZero animated:NO];
    }
    [self resetNavigationBar];
}

#pragma mark - KVO

/**
 注册监听 监听tableView与collectionView的contentSize 动态改变baseScrollView的conentView高度 实现嵌套滚动
 */
- (void)registerObservers {
    [self.carTableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.recommendCollectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAllChangeStatus:) name:@"SelectAllGoodsStatusChange" object:nil];
}

/**
 移除tableView、collectionView的监听
 */
- (void)deallocObservers {
    [self.carTableView removeObserver:self forKeyPath:@"contentSize"];
    [self.recommendCollectionView removeObserver:self forKeyPath:@"contentSize"];
}


/**
 KVO 被监听对象指定属性改变时调用的方法

 @param keyPath 监听对象的属性 keyPath
 @param object  被监听对象
 @param change  被监听对象 改变后的属性与改变前的属性
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (object == self.carTableView) {
            if (self.carTableView.contentSize.height != self.tableViewHeightConstraint.constant) {
                self.tableViewHeightConstraint.constant = self.carTableView.contentSize.height;
            }
        }
        
        if (object == self.recommendCollectionView) {
            if (self.recommendCollectionView.contentSize.height != self.collectionViewHeightConstraint.constant) {
                self.collectionViewHeightConstraint.constant = self.recommendCollectionView.contentSize.height;
            }
        }
    }
}

/**
 控制器dealloc时，移除监听
 */
- (void)dealloc {
    [self deallocObservers];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"GSUserLoginStatusChangedNotifcationName" object:nil];
}

#pragma mark - Action

/**
 立即登录按钮点击后跳到登录页面

 @param sender 立即登录按钮
 */
- (IBAction)loginButtonClick:(id)sender {
    GSNewLoginViewController *loginViewController = [[GSNewLoginViewController alloc] init];
    loginViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginViewController animated:YES];
}

/**
 去逛逛按钮点击事件

 @param sender 去逛逛按钮
 */
- (IBAction)strollButtonAction:(UIButton *)sender {
    if (self.navigationController == [self.tabBarController viewControllers][0]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.tabBarController setSelectedIndex:0];
    }
}

/**
 导航栏更多按钮点击事件
 */
- (void)navigationSeeMoreAction:(UIButton *)sender {
    [self.dropView changeDropViewStatus];
}

/**
 导航栏编辑按钮点击事件
 */
- (void)navigationEditAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.settleToolsView changeShowTypeWithIsEdit:sender.isSelected];
    [self.carTableView setEditing:sender.selected animated:YES];
}

/**
 收到改变全选状态的通知
 */
- (void)selectAllChangeStatus:(NSNotification *)notif {
    [self.protocolManager changeSelectAllGoods:[[notif.userInfo objectForKey:@"value"] boolValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GSNavigationViewDropViewDelegate
- (void)dropViewDidSelectIndex:(NSInteger)index {
    if (index == 2) {
        return;
    }
    UINavigationController *navigationController = self.tabBarController.viewControllers[index];
    if (navigationController == self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    } else {
        [self.tabBarController setSelectedIndex:index];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

#pragma mark - GSCarProtocolManagerDelegate

- (void)carProtocolManagerDidChangeTotalPrice:(NSString *)totalPrice isSelectAllGoods:(BOOL)isSelectAllGoods selectGoodsCount:(NSInteger)goodsCount{
    
    [self.settleToolsView.selectAllButton setSelected:isSelectAllGoods];
    self.settleToolsView.amountPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[totalPrice floatValue]];
    self.settleToolsView.selectGoodsCount = goodsCount;
    [self.settleToolsView.settleButton setTitle:[NSString stringWithFormat:@"去结算(%zi)",goodsCount] forState:UIControlStateNormal];
    
}

- (void)carProtocolManagerWillPushViewController:(UIViewController *)viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)carProtocolManagerReloadAllDatas {
    [self initCarDatas];
}

- (void)carProtocolManagerWillAddGoodsToCarWithGoods_id:(NSString *)goods_id {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
    [GSCarRequestManager addGoodsToCarWithGoods_id:goods_id completed:^(BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf initCarDatas];
    }];
}

#pragma mark - GSCarSettleToolsView

/**
 去结算
 */
- (void)carSettleToolsSettleAction {
    if (self.settleToolsView.selectGoodsCount != 0) {
        GSChackOutOrderViewController *chackOut = [[GSChackOutOrderViewController alloc] init];
        chackOut.hidesBottomBarWhenPushed = YES;
        chackOut.tokenStr = [self.protocolManager getSettleTokenStr];
        [self.navigationController pushViewController:chackOut animated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择商品!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
}

/**
 删除选中商品
 */
- (void)carDeleteToolsDeleteAction {
    if (self.settleToolsView.selectGoodsCount != 0) {
        __weak typeof(self) weakSelf = self;
        [GSCarRequestManager deleteCarGoodsWithRec_id:[self.protocolManager getSettleTokenStr] completed:^(BOOL isSuccess) {
            [weakSelf initCarDatas];
            [weakSelf resetEdit];
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择商品!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
}





@end
