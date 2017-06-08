//
//  MyOrderViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyOrderViewController.h"
#import "AllOrderViewController.h"
#import "PayMoneyViewController.h"
#import "DispatchGoodsViewController.h"
#import "ConfirmViewController.h"
#import "AccomplishViewController.h"
#import "OrderSelectView.h"
#import "MyCenterViewController.h"
#import "ShopStateView.h"
@interface MyOrderViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,ShopStateViewDelegate>
{
//    OrderSelectView * _selectView;
    ShopStateView * _selectView;
    UIViewController * _willVC;
}
@property (strong, nonatomic) UIPageViewController * pvc;

@property (strong, nonatomic) NSMutableArray * subVCArray;

@end

@implementation MyOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
   
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _subVCArray = [NSMutableArray array];
    AllOrderViewController * all = [[AllOrderViewController alloc] init];
    all.delegate = self;
    [_subVCArray addObject:all];
    PayMoneyViewController * pay = [[PayMoneyViewController alloc] init];
    pay.delegate = self;
    [_subVCArray addObject:pay];
    
    DispatchGoodsViewController * goods = [[DispatchGoodsViewController alloc] init];
    goods.delegate = self;
    [_subVCArray addObject:goods];
    
    ConfirmViewController * confirm =  [[ConfirmViewController alloc] init];
    confirm.delegate = self;
    [_subVCArray addObject:confirm];
    
    AccomplishViewController * accomplish = [[AccomplishViewController alloc]init];
    accomplish.delegate = self;
    [_subVCArray addObject:accomplish];
    
//    UIView * subView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.view addSubview:subView];
    [self createGroupItems];
    
#pragma mark   ---上次的selectView
//    _selectView = [[OrderSelectView alloc] initWithFrame:CGRectMake(0, 0, Width, 40)];
//         _selectView.isOrder = YES;
//    [subView addSubview:_selectView];
  
    _pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pvc.view.frame = CGRectMake(0, 36, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 36);
    [self.view addSubview:_pvc.view];
    
    _pvc.dataSource = self;
    
    _pvc.delegate = self;
    
    
    
    [_pvc setViewControllers:@[_subVCArray[self.informNum]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
        
    }];
        _selectView.selectIndex = self.informNum;
   
#pragma mark   ---上次的selectView
    //实现block
    // 弱引用变量防止循环引用
//    __weak typeof(self) weakSelf = self;
//    [_selectView setCallbackBlock:^(NSInteger index) {
//        [weakSelf.pvc setViewControllers:@[weakSelf.subVCArray [index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
//    }];
//    
    [self createItem];
    
}
/**
 
// 全部／待付款／待发货／待收货／已完成
// **/
- (void)createGroupItems {
    ShopStateView *stateView = [[ShopStateView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width,36)];
    stateView.titles = @[@"全部",@"待付款",@"待发货",@"待确认",@"已完成"];
    stateView.delegate = self;
    stateView.backgroundColor = [UIColor whiteColor];
    _selectView = stateView;
    [self.view addSubview:stateView];
}



-(void) createItem{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"fanhui"] highlightedImage:nil target:self action:@selector(toback) forControlEvents:UIControlEventTouchUpInside];
  
    
}
-(void)toback{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MyCenterViewController class]]) {
          
            [self.navigationController popToViewController:controller animated:YES];
            
        }else{

            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }

}
//向下翻页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    for (NSInteger i = 0; i < 5; i++) {
        
        
        UIViewController * vc = _subVCArray[i];
        
        if (vc == viewController) {
            
            if (i < 4) {
                
                return _subVCArray[i + 1];
                
            }
            
        }
        
    }
    
    return nil;
}

//向上翻页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    for (NSInteger i = 0; i < 5; i++) {
        UIViewController * vc = _subVCArray[i];
        if (vc == viewController) {
            if (i > 0) {
                return _subVCArray[i - 1];
            }
        }
    }
    return nil;
}


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    _willVC = pendingViewControllers[0];
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        for (NSInteger i = 0; i < 5; i++) {
            UIViewController * vc = _subVCArray[i];
            if (vc == _willVC) {
                [_selectView setSelectIndex:[self.subVCArray indexOfObject:_willVC ]];
//                [_selectView selectBtn:i];
            }
        }
    }
}



#pragma mark - ShoStateViewDelegate
- (void)didSelectedItem:(int)index{
    
    [self.pvc setViewControllers:@[self.subVCArray [index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

#pragma mark 付款页面的代理方法

-(void)pushTo:(UIViewController *)view{
    
[self.navigationController pushViewController:view animated:YES];
    
}



-(void)allPushToView:(UIViewController *)view{
    
    [self.navigationController pushViewController:view animated:YES];
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
