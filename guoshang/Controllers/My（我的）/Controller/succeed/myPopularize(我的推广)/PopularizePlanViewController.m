//
//  PopularizePlanViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/6/14.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "PopularizePlanViewController.h"

@interface PopularizePlanViewController ()

@end

@implementation PopularizePlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor;
    self.title = @"我的推广";
    //1.创建webview
    UIWebView *myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64-49)];
    //根据屏幕大小自动调整页面尺寸
    myWebView.scalesPageToFit = YES;
    
    [self.view addSubview:myWebView];
    //2.设置请求URL                         
    NSString * url = TuiGuangDependByBaseURL(@"?m=default&c=user&a=mobile_my_promotion");
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //加载页面
    [myWebView loadRequest:request];
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
