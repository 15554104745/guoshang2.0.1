//
//  GoodsDetailViewController.m
//  guoshang
//
//  Created by JinLian on 16/9/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "MerchandiseBasicInfoTableViewCell.h"
#import "MerchandiseCommentTableViewCell.h"
#import "MerchandiseShopBasicInfoTableViewCell.h"
#import "GoodsDetailTableViewDelegate.h"
#import "GoodsDetailTableViewDataSource.h"
#import "GoodsDetailViewModel.h"
#import "XRCarouselView.h"
#import "UIImageView+WebCache.h"
#import "ParameterView.h"
#import "MoneyViewController.h"
#import "GBOrderViewController.h"

#import "GSChackOutOrderViewController.h"
#import "CarViewController.h"
//#import "LoginViewController.h"
#import "GSNewLoginViewController.h"

#import "STTopBar.h"
#import "global.h"
#import "RecommendView.h"
#import "GoodsDetailGoodsInfoModel.h"
#import "MBProgressHUD.h"
#import "HotGoodsModel.h"
#import "GoodsDetailGoodsInfoModel.h"

//判断确定按钮执行加入购物车方法还是执行立即购买方法
typedef enum {
    ensureTypeEnterAddToGoodsCar,       //加入购物车
    ensureTypeEnterAddToBuyNew,         //立即购买
}ensureOfType;


@interface GoodsDetailViewController ()<detailScrollViewDelegate,STTabBarDelegate,paramasDelegate,UICollectionViewDelegate> {
    
    GoodsDetailTableViewDelegate *tableViewDelegate;
    GoodsDetailTableViewDataSource *tableViewDataSource;
    GoodsDetailViewModel *detailViewModel;
    NSDictionary *datalist;
    UIButton *backButton;
    UIButton *cartButton;
    UIButton *menuButton;
    BOOL is_down;
    UIView *_downView;
    CGFloat minY;
    CGFloat maxY;
    BOOL isShowDetail;              // 图文详情开关，
    BOOL isTop;                     // 顶部视图布尔值，在Close方法中用到，判断动画不一样
    BOOL isShowTop;                 // 顶部视图弹出开关，只有当isShowTop为假时，才会显示，否则不显示
    UIWebView *paramsWeb;
    UILabel *car_lab;
    NSInteger goods_car_count;      //商品所在购物车的数量
}

@property (weak, nonatomic) IBOutlet UIView *allCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *firstTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) UIScrollView *headScrollView;
@property (strong, nonatomic) ParameterView *popView;           // 弹出底部视图
@property (strong, nonatomic) UIView *maskView;                 // 遮罩视图
@property (nonatomic, copy) NSString *rec_id;                   //添加商品到购物车时候返回的 购物车id
@property (strong, nonatomic) STTopBar *topBar;
@property (strong, nonatomic)RecommendView *collectionView;     //店铺推荐
@property (nonatomic, strong) UIWebView *webView;
@property (strong, nonatomic) UILabel *topMsgLabel;             // 顶部提示信息
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *addToCarView;
@property (assign, nonatomic)ensureOfType ensuretype;
@end

@implementation GoodsDetailViewController
#pragma mark - 初始化方法
+ (id)createGoodsDetailView {
    UIStoryboard *storlBoard = [UIStoryboard storyboardWithName:@"GoodsShow" bundle:nil];
    GoodsDetailViewController *goodsDetailVC = [storlBoard instantiateViewControllerWithIdentifier:@"goodsShowVC"];
    return goodsDetailVC;

}
#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allCollectionView.backgroundColor = MyColor;
    self.firstTableView.backgroundColor = MyColor;
    [self registerNib];
    [self createUI];
    [self createNavigationView];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(buttonCancleAction) name:@"buttonCancel"
                                              object:nil];
    

    [self.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"goodsShow_shoucang_gray"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"goodsShow_shoucang_red"] forState:UIControlStateSelected];
    [self.collectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.collectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.collectBtn setTitleColor:NewRedColor forState:UIControlStateSelected];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self carCountData];
    [self loadData];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [MBProgressHUD hideHUDForView:nil animated:YES];
    [super viewWillDisappear:animated];

