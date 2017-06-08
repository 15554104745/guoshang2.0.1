//
//  GSOrderInfoViewController.m
//  guoshang
//
//  Created by 金联科技 on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSOrderInfoViewController.h"
#import "GSCustomAllOrderViewController.h"
#import "GSCustomPaymentViewController.h"
#import "GSCustomGoodsViewController.h"
#import "GSCustomReceiveGoodsViewController.h"
#import "GSAchieveViewController.h"
#import "ShopStateView.h"
#import "GSBusinessMineViewController.h"
#import "GSBusinessTabBarController.h"

@interface GSOrderInfoViewController ()<ShopStateViewDelegate, UITextFieldDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong) ShopStateView * stateView;
@property (nonatomic,strong) UIPageViewController *paeVc;
@property (nonatomic,strong) NSArray *subsArray;
@property (nonatomic,assign) NSInteger nextIndex;

@end

@implementation GSOrderInfoViewController

#pragma mark - 生命周期

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultSettings];
    [self createSubViews];
    
}

/**
 *  默认设置
 */
- (void)defaultSettings{
    self.view.backgroundColor = [UIColor whiteColor];
}

/**
 *  创建子视图
 */
- (void)createSubViews {
    [self createNav];
    [self createGroupItems];
    [self createPageVC];
    
    }

- (void)createNav{
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, Width, 64);
    navView.backgroundColor = GS_Business_NavBarColor;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 48, 48);
    [backBtn setImage:[UIImage imageNamed:@"back_jt"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    CGFloat titleX =CGRectGetMaxX(backBtn.frame);
    CGFloat titleY= 20;
    CGFloat titleW= Width-backBtn.frame.size.width*2;
    CGFloat titleH = 44;
    titleLabel.frame = CGRectMake(titleX, titleY,titleW,titleH);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"我的订单";
    [navView addSubview:titleLabel];
    [self.view addSubview:navView];

    
}

/**
 
 全部／待付款／待发货／待收货／已完成
 **/
- (void)createGroupItems {
    ShopStateView *stateVeiw = [[ShopStateView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44)];
    stateVeiw.titles = @[@"全部",@"待付款",@"待发货",@"待收货",@"已完成"];
    stateVeiw.delegate = self;
    self.stateView = stateVeiw;
    [self.view addSubview:stateVeiw];
    
}

//创建pagerVC

- (void)createPageVC{
    self.paeVc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.paeVc.dataSource = self;
    self.paeVc.delegate = self;
    
    GSCustomAllOrderViewController *allOrderVC = [[GSCustomAllOrderViewController alloc] init];
    allOrderVC.orderType = GSOrderTypeUser;
    GSCustomPaymentViewController *paymentVC = [[GSCustomPaymentViewController alloc] init];
    paymentVC.orderType = GSOrderTypeUser;
    GSCustomGoodsViewController *goodsVC = [[GSCustomGoodsViewController alloc] init];
    goodsVC.orderType = GSOrderTypeUser;
    GSCustomReceiveGoodsViewController *receiveVC= [[GSCustomReceiveGoodsViewController alloc] init];
    receiveVC.orderType = GSOrderTypeUser;
    GSAchieveViewController *achieveVC = [[GSAchieveViewController alloc] init];
    achieveVC.orderType = GSOrderTypeUser;
    
    self.subsArray = @[allOrderVC,paymentVC,goodsVC,receiveVC,achieveVC];
    [self addChildViewController:self.paeVc];
    [self.view addSubview:self.paeVc.view];
    self.paeVc.view.frame =CGRectMake(0, CGRectGetMaxY(self.stateView.frame)-7, Width, Height-self.stateView.frame.size.height);
    [self.paeVc didMoveToParentViewController:self];
    [self.paeVc setViewControllers:@[allOrderVC] direction:UIPageViewControllerNavigationDirectionForward  animated:NO completion:NULL];
    self.view.gestureRecognizers = self.paeVc.gestureRecognizers;
    self.stateView.selectIndex = self.informNum;
    [self didSelectedItem:self.informNum];
}



#pragma mark  --------------NavigationAction-------------
- (void)backAction{
    
    [self backActionToMine];
    
}

#pragma mark - ---------ShoStateViewDelegate-------------

- (void)didSelectedItem:(NSInteger)index{
    
    
    [self.paeVc setViewControllers:@[self.subsArray [index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

#pragma mark- -----------pageVCDelegate/datasource---------

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
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
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
    UIViewController* controller = [pendingViewControllers firstObject];
    
    self.nextIndex = [self.subsArray indexOfObject:controller];
    
}

//返回到卖家中心
-(void)backActionToMine{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[GSBusinessMineViewController class]]) {
        
            [self.navigationController popToViewController:controller animated:YES];
            
        }else {
            GSBusinessTabBarController *businessTabbar = [[GSBusinessTabBarController alloc] init];
            businessTabbar.selectedIndex = 3;
            UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:businessTabbar];
            mainNav.navigationBarHidden = YES;
           
            [UIView beginAnimations:@"trans" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[UIApplication sharedApplication].delegate window] cache:NO];
            [[UIApplication sharedApplication].delegate window].rootViewController = mainNav;
            [UIView commitAnimations];
        }
    
    }
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (completed) {
        
        [self.stateView setSelectIndex:self.nextIndex];
        
    }
    
}



@end
