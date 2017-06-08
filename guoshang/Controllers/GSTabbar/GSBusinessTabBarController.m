//
//  GSBusinessTabBarController.m
//  guoshang
//
//  Created by Rechied on 16/7/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSBusinessTabBarController.h"

@interface GSBusinessTabBarController ()

@end

@implementation GSBusinessTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setObject:UserTypeBusiness forKey:UserTypeString];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.tabBar.backgroundColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
    //self.tabBar.backgroundImage = [UIImage imageNamed:@"dise"];
    // Do any additional setup after loading the view.
    NSArray *classArray = @[@"GSBusinessHomeViewController",@"GSBusinessClassifyViewController",@"GSBusinessCarViewController",@"GSBusinessMineViewController"];
    NSArray * titleArray = @[@"首页",@"分类",@"进货单",@"卖家中心"];
    
    NSArray * imageArray = @[@"NB首页",@"N分类",@"NB购物车",@"N卖家中心"];
    NSArray * selectArray = @[@"HB首页",@"H分类",@"HB购物车",@"H卖家中心"];
    
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
        nav. navigationBar.barTintColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0];
        
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
