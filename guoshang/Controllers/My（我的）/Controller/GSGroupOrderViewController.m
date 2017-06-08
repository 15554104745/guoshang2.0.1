//
//  GSGroupOrderViewController.m
//  guoshang
//
//  Created by 金联科技 on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGroupOrderViewController.h"
#import "ShopStateView.h"
#import "GSGroupAllOrderController.h"
#import "GSMakeGroupViewController.h"
#import "GSAlreadyGroupViewController.h"
@interface GSGroupOrderViewController ()<ShopStateViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic,strong) UIView *customNavigitonBar;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) ShopStateView *stateVeiw;
@property (nonatomic,strong) UIPageViewController *paeVc;
@property (nonatomic,strong) NSArray *subsArray;
@property (nonatomic,assign)NSInteger nextIndex;

@end

@implementation GSGroupOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.customNavigitonBar];
    [self createGroupItems];
    [self createPageVC];
    
}


//    navigation
-(UIView *)customNavigitonBar{
    if (!_customNavigitonBar) {
        _customNavigitonBar = [[UIView alloc] init];
        _customNavigitonBar.frame = CGRectMake(0, 0, Width, 64);
        _customNavigitonBar.backgroundColor =NewRedColor;
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 20, 48, 48);
        
        [backBtn setImage:[UIImage imageNamed:@"back_jt"] forState:UIControlStateNormal];
        
        [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
        [_customNavigitonBar addSubview:backBtn];
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        CGFloat titleX =CGRectGetMaxX(backBtn.frame);
        CGFloat titleY= 20;
        CGFloat titleW= Width-backBtn.frame.size.width*2;
        CGFloat titleH = 44;
        titleLabel.frame = CGRectMake(titleX, titleY,titleW,titleH);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"我的团购";
        [_customNavigitonBar addSubview:titleLabel];
    }
    return _customNavigitonBar;
}

- (void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSArray *)subsArray{
    if (!_subsArray) {
        
        GSGroupAllOrderController *allOrderVC= [[GSGroupAllOrderController alloc] init];
        GSMakeGroupViewController *makeGroupVC = [[GSMakeGroupViewController alloc] init];
        
        GSAlreadyGroupViewController *alreadyGroupVC = [[GSAlreadyGroupViewController alloc] init];
        ;
        _subsArray = @[allOrderVC,makeGroupVC,alreadyGroupVC];
        
        
    }
    return _subsArray;
}

- (void)createGroupItems {
    CGFloat navBarMaxY = CGRectGetMaxY(self.customNavigitonBar.frame);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,navBarMaxY, self.view.frame.size.width, 39)];
    [self.view addSubview:headerView];
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 35, Width, 1)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    lineV.alpha = .5;
    [headerView addSubview:lineV];
    
    ShopStateView *stateVeiw = [[ShopStateView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width/2+50,36)];
    stateVeiw.delegate = self;
    stateVeiw.titles = @[@"全部",@"组团中",@"已成团"];
    stateVeiw.lineHidden = YES;

    self.stateVeiw = stateVeiw;
    [headerView addSubview:stateVeiw];
    self.headerView = headerView;
}

- (void)createPageVC{
    
    self.paeVc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    CGFloat statesMaxY = CGRectGetMaxY(self.headerView.frame);
    self.paeVc.view.frame = CGRectMake(0,statesMaxY, self.view.frame.size.width, self.view.frame.size.height-statesMaxY);
    self.paeVc.dataSource = self;
    self.paeVc.delegate = self;
    [self.paeVc setViewControllers:@[self.subsArray[0]] direction:UIPageViewControllerNavigationDirectionForward  animated:NO completion:NULL];
    self.view.gestureRecognizers = self.paeVc.gestureRecognizers;
    
    [self addChildViewController:self.paeVc];
    [self.view addSubview:self.paeVc.view];
    [self.paeVc didMoveToParentViewController:self];
    
}

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
        
        
        
        self.stateVeiw.selectIndex = self.nextIndex;
        
    }
    
}


//点击
- (void)didSelectedItem:(int)index{
    
    [self.paeVc setViewControllers:@[self.subsArray [index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
  
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
@end
