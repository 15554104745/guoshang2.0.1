//
//  GSCustomOrderViewController.m
//  guoshang
//
//  Created by 金联科技 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCustomOrderViewController.h"
#import "GSCustomAllOrderViewController.h"
#import "GSCustomPaymentViewController.h"
#import "GSCustomGoodsViewController.h"
#import "GSCustomReceiveGoodsViewController.h"
#import "GSAchieveViewController.h"
#import "ShopStateView.h"

@interface GSCustomOrderViewController ()<ShopStateViewDelegate, UITextFieldDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong) UITextField *searchField; //搜索框
@property (nonatomic, strong) UIButton *selectBtn; //选中按钮
@property (nonatomic, strong) ShopStateView * stateView;
@property (nonatomic, strong)  UIPageViewController *paeVc;
@property (nonatomic, strong)  NSArray *subsArray;
@property (nonatomic, assign)  NSInteger nextIndex;

@end

@implementation GSCustomOrderViewController

#pragma mark - 生命周期


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    默认设置
    [self defaultSettings];
//    创建子视图
    [self createSubViews];

}

- (void)createSubViews {
    //    创建navBar
    [self createNav];
    //搜索框
    [self createSearchField];
    //代销产品／自销产品

   // [self createShopTypeBtns];

//    [self createShopTypeBtns];

    //全部／待付款／待发货／待收货／已完成
    [self createGroupItems];
    //    创建pageVC
    [self createPageVC];
}


- (void)createNav{
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, Width, 64);
    navView.backgroundColor = GS_Business_NavBarColor;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 48, 48);
    [backBtn setImage:[UIImage imageNamed:@"back_jt"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    CGFloat titleX =CGRectGetMaxX(backBtn.frame);
    CGFloat titleY= 20;
    CGFloat titleW= Width-backBtn.frame.size.width*2;
    CGFloat titleH = 44;
    titleLabel.frame = CGRectMake(titleX, titleY,titleW,titleH);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"客户订单";
    [navView addSubview:titleLabel];
    [self.view addSubview:navView];
    
    
}

- (void)defaultSettings{
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)createSearchField {
    //搜索框
    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(5, 74, self.view.bounds.size.width-10, 35)];
    self.searchField = searchField;
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.textAlignment = NSTextAlignmentRight;
    searchField.placeholder = @"搜索订单号";
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.delegate = self;
    [self.view addSubview:searchField];
    
    //rightView
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 35)];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 1, 25)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha=.5f;
    [rightView addSubview:line];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 2.5, 40, 30)];
//    searchBtn.backgroundColor = [UIColor redColor];
    [searchBtn setImage:[UIImage imageNamed:@"fangdajing"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:searchBtn];
    
    searchField.rightView = rightView;
    searchField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)createShopTypeBtns {
    
    NSArray *titles = @[@"自有商品", @"代销商品"];
    CGFloat btnW = self.view.bounds.size.width/4;
    CGFloat btnH = 35.f;
    CGFloat btnY = CGRectGetMaxY(self.searchField.frame)+ 20;
    
    for (int i = 0; i < titles.count; i++) {
        CGFloat btnX = btnW/2 + i*(btnW+btnW);
        UIButton *shopBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW+10, btnH)];
        [shopBtn setTitle:titles[i] forState:UIControlStateNormal];
        [shopBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        shopBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        shopBtn.layer.cornerRadius = 5;
        shopBtn.tag =10+i;
        shopBtn.backgroundColor = [UIColor lightGrayColor];
        if (i==0) {
            self.selectBtn = shopBtn;
            shopBtn.backgroundColor = [UIColor redColor];
        }
        
        [self.view addSubview:shopBtn];
    }
}

- (void)createGroupItems {
    ShopStateView *stateVeiw = [[ShopStateView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchField.frame), self.view.bounds.size.width, 36)];
    stateVeiw.titles = @[@"全部",@"待付款",@"待发货",@"待收货",@"已完成"];
    stateVeiw.delegate = self;
    self.stateView = stateVeiw;
    [self.view addSubview:stateVeiw];
    
}


