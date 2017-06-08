//
//  GSGoodsDetailInfoViewController.m
//  guoshang
//
//  Created by Rechied on 2016/11/10.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetailInfoViewController.h"
#import "GSChackOutOrderViewController.h"
#import "GSNewLoginViewController.h"
#import "XRCarouselView.h"

#import "GSNewCarViewController.h"

#import "GSGoodsDetailBaseCell.h"
#import "GSGoodsDetialGoodsInfoCell.h"
#import "GSGoodsDetialChooseSpecificationsCell.h"
#import "GSGoodsDetialRecommendGoodsCell.h"
#import "GSGoodsDetialShopInfoCell.h"
#import "GSGoodsDetailDistributionCell.h"
#import "GSGoodsDetailDetailsView.h"
#import "GSNavigationViewDropView.h"

#import "ParameterView.h"

#import "RequestManager.h"
#import "STTopBar.h"
#import "UIColor+HaxString.h"
#import "MBProgressHUD.h"

#import "GSShopBaseGoodsModel.h"

#import "GSSpecificationsManager.h"
#import "GSSelectSpecificationsView.h"

#import "GSSpecificationsGoodsModel.h"

#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds
#define SCREEN_SIZE     [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define END_DRAG_SHOW_HEIGHT    80.0f
#define BOTTOM_VIEW_HEIGHT      49.0f
#define HEADER_VIEW_HEIGHT      [UIScreen mainScreen].bounds.size.width

typedef NS_ENUM(NSInteger, GSGoodsDetailBottomToolsBarButtonType) {
    GSGoodsDetailBottomToolsBarButtonTypeCollect = 10,
    GSGoodsDetailBottomToolsBarButtonTypeAddToCar,
    GSGoodsDetailBottomToolsBarButtonTypeBuyNow,
    GSGoodsDetailBottomToolsBarButtonTypeChooseAttribute,
};

typedef NS_ENUM(NSInteger, GSGoodsDetailNavigationBarButtonType) {
    GSGoodsDetailNavigationBarButtonTypeGoods = 20,
    GSGoodsDetailNavigationBarButtonTypeDetail,
};

@interface GSGoodsDetailInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, STTabBarDelegate, GSGoodsDetialRecommendGoodsCellDelegate, GSNavigationViewDropViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *navigationScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;      //最底层ScrollView, 左右滑动
@property (weak, nonatomic) IBOutlet UITableView *firstTableView;       //顶部效果图
@property (weak, nonatomic) IBOutlet UIView *bottomView;                //tableView下方的详情View
@property (weak, nonatomic) IBOutlet UIView *rightContentView;          //baseScrollView右边的ContentView
@property (weak, nonatomic) IBOutlet UIView *bottomToolsView;           //底部悬浮工具栏
@property (weak, nonatomic) IBOutlet UIButton *collectGoodsButton;      //商品收藏按钮
@property (weak, nonatomic) IBOutlet UIView *leftAllView;               //左边上下翻页的基层View
@property (weak, nonatomic) IBOutlet UIButton *toTopButton;


@property (weak, nonatomic) UIScrollView *headerScrollView;             //tableView上移时, 半遮挡效果
@property (weak, nonatomic) XRCarouselView *goodsImageCarouselView;     //轮播图
@property (weak, nonatomic) STTopBar *webViewTopBar;                    //webView上方的工具条
@property (weak, nonatomic) UIWebView *webView;

@property (copy, nonatomic) NSArray *cellIdentifierArray;
@property (assign, nonatomic) BOOL isShowDetail;                        //是否正在展示图文详情

@property (copy, nonatomic) NSString *rec_id;

@property (strong, nonatomic) NSMutableArray *cellArray;

@property (assign, nonatomic) GSGoodsDetailBottomToolsBarButtonType selectToolsBarType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navToolsViewTapViewLeading;
@property (weak, nonatomic) IBOutlet UIView *navToolsTapView;

@property (weak, nonatomic) GSGoodsDetailDetailsView *rightDetialView;
@property (weak, nonatomic) GSNavigationViewDropView *dropView;
@property (weak, nonatomic) UILabel *topMsgLabel;
@property (assign, nonatomic) CGAffineTransform leftAllViewTransForm;

@property (strong, nonatomic) GSSpecificationsManager *specificationsManager;
@end


