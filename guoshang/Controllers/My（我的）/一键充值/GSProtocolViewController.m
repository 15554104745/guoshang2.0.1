//
//  GSProtocolViewController.m
//  guoshang
//
//  Created by 时礼法 on 16/8/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSProtocolViewController.h"

@interface GSProtocolViewController ()<UIWebViewDelegate>

@end

@implementation GSProtocolViewController
{
    UIWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatWebView];
}

-(void)creatWebView
{
    self.title = @"充值卡购买协议";
    self.view.backgroundColor = MyColor;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLDependByBaseURL(@"/Api/Share/agreement")]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