//    self.navigationController.navigationBarHidden = NO;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"buttonCancel" object:nil];
}
//购物车数量
- (void)carCountData {
    GoodsDetailGoodsInfoModel *goodsModel = [datalist objectForKey:@"goodsInfo"];
    if (UserId && goodsModel.is_exchange != 1) {
        [HttpTool POST:URLDependByBaseURL(@"/Api/Cart/SumUserCartSingleGoods") parameters:@{@"token":[ @{@"user_id":UserId,@"goods_id":_goodsId} paramsDictionaryAddSaltString]} success:^(id responseObject) {

            goods_car_count  = [[[responseObject objectForKey:@"result"] objectForKey:@"total_num"] integerValue];
            if (goods_car_count == 0 ) {
                car_lab.hidden = YES;
            } else {
                car_lab.hidden = NO;
                car_lab.text = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"result"] objectForKey:@"total_num"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
}
- (void)loadData {
    detailViewModel = [[GoodsDetailViewModel alloc]init];
    detailViewModel.goodsDetailVC = self;
    detailViewModel.goodId = self.goodsId;
    
    STWeak(self);
    [detailViewModel passValueWithBlock:^(NSDictionary *dic) {
        datalist = dic;
        tableViewDelegate.dataListDic = dic;
        tableViewDataSource.dataListDic = dic;
        [weakself setupHeadView];
        [weakself.firstTableView reloadData];
        
        //加载webView
        GoodsDetailGoodsInfoModel *goodsModel = [datalist objectForKey:@"goodsInfo"];
        NSString * url = goodsModel.goods_desc;
        [weakself createDetailViewWithUrl:url];
        
        //开始在载时判断是否已收藏了该商品
        if (goodsModel.iscollect) {
            weakself.collectBtn.selected = YES;
        }
        
    }];
    
}
- (void)createUI {
    
    tableViewDelegate = [[GoodsDetailTableViewDelegate alloc]init];
    tableViewDelegate.delegate = self;
    tableViewDataSource = [[GoodsDetailTableViewDataSource alloc]init];
    tableViewDataSource.conreoller = self;
    tableViewDataSource.delegate = self;
    
    self.firstTableView.delegate = tableViewDelegate;
    self.firstTableView.dataSource = tableViewDataSource;
    self.headerView.frame = CGRectMake(0, 0, screenW, screenW);
    
    
    // 加载图文详情 tabbar
    NSArray* array  = @[@"图文详情",@"产品参数",@"店铺推荐"];
    STTopBar *topBar = [[STTopBar alloc]initWithArray:array];
    topBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, TopTabBarH);
    topBar.delegate = self;
    topBar.backgroundColor = [UIColor whiteColor];
    self.topBar = topBar;
    [self.secondView addSubview:topBar];
    
    //购物车商品提示
    car_lab = [[UILabel alloc]initWithFrame:CGRectMake(Width/3*2-24, Height-44-12, 24, 24)];
    [self.view addSubview:car_lab];
    [self.view bringSubviewToFront:car_lab];
    car_lab.layer.cornerRadius = 12;
    car_lab.textAlignment = NSTextAlignmentCenter;
    car_lab.font = [UIFont systemFontOfSize:12];
    car_lab.backgroundColor = [UIColor colorWithRed:255/255.0 green:1/255.0 blue:1/255.0 alpha:0.8];
    car_lab.textColor = [UIColor whiteColor];
    car_lab.clipsToBounds = YES;
    car_lab.hidden = YES;
    car_lab.text = [NSString stringWithFormat:@"%ld",goods_car_count];
    
}


- (void)passValueDelegate {
    self.ensuretype = ensureTypeEnterAddToBuyNew;
    [self open];
}

#pragma mark - 第二页视图
//第二页界面切换代理方法
- (void)tabBar:(STTopBar *)tabBar didSelectIndex:(NSInteger)index {
    switch (index) {
            //图文详情
        case 0: {
            GoodsDetailGoodsInfoModel *goodsModel = [datalist objectForKey:@"goodsInfo"];
            NSString * url = goodsModel.goods_desc;
            [self createDetailViewWithUrl:url];
        }
            break;
            //产品参数
        case 1: {
            GoodsDetailGoodsInfoModel *goodsModel = [datalist objectForKey:@"goodsInfo"];
            NSString * url = goodsModel.goods_attr_desc;
            [self createDetailViewWithUrl:url];
        }
            break;
            //店铺推荐
        case 2: {
            [self createRecommendView];
        }
            break;
        default:
            break;
    }
}
//加载webView
- (void)createDetailViewWithUrl:(NSString *)url {
    
    [_collectionView removeFromSuperview];
    //1.创建webview
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBar.frame), screenW,SCREEN_HEIGHT-100)];
    //根据屏幕大小自动调整页面尺寸
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = MyColor;
    _webView.scrollView.delegate = tableViewDelegate;
    [self.secondView addSubview:_webView];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //加载页面
    [_webView loadRequest:request];
}
//店铺推荐
- (void)createRecommendView {
    [_webView removeFromSuperview];
    _collectionView = [[RecommendView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBar.frame), screenW, self.secondView.frame.size.height - self.topBar.frame.size.height)];
    _collectionView.backgroundColor = MyColor;
        _collectionView.delegate = self;
    _collectionView.dataList = [datalist objectForKey:@"best"];
    [self.secondView addSubview:_collectionView];
}
//顶部 返回、购物车、分类按钮
- (void)createNavigationView {
    
    //顶部返回按钮
    backButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 30, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"tubiao1"] forState:UIControlStateNormal];
    backButton.tag = 503;
    [backButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //顶部购物者按钮
    cartButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 20, 30, 30)];
    [cartButton setBackgroundImage:[UIImage imageNamed:@"gouwuche1-1"] forState:UIControlStateNormal];
    cartButton.tag = 504;
    [cartButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cartButton];
    
    //顶部分类按钮
    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 20, 30, 30)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"tubiao2"] forState:UIControlStateNormal];
    menuButton.tag = 505;
    [menuButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
}
//第一页tableview注册单元格
- (void)registerNib {
    [self.firstTableView registerNib:[UINib nibWithNibName:kMerchandiseBasicInfoTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:kMerchandiseBasicInfoTableViewCellIdentifier];
    [self.firstTableView registerNib:[UINib nibWithNibName:kMerchandiseShopBasicInfoTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:kMerchandiseShopBasicInfoTableViewCellIdentifier];
    [self.firstTableView registerNib:[UINib nibWithNibName:kMerchandiseCommentTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:kMerchandiseCommentTableViewCellIdentifier];
}
//轮播图展示
- (void)setupHeadView {
    
    NSArray *arr = [datalist objectForKey:@"pictures"];
    //添加scrollerView为了上移动化效果
    self.headScrollView = [[UIScrollView alloc] initWithFrame:self.headerView.bounds];
    if (arr.count > 0) {
        XRCarouselView *carouselView = [[XRCarouselView alloc] initWithFrame:self.headerView.bounds];
        carouselView.placeholderImage = [UIImage imageNamed:@"ic_load_image_pleaceholder"];
        carouselView.imageArray = arr;
        //        carouselView.delegate = self;
        carouselView.time = 5;
        [self.headScrollView addSubview:carouselView];
    }else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_VIEW_HEIGHT)];
        NSString *imagestr = [[datalist objectForKey:@"goodsInfo"] objectForKey:@"goods_img"];
        if (imagestr.length > 0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagestr]];
        }else {
            imageView.image = [UIImage imageNamed:@"ic_load_image_pleaceholder"];
        }
        [self.headScrollView addSubview:imageView];
    }
    [self.headerView addSubview:self.headScrollView];
}
-(void)createDownView{
    _downView = [[UIView alloc]initWithFrame:CGRectMake(Width-70, 70, 70, 60)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    UIButton * classButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classButton.frame = CGRectMake(0, 0, _downView.bounds.size.width, 29);
    classButton.backgroundColor = [UIColor colorWithRed:75/255.0 green:57/255.0 blue:51/255.0 alpha:1];
    [classButton setTitle:@"分类" forState:UIControlStateNormal];
    classButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [classButton setImage:[UIImage imageNamed:@"fenlei"] forState:UIControlStateNormal];
    [classButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    classButton.tag = 30;
    [classButton addTarget:self action:@selector(dmButton:) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:classButton];
    
    UIButton * homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0, 30, _downView.bounds.size.width, 30);
    homeButton.backgroundColor = [UIColor colorWithRed:75/255.0 green:57/255.0 blue:51/255.0 alpha:1];
    [homeButton setTitle:@"主页" forState:UIControlStateNormal];
    homeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [homeButton setImage:[UIImage imageNamed:@"shouye1"] forState:UIControlStateNormal];
    [homeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [homeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    homeButton.tag = 31;
    [homeButton addTarget:self action:@selector(dmButton:) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:homeButton];
}
#pragma  mark - 视图移动相关
- (void)detailScrollView:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    //第一页tableview
    if (scrollView == self.firstTableView) {
        // 重新赋值，就不会有淘宝用力拖拽时的回弹
        self.headScrollView.contentOffset = CGPointMake(self.headScrollView.contentOffset.x, 0);
        if (self.firstTableView.contentOffset.y >= 0 &&  self.firstTableView.contentOffset.y <= HEADER_VIEW_HEIGHT) {
            self.headScrollView.contentOffset = CGPointMake(self.headScrollView.contentOffset.x, -offset / 2.0f);
        }else if (self.firstTableView.contentOffset.y < 0) {
//            self.headScrollView.contentOffset = CGPointMake(self.headScrollView.contentOffset.x, -offset/2);
//            self.headerView.clipsToBounds = NO;
//            self.headerView.backgroundColor = [UIColor clearColor];
//            self.headScrollView.backgroundColor = [UIColor clearColor];
//            self.headScrollView.clipsToBounds = NO;
        }
    }
    //第二页tableview
    else {
        if (offset <= 0 && offset >= -60) {
            self.topMsgLabel.alpha = fabs(offset)/100;
            self.topMsgLabel.text = @"下拉返回商品详情";
        }else if(offset < -60){
            self.topMsgLabel.text = @"释放返回商品详情";
        }
    }
}
- (void)detailScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        CGFloat offset = scrollView.contentOffset.y;
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
        if (maxY >= self.firstTableView.contentSize.height - SCREEN_HEIGHT + END_DRAG_SHOW_HEIGHT) {
            isShowDetail = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.allCollectionView.transform = CGAffineTransformTranslate(self.allCollectionView.transform, 0, - (SCREEN_HEIGHT - BOTTOM_VIEW_HEIGHT));
                backButton.alpha = 0;
                cartButton.alpha = 0;
                menuButton.alpha = 0;
            } completion:^(BOOL finished) {
                maxY = 0.0f;
                isShowDetail = YES;
            }];
        }
        // 滚到商品详情
        if (minY <= -60 && isShowDetail) {
            [UIView animateWithDuration:0.4 animations:^{
                self.allCollectionView.transform = CGAffineTransformIdentity;
                backButton.alpha = 1;
                cartButton.alpha = 1;
                menuButton.alpha = 1;
                
            } completion:^(BOOL finished) {
                minY = 0.0f;
                isShowDetail = NO;
                //                    self.topMsgLabel.text = @"下拉返回商品详情";
            }];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self detailScrollView:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self detailScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [datalist objectForKey:@"best"];
    HotGoodsModel *model = [arr objectAtIndex:indexPath.row];
    GoodsDetailViewController *goodsShow = [GoodsDetailViewController createGoodsDetailView];
    goodsShow.goodsId = [NSString stringWithFormat:@"%d",model.id];
    goodsShow.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsShow animated:YES];
}
#pragma mark -  网络请求相关  支付与加入购物车