@implementation GSGoodsDetailInfoViewController

- (instancetype)init {
    self = ViewController_in_Storyboard(@"Main", @"GSGoodsDetailInfoViewController");
    return self;
}

- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _cellArray;
}

- (GSNavigationViewDropView *)dropView {
    if (!_dropView) {
        GSNavigationViewDropView *dropView = [[GSNavigationViewDropView alloc] init];
        dropView.delegate = self;
        _dropView = dropView;
        [self.view addSubview:dropView];
        return _dropView;
    }
    return _dropView;
}

- (UILabel *)topMsgLabel {
    if (!_topMsgLabel) {
        UILabel *topMsgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 60)];
        topMsgLabel.text = @"下拉返回商品详情";
        topMsgLabel.alpha = 0;
        topMsgLabel.font = [UIFont systemFontOfSize:12];
        topMsgLabel.textAlignment = NSTextAlignmentCenter;
        [self.webView addSubview:topMsgLabel];
        self.topMsgLabel = topMsgLabel;
        return _topMsgLabel;
    }
    return _topMsgLabel;
}

- (GSSpecificationsManager *)specificationsManager {
    if (!_specificationsManager) {
        _specificationsManager = [[GSSpecificationsManager alloc] init];
        
    }
    return _specificationsManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTableView.rowHeight = UITableViewAutomaticDimension;
    self.firstTableView.estimatedRowHeight = 100;
    self.leftAllViewTransForm = self.bottomView.transform;
    self.cellIdentifierArray = @[@"GSGoodsDetialGoodsInfoCell",@"GSGoodsDetialChooseSpecificationsCell",@"GSGoodsDetailDistributionCell",@"GSGoodsDetialShopInfoCell",@"GSGoodsDetialRecommendGoodsCell"];
    [self setupHeader];
    if (self.goodsDetailModel) {
        [self setupDatas];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/**
 初始化表头 循环轮播
 */
- (void)setupHeader {
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Width)];
    UIScrollView *headerScrollView = [[UIScrollView alloc] initWithFrame:tableHeaderView.bounds];
    headerScrollView.bounces = NO;
    
    XRCarouselView *carouselView = [[XRCarouselView alloc] initWithFrame:tableHeaderView.bounds];
    
    //carouselView.pagePosition = PositionBottomRight;
    [carouselView setPageColor:[UIColor whiteColor] andCurrentPageColor:[UIColor colorWithHexString:@"E42144"]];
    carouselView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.recommendModel) {
        NSDictionary *dic = [_recommendModel mj_keyValues];
        if ([dic objectForKey:@"thumb"]) {
            carouselView.imageArray = @[[dic objectForKey:@"thumb"]];
        }
        if ([dic objectForKey:@"goods_thumb"]) {
            carouselView.imageArray = @[[dic objectForKey:@"goods_thumb"]];
        }
    } else {
        carouselView.placeholderImage = [UIImage imageNamed:@"ic_load_image_pleaceholder"];
        carouselView.imageArray = @[[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    }
    [headerScrollView addSubview:carouselView];
    self.goodsImageCarouselView = carouselView;
    [tableHeaderView addSubview:headerScrollView];
    self.headerScrollView = headerScrollView;
    self.firstTableView.tableHeaderView = tableHeaderView;
}


/**
 初始化底部图文详情
 */
- (void)setupDetailView {
    STTopBar *webViewTopBar = [[STTopBar alloc] initWithArray:@[@"商品详情",@"规格参数"]];
    webViewTopBar.delegate = self;
    [self.bottomView addSubview:webViewTopBar];
    [webViewTopBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.offset(44.0f);
    }];
    self.webViewTopBar = webViewTopBar;
    
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsDetailModel.goodsinfo.goods_desc]]];
    webView.scrollView.delegate = self;
    webView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.bottomView addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.equalTo(webViewTopBar.mas_bottom);
    }];
    self.webView = webView;
}

/**
 设置收藏商品按钮
 */
- (void)setupCollectGoodsButton {
    self.collectGoodsButton.selected = [self.goodsDetailModel.goodsinfo.iscollect boolValue];
}

/**
 切换收藏商品按钮状态
 */
- (void)changeCollectGoodsButtonType {
    self.collectGoodsButton.selected = !self.collectGoodsButton.isSelected;
}

