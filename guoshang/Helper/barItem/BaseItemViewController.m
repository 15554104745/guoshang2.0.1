//
//  BaseItemViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/20.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import "BaseItemViewController.h"
#import "UIBarButtonItem+GSBarButtonItem.h"
#import "PopViewController.h"
#import "NewsViewController.h"
#import "SearchViewController.h"
// 主屏幕大小
#define SCMainScreenBounds [UIScreen mainScreen].bounds
@interface BaseItemViewController ()
{
    PopViewController * _vc;
    UIPopoverPresentationController * _pop;
    UIButton * _searchBtn;
}
@end

@implementation BaseItemViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    //    _searchBar.hidden = NO;
    //    _searchBar.text = nil;
    _searchBtn.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    [self createNaBarItem];
    
}
-(void)createNaBarItem{
//    self.searchBar = [[UITextField alloc] initWithFrame:CGRectMake((SCMainScreenBounds.size.width -(SCMainScreenBounds.size.width - 110)) * 0.5, 7, SCMainScreenBounds.size.width - 110, 30)];
//    _searchBar.placeholder = @"搜索商品";
//    _searchBar.delegate = self;
//    [self.navigationController.navigationBar addSubview:_searchBar];
    
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.backgroundColor = [UIColor grayColor];
    _searchBtn.frame = CGRectMake((SCMainScreenBounds.size.width -(SCMainScreenBounds.size.width - 110)) * 0.5, 7, SCMainScreenBounds.size.width - 110, 30);
    [_searchBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_searchBtn];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"分类"] highlightedImage:nil target:self action:@selector(toClassity:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem
    = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"设置"]
                                       highlightedImage:nil
                                                 target:self
                                                 action:@selector(toNews:)
                                       forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark 跳转到搜索页面
-(void)toSearch{
    SearchViewController * search = [[SearchViewController alloc] init];
   search.hidesBottomBarWhenPushed = YES;
    _searchBtn.hidden = YES;
    [self.navigationController pushViewController:search animated:YES];
//    [self.navigationController showViewController:search sender:nil];
}

////键盘收回
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//    [textField resignFirstResponder];
//    return YES;
//}
////结束响应时进行数据请求
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    
//    NSLog(@"进行数据请求");
//}
-(void)toClassity:(UIButton *)button{
    
    self.tabBarController.selectedIndex = 0;
    
}
-(void)toNews:(UIButton *)button{
    
    
     _vc= [[PopViewController alloc] init];
    _vc.delegate = self;
    
    _vc.preferredContentSize = CGSizeMake(100, 100);
    _vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _vc.modalPresentationStyle = UIModalPresentationPopover;
    
    self.pop = _vc.popoverPresentationController;

    self.pop.delegate = self;
    
    self.pop.barButtonItem = self.navigationItem.rightBarButtonItem;
    
    [self presentViewController:_vc animated:YES completion:nil];
 
    
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}


-(void)tabbarControllerSelectIndex:(NSInteger)number{
    if (number == 3) {
        NewsViewController * news = [[NewsViewController alloc] init];
        news.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:news animated:YES];
    

        

        
        
        
        
        
    }else{
        
        self.tabBarController.selectedIndex = number;
    }
    
    
}
-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
    
    [self.pop dismissalTransitionDidEnd:YES];
    self.pop = nil;

    
    
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
