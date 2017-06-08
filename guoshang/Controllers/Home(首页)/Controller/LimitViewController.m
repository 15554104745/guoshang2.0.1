//
//  LimitViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/30.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "LimitViewController.h"
#import "LimitingViewController.h"
#import "StartViewController.h"
#import "LimitSelectView.h"
@interface LimitViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property(nonatomic)LimitSelectView * selectView;
@property(nonatomic)UIViewController * willVc;
@property (nonatomic) UIPageViewController * pvc;

@property (nonatomic) NSMutableArray * subVCArray;
@end

@implementation LimitViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor;
    self.title = @"限时抢购";
    
    [self createPageView];
    
}
-(void) createPageView{
    _subVCArray = [NSMutableArray array];
    LimitingViewController * limiting =[[LimitingViewController alloc] init];
    limiting.popView = self;
    [_subVCArray addObject:limiting];
    StartViewController * start = [[StartViewController alloc] init];
    start.popView = self;
    [_subVCArray addObject:start];
    UIView * subView =[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    subView.backgroundColor =MyColor;
    [self.view addSubview:subView];
    
    _selectView = [[LimitSelectView alloc] initWithFrame:CGRectMake(0, 0, Width, 40)];
    _selectView.selectPlage = 0;
     [subView addSubview:_selectView];

     _pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
       _pvc.view.frame = CGRectMake(0, 52.5, Width, Height- 52.5);
     [self.view addSubview:_pvc.view];
    _pvc.dataSource = self;
    _pvc.delegate = self;
    [_pvc setViewControllers:@[_subVCArray[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        
    }];
    
    
    //实现block
    // 弱引用变量防止循环引用
    __weak typeof(self) weakSelf = self;
    [_selectView setCallbackBlock:^(NSInteger index) {
        [weakSelf.pvc setViewControllers:@[weakSelf.subVCArray [index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }];
    
    
}

//向下翻页
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    

    for (NSInteger i = 0; i < 2; i++) {
        UIViewController * vc = _subVCArray[i];
        //循环判断是那一页
        if (vc == viewController) {
            if (i< 1) {
                return _subVCArray[i + 1];
            }
        }
    }
    return nil;
}


//向上翻页
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    for (NSInteger i = 0; i < 2; i++) {
        UIViewController * vc = _subVCArray[i];
        if (vc == viewController) {
            if (i > 0) {
                return _subVCArray[i - 1];
            }
        }
    }
    
    return nil;
    
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
    _willVc = pendingViewControllers[0];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        for (NSInteger i = 0; i < 2; i++) {
            UIViewController * vc = _subVCArray[i];
            if (vc == _willVc) {
                [_selectView selectBtn:i];
            }
        }
    }
    
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