/**
 发送收藏／取消收藏商品请求
 */
- (void)sendCollectOrDeCollectGoodsRequest {
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/User/addcollect") parameters:[@{@"user_id":UserId,@"goods_id":self.goodsDetailModel.goodsinfo.goods_id} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        [weakSelf changeCollectGoodsButtonType];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (void)setRecommendModel:(id)recommendModel {
    _recommendModel = recommendModel;
    
    NSDictionary * dic = [recommendModel mj_keyValues];
    
    [self getGoodsDetailInfoWithGoods_id:dic[@"goods_id"] ? dic[@"goods_id"] : dic[@"id"]];
}

- (void)setGoodsDetailModel:(GSGoodsDetailModel *)goodsDetailModel {
    _goodsDetailModel = goodsDetailModel;
    if ([self isViewLoaded]) {
        [self setupDatas];
    }
}

- (void)setupDatas {
    self.goodsImageCarouselView.imageArray = [self.goodsDetailModel getAllImageURL];
    [self setupDetailView];
    [self setupCollectGoodsButton];
    [self.firstTableView reloadData];
}


/**
 根据goods_id获取商品详情

 @param goods_id 商品id
 */
- (void)getGoodsDetailInfoWithGoods_id:(NSString *)goods_id {
    
    NSDictionary *params = nil;
    if (UserId) {
        params = @{@"user_id":UserId,@"goods_id":goods_id};
    } else {
        params = @{@"goods_id":goods_id};
    }
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Goods/view") parameters:params completed:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([responseObject[@"status"] isEqualToNumber:@(1)]) {
            weakSelf.goodsDetailModel = [GSGoodsDetailModel mj_objectWithKeyValues:responseObject[@"result"]];
        }
    }];
    
}

/**
 顶部导航 商品 详情 点击后使baseScrollView翻页,并移动顶部导航的tapView

 @param navigationBarButtonType 顶部button的类型
 */
- (void)baseScrollViewScrollToPageWithNavigationBarButtonType:(GSGoodsDetailNavigationBarButtonType)navigationBarButtonType {
    switch (navigationBarButtonType) {
        case GSGoodsDetailNavigationBarButtonTypeGoods: {
            [self.baseScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView animateWithDuration:0.25 animations:^{
               self.navToolsTapView.transform = CGAffineTransformIdentity;
            }];
        }
            break;
            
        case GSGoodsDetailNavigationBarButtonTypeDetail: {
            if (!_rightDetialView) {
                GSGoodsDetailDetailsView *detailsView = [[GSGoodsDetailDetailsView alloc] init];
                detailsView.goodsDetailModel = self.goodsDetailModel;
                [self.rightContentView addSubview:detailsView];
                self.rightDetialView = detailsView;
                [detailsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.right.bottom.mas_offset(0);
                }];
            }
            [UIView animateWithDuration:0.25 animations:^{
                self.navToolsTapView.transform = CGAffineTransformTranslate(self.navToolsTapView.transform, 64, 0);
            }];
            
            [self.baseScrollView setContentOffset:CGPointMake(Width, 0) animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Action

/**
 导航返回按钮点击事件
 */
- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 导航商品、详情按钮点击事件
 */
- (IBAction)navigationToolsBarButtonClick:(UIButton *)button {
    GSGoodsDetailNavigationBarButtonType navigationBarButtonType = button.tag;
    [self baseScrollViewScrollToPageWithNavigationBarButtonType:navigationBarButtonType];
}

/**
 导航更多钮点击事件
 */
- (IBAction)moreButtonClick:(id)sender {
    [self.dropView changeDropViewStatus];
}


/**
 底部收藏、加入购物车、立即购买点击事件
 */
- (IBAction)toolsBarButtonClick:(UIButton *)sender {
    if ([self isLoginSuccess]) {
        GSGoodsDetailBottomToolsBarButtonType buttonType = sender.tag;
        switch (buttonType) {
            case GSGoodsDetailBottomToolsBarButtonTypeCollect:
                if ([self isLoginSuccess]) {
                    [self sendCollectOrDeCollectGoodsRequest];
                }
                break;
                
            case GSGoodsDetailBottomToolsBarButtonTypeAddToCar:
                self.selectToolsBarType = buttonType;
                [self judgeIfGuobiGoods];
                break;
                
            case GSGoodsDetailBottomToolsBarButtonTypeBuyNow:
                if (self.rec_id) {
                    [self toChackOutOrder];
                } else {
                    self.selectToolsBarType = buttonType;
                    [self showChooseView];
                }
                break;
                
            default:
                break;
        }
    }
    
}

/**
 购物车悬浮按钮点击时间
 */
- (IBAction)toCar:(id)sender {
    if ([self isLoginSuccess]) {
        GSNewCarViewController *carViewController = [[GSNewCarViewController alloc] init];
        carViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:carViewController animated:YES];
    }
}

/**
 置顶按钮点击事件
 */
- (IBAction)toTop:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.4 animations:^{
        [weakSelf.webView.scrollView setContentOffset:CGPointZero animated:YES];
        weakSelf.leftAllView.transform = CGAffineTransformIdentity;
        [_navigationScrollView setContentOffset:CGPointMake(0, 0)];
        [weakSelf.firstTableView setContentOffset:CGPointZero animated:YES];
    } completion:^(BOOL finished) {
        weakSelf.isShowDetail = NO;
        weakSelf.toTopButton.hidden = YES;
    }];
}

