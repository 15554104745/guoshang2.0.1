//
//  GSTabbarController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSTabbarController.h"
#import "HomeViewController.h"
#import "SpecialSaleViewController.h"
#import "ShoppingViewController.h"
#import "CarViewController.h"
#import "MyGSViewController.h"
#import "MyCenterViewController.h"
#import "ClassifyViewController.h"
#import "GSNewHomeViewController.h"
#import "UIColor+HaxString.h"

#import "GSNewLoginViewController.h"
@interface GSTabbarController ()<UITabBarControllerDelegate>

@end

@implementation GSTabbarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setObject:UserTypeDefault forKey:UserTypeString];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    self.tabBar.backgroundImage = [UIImage imageNamed:@"底框.png"];
    self.tabBar.backgroundColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
    [self createViewControllers];
    self.delegate = self;
    
}
-(void)createViewControllers{
    NSArray * classArray = @[@"GSNewHomeViewController",@"GSNewClassfiyViewController",@"GSNewCarViewController",@"MyGSViewController"];
    NSArray * titleArray = @[@"首页",@"分类",@"购物车",@"我的易购"];
    NSArray * imageArray = @[@"N首页",@"N分类",@"N购物车",@"N我的国商"];
    NSArray * selectArray = @[@"H首页",@"H分类",@"H购物车",@"H我的国商"];
    
    for (int i = 0; i < 4; i++) {
        //        Class cls =NSClassFromString(classArray[i]);
        //        UIViewController * vc = [[cls alloc] init];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(classArray[i]) alloc] init]];
        [self addChildViewController:nav];
        //舍弃文字
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                             forBarMetrics:UIBarMetricsDefault];
        
        
        [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
        nav.tabBarController.tabBar.translucent = NO;
        [nav.navigationItem setHidesBackButton:YES animated:YES];
        //nav. navigationBar.barTintColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0];
        nav. navigationBar.barTintColor = [UIColor colorWithHexString:@"e42144"];
        nav.title = titleArray[i];
        
        UIImage *image = [UIImage imageNamed:imageArray[i]];
        nav.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        
        
        UIImage * sImage = [UIImage imageNamed:selectArray[i]];
        nav.tabBarItem.selectedImage =[sImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.navigationBar.translucent = NO;
        nav.tabBarItem.title = nil;
        nav.tabBarItem.imageInsets = UIEdgeInsetsMake(10, 0, -10, 0);
        
        
    }
    
    
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UINavigationController *nav = (UINavigationController *)viewController;
    if (!UserId && [[nav.viewControllers firstObject] isKindOfClass:NSClassFromString(@"GSNewCarViewController")]) {
        CKAlertViewController *alert = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"您还没有登录,请先登录!"];
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"我再想想" handler:nil];
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"立即登录" backgroundColor:[UIColor colorWithHexString:@"f23030"] titleColor:[UIColor whiteColor] handler:^(CKAlertAction *action) {
            GSNewLoginViewController *loginViewController = [[GSNewLoginViewController alloc] init];
            loginViewController.changeToCar = YES;
            loginViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginViewController animated:YES];
        }];
        [alert addAction:cancel];
        [alert addAction:sure];
        [self presentViewController:alert animated:NO completion:nil];
        return NO;
    }
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
