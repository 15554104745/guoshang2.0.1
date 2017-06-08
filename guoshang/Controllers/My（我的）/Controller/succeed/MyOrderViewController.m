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
#import "MyGSViewController.h"
@interface MyOrderViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
{
    OrderSelectView * _selectView;
    UIViewController * _willVC;
}
@property (nonatomic) UIPageViewController * pvc;

@property (nonatomic) NSMutableArray * subVCArray;

@end

@implementation MyOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
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
    [_subVCArray addObject:goods];
    
    ConfirmViewController * confirm =  [[ConfirmViewController alloc] init];
    [_subVCArray addObject:confirm];
    
    AccomplishViewController * accomplish = [[AccomplishViewController alloc]init];
    [_subVCArray addObject:accomplish];
    
    UIView * subView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:subView];
    
    _selectView = [[OrderSelectView alloc] initWithFrame:CGRectMake(0, 0, Width, 40)];
  
    [subView addSubview:_selectView];
  
    _pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pvc.view.frame = CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 45);
    [self.view addSubview:_pvc.view];
    
    _pvc.dataSource = self;
    
    _pvc.delegate = self;
    
    
    
    [_pvc setViewControllers:@[_subVCArray[self.informNum]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
        
    }];
   
    //实现block
    // 弱引用变量防止循环引用
    __weak typeof(self) weakSelf = self;
    [_selectView setCallbackBlock:^(NSInteger index) {
        [weakSelf.pvc setViewControllers:@[weakSelf.subVCArray [index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }];
    
    [self createItem];
    
}


-(void) createItem{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"fanhui"] highlightedImage:nil target:self action:@selector(toback) forControlEvents:UIControlEventTouchUpInside];
  
    
}
-(void)toback{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MyGSViewController class]]) {
          
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
                [_selectView selectBtn:i];
            }
        }
    }
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