//判断是否是国币商品
-(void)judgeIfGuobiGoods
{
    if ([self.goodsDetailModel.goodsinfo.is_exchange isEqualToString:@"1"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"国币商品不允许加入购物车" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        [self showChooseView];
    }
}

- (void)showChooseView {
    BOOL hasAttribute = self.goodsDetailModel.attribute.count != 0;
    if (!_specificationsManager) {
        if (hasAttribute) {
            [self.specificationsManager showChooseSpecificationsWithCurrentView:self.view goodsModel:self.goodsDetailModel.goodsinfo showFcousAnimaiton:YES];
        } else {
            [self.specificationsManager showAddToCarViewWithCurrentView:self.view goodsModel:self.goodsDetailModel.goodsinfo];
        }
        [self.specificationsManager.selectView.closeButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.specificationsManager.selectView.commitButton addTarget:self action:@selector(commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.specificationsManager open];
    }
}

/**
 弹出框 取消按钮点击事件
 */
- (void)cancelButtonAction:(UIButton *)button {
    
    [self.specificationsManager close];
}


/**
 弹出框 选择数量后 确定按钮点击事件
 */
- (void)commitButtonAction:(UIButton *)button {
    if (self.selectToolsBarType == GSGoodsDetailBottomToolsBarButtonTypeChooseAttribute) {
        if (self.specificationsManager.selectView.specificationsTotalModel) {
            if (self.specificationsManager.selectView.specificationsTotalModel.selectSpecificationsDictionary.count != self.specificationsManager.selectView.specificationsTotalModel.attr_list.count) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择规格!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
                return;
            } else {
                GSSpecificationsGoodsModel *specificationsGoodsModel = [self.specificationsManager.selectView.specificationsTotalModel.contantGoodsArray firstObject];

                self.goodsDetailModel.attribute_name = specificationsGoodsModel.object_names;
                self.goodsDetailModel.goodsinfo.shop_price = specificationsGoodsModel.shop_price;
            }
        }
        [self.firstTableView reloadData];
        [self.specificationsManager close];
    } else {
        [self addToCar];
    }
}

/**
 跳转到确认订单
 */
- (void)toChackOutOrder {
    [self.specificationsManager close];
    if (_rec_id && _rec_id.length > 0) {
        GSChackOutOrderViewController *chackOutOrderViewController = ViewController_in_Storyboard(@"Main", @"GSChackOutOrderViewController");
        chackOutOrderViewController.tokenStr = _rec_id;
        if ([self.goodsDetailModel.goodsinfo.is_exchange isEqualToString:@"1"]) {
            chackOutOrderViewController.chackOutOrderType = GSChackOutOrderTypeGuoBi;
        }else
        {
            chackOutOrderViewController.chackOutOrderType = GSChackOutOrderTypeDefault;
        }
        chackOutOrderViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chackOutOrderViewController animated:YES];
    }
}


/**
 添加商品到购物车
 */