- (void)createPageVC{
    self.paeVc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.paeVc.dataSource = self;
    self.paeVc.delegate = self;
    self.paeVc.view.frame =CGRectMake(0, CGRectGetMaxY(self.stateView.frame), Width,Height- CGRectGetMaxY(self.stateView.frame));
    GSCustomAllOrderViewController *allOrderVC = [[GSCustomAllOrderViewController alloc] init];
    allOrderVC.orderType = GSOrderTypeCustomer;
    GSCustomPaymentViewController *paymentVC = [[GSCustomPaymentViewController alloc] init];
    paymentVC.orderType = GSOrderTypeCustomer;
    GSCustomGoodsViewController *goodsVC = [[GSCustomGoodsViewController alloc] init];
    goodsVC.orderType = GSOrderTypeCustomer;
    GSCustomReceiveGoodsViewController *receiveVC= [[GSCustomReceiveGoodsViewController alloc] init];
    receiveVC.orderType = GSOrderTypeCustomer;
    GSAchieveViewController *achieveVC = [[GSAchieveViewController alloc] init];
    achieveVC.orderType = GSOrderTypeCustomer;
    
    self.subsArray = @[allOrderVC,paymentVC,goodsVC,receiveVC,achieveVC];
    
    [self addChildViewController:self.paeVc];
    [self.view addSubview:self.paeVc.view];

    
    [self.paeVc didMoveToParentViewController:self];
    [self.paeVc setViewControllers:@[allOrderVC] direction:UIPageViewControllerNavigationDirectionForward  animated:NO completion:NULL];
    self.view.gestureRecognizers = self.paeVc.gestureRecognizers;
    self.stateView.selectIndex = self.informNum;
     [self didSelectedItem:self.informNum];
}
#pragma mark - 按钮时间事件

//自有商品／代销商品
- (void)btnAction: (UIButton*)sender{
    
    if (![sender isEqual:self.selectBtn]) {
        sender.backgroundColor = [UIColor redColor];
        self.selectBtn.backgroundColor = [UIColor lightGrayColor];
        self.selectBtn = sender;
        
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"selectBtn" object:nil userInfo:@{@"selectTag":[NSString stringWithFormat:@"%ld",sender.tag-10]}];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }
   
    
}
//搜索
- (void)searchAction:(UIButton *)searchBtn {
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"textFiled" object:nil userInfo:@{@"order_number":[NSString stringWithFormat:@"%@",self.searchField.text]}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
//返回按钮
- (void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - --------ShoStateViewDelegate-------------

- (void)didSelectedItem:(int)index{
    
    [self.paeVc setViewControllers:@[self.subsArray [index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
  }

#pragma mark - ----------UITextFieldDelegate------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"textFiled" object:nil userInfo:@{@"order_number":[NSString stringWithFormat:@"%@",self.searchField.text]}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    return YES;

    return YES;
}

#pragma mark    =======pageViewOCntrolerDelegate/datasource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController

      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    
    
    NSUInteger index = [self.subsArray indexOfObject:viewController];
    
    if (index == 0) {  // 注意点如果子控制器为0，则返回空
        
        return nil;
        
    }
    return self.subsArray[index - 1];  // 此处index必须减一
    
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController

       viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.subsArray indexOfObject:viewController];
    
    if (index >= self.subsArray.count - 1) {
        
        return nil;
        
    }
    
    return self.subsArray[index + 1];
    
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers

{
    
    UIViewController* controller = [pendingViewControllers firstObject];
    
        self.nextIndex = [self.subsArray indexOfObject:controller];
    
}



- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed

{
    
    if (completed) {
        
        [self.stateView setSelectIndex:self.nextIndex];
        
    }
    
}


@end
