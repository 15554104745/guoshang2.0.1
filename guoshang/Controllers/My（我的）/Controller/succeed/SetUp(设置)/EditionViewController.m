//
//  EditionViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "EditionViewController.h"

@interface EditionViewController ()

@end

@implementation EditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0  blue:arc4random()%256/255.0  alpha:1.0];
    self.title = @"版本说明";
    
    //1.创建webview
    UIWebView *myWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    //根据屏幕大小自动调整页面尺寸
    myWebView.scalesPageToFit = YES;
    
    [self.view addSubview:myWebView];
    //2.设置请求URL
    NSString * url = URLDependByBaseURL(@"?m=Api&c=Share&a=index1");
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