- (void)addToCar {
    if ([self isLoginSuccess]) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:UserId forKey:@"user_id"];
        [params setObject:_goodsDetailModel.goodsinfo.goods_id forKey:@"goods_id"];
        [params setObject:self.specificationsManager.selectView.countView.tf_count.text forKey:@"num"];
        [params setObject:_goodsDetailModel.goodsinfo.is_exchange forKey:@"is_exchange"];
        [params setObject:@"" forKey:@"attr_id"];
        if (self.specificationsManager.selectView.specificationsTotalModel) {
            if (self.specificationsManager.selectView.specificationsTotalModel.selectSpecificationsDictionary.count != self.specificationsManager.selectView.specificationsTotalModel.attr_list.count) {
                [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请先选择规格!" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] show];
                return;
            } else {
                
                NSString *attribute_id = [[self.specificationsManager.selectView.specificationsTotalModel.contantGoodsArray firstObject] ID];
                [params setObject:attribute_id forKey:@"attr_id"];
            }
        }

        NSString *token = [params paramsDictionaryAddSaltString];
        
        __weak typeof(self)weakself = self;
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:[[UIApplication sharedApplication].delegate window]];
        
        [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Cart/new_add_cart") parameters:@{@"token":token} completed:^(id responseObject, NSError *error) {
            
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            [weakself.specificationsManager close];
            NSString *message = nil;
            if (error) {
                message = @"添加失败，请稍后再试!";
            } else if ([responseObject[@"status"] integerValue] == 1 || [responseObject[@"status"] integerValue] == 4 ) {
                message = @"添加失败，请稍后再试!";
            } else if ([responseObject[@"status"] integerValue] == 0) {
                weakself.rec_id = responseObject[@"result"];
                switch (self.selectToolsBarType) {
                    case GSGoodsDetailBottomToolsBarButtonTypeAddToCar: {
                        message = responseObject[@"message"];
                    }
                        break;
                        
                    case GSGoodsDetailBottomToolsBarButtonTypeBuyNow: {
                        message = nil;
                        [weakself toChackOutOrder];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            } else {
                message = responseObject[@"message"];
            }
            if (message) {
                CKAlertViewController *alert = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:message];
                CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"我知道了" handler:nil];
                [alert addAction:cancel];
                [weakself presentViewController:alert animated:NO completion:nil];
            }
            
            
        }];
        
    }
}

#pragma mark - GSNavigationViewDropViewDelegate

- (void)dropViewDidSelectIndex:(NSInteger)index {
    if (index == 2) {
        [self toCar:nil];
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

#pragma mark - STTopBarDelegate 

/**
 详情页底部 
 */
- (void)tabBar:(STTopBar *)tabBar didSelectIndex:(NSInteger)index {
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:index == 0 ? self.goodsDetailModel.goodsinfo.goods_desc : self.goodsDetailModel.goodsinfo.goods_attr_desc]]];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    //第一页tableview
    if (scrollView == self.firstTableView) {
        // 重新赋值，就不会有淘宝用力拖拽时的回弹
        self.headerScrollView.contentOffset = CGPointMake(self.headerScrollView.contentOffset.x, 0);
        if (self.firstTableView.contentOffset.y >= 0 &&  self.firstTableView.contentOffset.y <= HEADER_VIEW_HEIGHT) {
            self.headerScrollView.contentOffset = CGPointMake(self.headerScrollView.contentOffset.x, -offset / 2.0f);
        }
        CGFloat scrollViewHeight = scrollView.bounds.size.height;
        CGFloat contentHeight = scrollView.contentSize.height;
        if (offset >= contentHeight - scrollViewHeight) {
            CGFloat ty = contentHeight - scrollViewHeight -offset;
            self.bottomView.transform = CGAffineTransformTranslate(self.leftAllViewTransForm, 0, ty);
        }
        
    }
    //第二页tableview
    else if (scrollView == self.webView.scrollView) {
        if (offset <= 0 && offset >= -60) {
            self.topMsgLabel.alpha = fabs(offset)/100;
            self.topMsgLabel.text = @"下拉返回商品详情";
        }else if(offset < -60){
            self.topMsgLabel.text = @"释放返回商品详情";
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        __weak typeof(self) weakSelf = self;
        CGFloat offset = scrollView.contentOffset.y;
        __block CGFloat minY = 0;
        __block CGFloat maxY = 0;
        if (scrollView == self.firstTableView) {
            if (offset < 0) {
                minY = MIN(minY, offset);  //两者取最小值
            } else {
                maxY = MAX(maxY, offset); //两者取最大值
            }
        } else {
            minY = MIN(minY, offset);
        }
        // 滚到图文详情
        if (maxY >= self.firstTableView.contentSize.height - (Height - 49 - 64.0f) + END_DRAG_SHOW_HEIGHT) {
            self.isShowDetail = NO;
            
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.leftAllView.transform = CGAffineTransformTranslate(weakSelf.leftAllView.transform, 0, - (Height - 49 - 64.0f));
                [_navigationScrollView setContentOffset:CGPointMake(0, 44)];
            } completion:^(BOOL finished) {
                maxY = 0.0f;
                weakSelf.isShowDetail = YES;
                weakSelf.toTopButton.hidden = NO;
            }];
           
        }
        // 滚到商品详情
        if (minY <= -60 && self.isShowDetail && scrollView == self.webView.scrollView) {
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.leftAllView.transform = CGAffineTransformIdentity;
                [_navigationScrollView setContentOffset:CGPointMake(0, 0)];
            } completion:^(BOOL finished) {
                minY = 0.0f;
                weakSelf.isShowDetail = NO;
                weakSelf.toTopButton.hidden = YES;
            }];
        }
    }

}

