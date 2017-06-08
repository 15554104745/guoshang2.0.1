//
//  GSActivirtyWebViewController.m
//  guoshang
//
//  Created by Rechied on 2016/11/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSActivityWebViewController.h"
#import "GSActivityManager.h"

@interface GSActivityWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GSActivityWebViewController

- (instancetype)init {
    self = ViewController_in_Storyboard(@"Main", @"GSActivityWebViewController");
    self.hidesBottomBarWhenPushed = YES;
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, Width, 60)];
    label.textColor = [UIColor colorWithHexString:@"c5c5c5"];
    label.text = @"本页面由国商易购\n提供技术支持";
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [self.view bringSubviewToFront:self.webView];
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.absoluteString containsString:@"m=default&c=goods&a=index&id="]) {
        NSString *goods_id = [[request.URL.absoluteString componentsSeparatedByString:@"m=default&c=goods&a=index&id="] lastObject];
        [self changeToGoodsDetialWithGoods_id:goods_id];
        return NO;
    }
    return YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)changeToGoodsDetialWithGoods_id:(NSString *)goods_id {
    [GSActivityManager changeToGoodsDetialWithGoods_id:goods_id navigationController:self.navigationController hudView:self.webView];
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