//添加商品到购物车
- (void)addGoodsToGoodsCar {
        GoodsDetailGoodsInfoModel *goodsModel = [datalist objectForKey:@"goodsInfo"];
        NSString * is_exchange = [NSString stringWithFormat:@"%d", goodsModel.is_exchange];
        if (self.from.integerValue==1 || [is_exchange isEqualToString:@"1"]) {
            //        [AlertTool alertTitle:@"提示" mesasge:@"国币商品需直接购买" preferredStyle:UIAlertControllerStyleAlert confirmHandler:nil viewController:self];
            return;
        }
        if (UserId) {
            //加入商品到购物车
            //是否支持兑换
            //商品属性
            NSString *attr_id = _popView.attr_id.length > 0 ? _popView.attr_id : @"0";
            //商品数量
            NSString *num = _popView.chooseView.countView.tf_count.text;
            NSDictionary *dic = @{@"user_id":UserId,
                                  @"goods_id":_goodsId,
                                  @"num":num,
                                  @"attr_id":attr_id,
                                  @"is_exchange":is_exchange};
            __weak typeof(self)weakself = self;
            [MBProgressHUD showHUDWithCustomAnimationAddedTo:[[UIApplication sharedApplication].delegate window]];
            [HttpTool POST:URLDependByBaseURL(@"/Api/Cart/new_add_cart") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
    
                if ([responseObject[@"status"] isEqual:@2]) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"库存不足！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }else if ([responseObject[@"status"] isEqual:@3])
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"限时抢购商品只能买一件!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                
                }else {
                    //NSLog(@"%@",responseObject[@"message"]);
    //                _rec_id = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
    
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"添加成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                [weakself close];
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            }];
    
            if (num.length > 0) {
                car_lab.hidden = NO;
                [self carCountData];
    
            }
            
        }else {
            //未登录时
            [self close];
            [self PlaestLogIn];
        }
    
}
//立即购买
- (void)goodsButNewAction {
    if (UserId) {
        STWeak(self);
        //加入商品到购物车
        GoodsDetailGoodsInfoModel *goodsModel = [datalist objectForKey:@"goodsInfo"];
        NSString * is_exchange = [NSString stringWithFormat:@"%d", goodsModel.is_exchange];
        //商品属性
        NSString *attr_id = _popView.attr_id.length > 0 ? _popView.attr_id : @"0";
        //商品数量
        NSString *num = _popView.chooseView.countView.tf_count.text;
        NSDictionary *dic = @{@"user_id":UserId,
                              @"goods_id":_goodsId,
                              @"num":num,
                              @"attr_id":attr_id,
                              @"is_exchange":is_exchange};
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:[[UIApplication sharedApplication].delegate window]];
        [HttpTool POST:URLDependByBaseURL(@"/Api/Cart/new_add_cart") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
            if ([responseObject[@"status"] isEqual:@2]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"库存不足！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }
            //NSLog(@"%@",responseObject[@"message"]);
            _rec_id = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
            
            [weakself payMoney];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
            
        }];
    }else {
        //未登录时
        [self close];
        [self PlaestLogIn];
    }

}
//取消按钮
- (void)buttonAction:(UIButton *)sender {
    [self close];
}
//确定按钮
- (void)buyNewAction {
    
    if (self.ensuretype == ensureTypeEnterAddToBuyNew) {
        [self goodsButNewAction];
    }else if (self.ensuretype == ensureTypeEnterAddToGoodsCar){
        [self addGoodsToGoodsCar];
    }
}
//支付
- (void)payMoney {
    [self close];
    GSChackOutOrderViewController *chackOutOrderViewController = ViewController_in_Storyboard(@"Main", @"GSChackOutOrderViewController");
    //MoneyViewController * mvc = [[MoneyViewController alloc]init];
    //GBOrderViewController * gbvc = [[GBOrderViewController alloc]init];
    
    GoodsDetailGoodsInfoModel *goodsModel = [datalist objectForKey:@"goodsInfo"];
    NSString * is_exchange = [NSString stringWithFormat:@"%d", goodsModel.is_exchange];
    if ([is_exchange isEqualToString:@"0"]) {    //0:不支持使用国币兑换  1：支持使用国币兑换
        //金币
        
        if (_rec_id && _rec_id.length > 0) {
            chackOutOrderViewController.tokenStr = _rec_id;
            chackOutOrderViewController.chackOutOrderType = GSChackOutOrderTypeDefault;
        }
    }else{
        //国币
        chackOutOrderViewController.tokenStr = _rec_id;
        chackOutOrderViewController.chackOutOrderType = GSChackOutOrderTypeGuoBi;
    }
    chackOutOrderViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chackOutOrderViewController animated:YES];
}
#pragma mark - button 点击方法
//收藏
- (IBAction)CollectBtn:(UIButton *)sender {
    if (UserId) {
        NSString * userId = [NSString stringWithFormat:@"user_id=%@,goods_id=%@",UserId,_goodsId];
        NSString * encryptString = [userId encryptStringWithKey:KEY];
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:[[UIApplication sharedApplication].delegate window]];
        [HttpTool POST:URLDependByBaseURL(@"/Api/User/addcollect") parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            if ([responseObject[@"status"] isEqualToNumber:@0]) {
                sender.selected = YES;
            }else if ([responseObject[@"status"] isEqualToNumber:@3]){
                sender.selected = NO;
            }
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        }];
    }else{
        [self PlaestLogIn];
    }
    
}
- (void)buttonCancleAction{
    [self close];
}
//添加到购物车
- (IBAction)AddToCard:(UIButton *)sender {
    self.ensuretype = ensureTypeEnterAddToGoodsCar;
    GoodsDetailGoodsInfoModel *goodsModel = [datalist objectForKey:@"goodsInfo"];
    NSString * is_exchange = [NSString stringWithFormat:@"%d", goodsModel.is_exchange];
    if (self.from.integerValue==1 || [is_exchange isEqualToString:@"1"]) {
        [AlertTool alertTitle:@"提示" mesasge:@"国币商品需直接购买" preferredStyle:UIAlertControllerStyleAlert confirmHandler:nil viewController:self];
    } else {
        [self open];
    }
}
//立即购买
- (IBAction)BuyNew:(UIButton *)sender {
    self.ensuretype = ensureTypeEnterAddToBuyNew;
    [self open];
}
//返回、购物车、分类   底部收藏、添加购物车、立即购买按钮 功能实现
- (void)bottomButtonAction:(UIButton *)sender {
    NSInteger indexTag = sender.tag - 500;
    switch (indexTag) {
            //返回上一级
        case 3: {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            //跳转购物车
        case 4: {
//            NSLog(@"%@",self.tabBarController);
//            self.tabBarController.selectedIndex = 2;
            CarViewController *car = [[CarViewController alloc]init];
            [self.navigationController pushViewController:car animated:YES];
            
        }
            break;
            //分类
        case 5: {
            is_down = !is_down;
            if (is_down) {
                [self createDownView];
            }else{
                [_downView removeFromSuperview];
            }
        }
            break;
        default:
            break;
    }
}
//下拉菜单按钮点击事件
-(void)dmButton:(UIButton *)button{
    switch (button.tag) {
        case 30:
        {
            self.tabBarController.selectedIndex = 1;
            [_downView removeFromSuperview];
            [self.navigationController popToRootViewControllerAnimated:YES];
            is_down = NO;
        }
            break;
        case 31:
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            [_downView removeFromSuperview];
            is_down = NO;
            break;
        default:
            break;
    }
}

#pragma mark - 动画过度
- (void)open {
    isTop = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.layer.transform = [self firstStepTransform];
        self.maskView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.view.layer.transform = [self secondStepTransform];
            self.popView.transform = CGAffineTransformTranslate(self.popView.transform, 0, -SCREEN_HEIGHT/2-20);
        }];
    }];
}
- (void)close {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.layer.transform = [self firstStepTransform];
        self.popView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.layer.transform = CATransform3DIdentity;
            self.maskView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self.popView removeFromSuperview];
        }];
    }];
}
// 动画1
- (CATransform3D)firstStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500.0;
    transform = CATransform3DScale(transform, 0.98, 0.98, 1.0);
    transform = CATransform3DRotate(transform, 5.0 * M_PI / 180.0, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, -30.0);
    return transform;
}
// 动画2
- (CATransform3D)secondStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = [self firstStepTransform].m34;
    transform = CATransform3DTranslate(transform, 0, SCREEN_HEIGHT * -0.08, 0);
    transform = CATransform3DScale(transform, 0.8, 0.8, 1.0);
    return transform;
}
#pragma mark - setter and getter
//选择商品属性界面弹出视图
- (ParameterView *)popView {
    if (!_popView) {
        _popView = [[ParameterView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT / 2.0f)];
    //_popView.backgroundColor = [UIColor colorWithRed:1.000 green:0.988 blue:0.960 alpha:1.000];
       _popView.backgroundColor = MyColor;
        
        [_popView.chooseView.bt_cancle addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        //点击确定添加或者立即购买添加商品
        _popView.dataList = datalist;
        [_popView.chooseView.bt_sure addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_popView.chooseView.bt_buyNew addTarget:self action:@selector(buyNewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popView;
}
//遮罩视图
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.400];
        _maskView.alpha = 0.0f;
        // 添加点击背景按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:SCREEN_BOUNDS];
        [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:btn];
    }
    return _maskView;
}

- (UILabel *)topMsgLabel {
    if (!_topMsgLabel) {
        _topMsgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, screenW, 40)];
        _topMsgLabel.text = @"下拉返回商品详情";
        _topMsgLabel.alpha = 0;
        _topMsgLabel.font = [UIFont systemFontOfSize:12];
        _topMsgLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_topMsgLabel];
    }
    return _topMsgLabel;
}

//登录提示
- (void)PlaestLogIn {
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请登录" preferredStyle:UIAlertControllerStyleAlert];
    [alertvc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GSNewLoginViewController * lvc = [[GSNewLoginViewController alloc]init];
        lvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lvc animated:YES];
    }]];
    [alertvc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertvc animated:YES completion:nil];
}

@end