#pragma mark - GSGoodsDetialRecommendGoodsCellDelegate

/**
 推荐商品模块高度更新后调用的方法
 */
- (void)goodsDetailRecommendGoodsCellDidUpdateHeight {
    [self.firstTableView beginUpdates];
    [self.firstTableView endUpdates];
}

- (void)goodsDetailRecommendGoodsCellDidSelectGoodsWithGoodsModel:(id)goodsModel {
    GSGoodsDetailInfoViewController *goodsDetailInfoViewController = [[GSGoodsDetailInfoViewController alloc] init];
    goodsDetailInfoViewController.recommendModel = goodsModel;
    goodsDetailInfoViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailInfoViewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        self.selectToolsBarType = GSGoodsDetailBottomToolsBarButtonTypeChooseAttribute;
        [self showChooseView];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.goodsDetailModel) {
        return 5;
    } else if (_recommendModel) {
        return 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self getTableViewCellWithIndexPath:indexPath];
    
}

- (UITableViewCell *)getTableViewCellWithIndexPath:(NSIndexPath *)indexPath {
    
    GSGoodsDetailBaseCell *tableViewCell = nil;
    
    if (indexPath.row < self.cellArray.count) {
        tableViewCell = self.cellArray[indexPath.row];
    } else {
        tableViewCell = [self.firstTableView dequeueReusableCellWithIdentifier:self.cellIdentifierArray[indexPath.row] forIndexPath:indexPath];
        if ([tableViewCell isKindOfClass:[GSGoodsDetialRecommendGoodsCell class]]) {
            GSGoodsDetialRecommendGoodsCell *cell = (GSGoodsDetialRecommendGoodsCell *)tableViewCell;
            cell.delegate = self;
        }
        
        [self.cellArray insertObject:tableViewCell atIndex:indexPath.row];
    }
    
    if (self.goodsDetailModel) {
        if (!tableViewCell.detailModel || indexPath.row == 0 || indexPath.row == 1) {
            tableViewCell.detailModel = self.goodsDetailModel;
        }
    } else {
        if (indexPath.row == 0 && self.recommendModel) {
            GSGoodsDetialGoodsInfoCell *goodsInfoCell = (GSGoodsDetialGoodsInfoCell *)tableViewCell;
            goodsInfoCell.recommendModel = self.recommendModel;
        }
    }
    return tableViewCell;
}


/**
 判断用户是否登录

 @return YES: 已登录  NO: 未登录
 */
- (BOOL)isLoginSuccess {
    if (UserId) {
        return YES;
    } else {
        CKAlertViewController *alert = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"您还没有登录,请先登录!"];
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"我再想想" handler:nil];
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"立即登录" backgroundColor:[UIColor colorWithHexString:@"f23030"] titleColor:[UIColor whiteColor] handler:^(CKAlertAction *action) {
            GSNewLoginViewController *loginViewController = [[GSNewLoginViewController alloc] init];
            loginViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginViewController animated:YES];
        }];
        [alert addAction:cancel];
        [alert addAction:sure];
        [self presentViewController:alert animated:NO completion:nil];
        return NO;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
