//
//  GoodsViewController.m
//  guoshang
//
//  Created by 张涛 on 16/3/17.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsViewController.h"

@interface GoodsViewController ()

@end

@implementation GoodsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品列表";
    
    //返回按钮
    UIBarButtonItem * backItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"fanhui"] highlightedImage:nil target:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem * menuItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@""] highlightedImage:nil target:self action:@selector(toMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = menuItem;
    
    self.tableView.frame = CGRectMake(0, 30, Width, Height-94);
    self.collectionView.frame = CGRectMake(0, 30, Width, Height-94);
    
    self.url = URLDependByBaseURL(@"?m=Api&c=Category&a=category");
    
    self.cat_id = _ID;
    self.classTitle = _name;
    
    [self allDataInit];
}

-(void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
//    self.navigationController pop
}

-(void)toMenu{
    
    
    
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
