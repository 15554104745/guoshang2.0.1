//
//  GoodsInfoSecondViewController.m
//  guoshang
//
//  Created by JinLian on 16/7/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsInfoSecondViewController.h"
//#import "LoginViewController.h"
#import "GSNewLoginViewController.h"
#import "MoneyViewController.h"
#import "GBOrderViewController.h"
#import "GoodsShowViewController.h"


@interface GoodsInfoSecondViewController ()<UIScrollViewDelegate>
{
    UILabel * _bottomLabel;
    UILabel * _bottomLabel1;
    UILabel * _bottomLabel2;
    
    UIButton * detailButton;
    UIButton * parameterButton;
    UIButton * recommendButton;
    UILabel * badgeLabel;
    
    UIView * _detailView;
    UIView * _parameterView;
    UIScrollView * _recommendView;
    BOOL isDetail;
    BOOL isParameter;
    BOOL isRecommend;
}
@end

@implementation GoodsInfoSecondViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor;
    //    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    isParameter = NO;
    isRecommend = NO;
    isDetail = YES;
    [self createUI];
    [self createDetailView];
}

-(void)createUI{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-40)];
    _scrollView.contentSize = CGSizeMake(Width, 630);
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = MyColor;
    [self.view addSubview:_scrollView];
    
    detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.frame = CGRectMake(0, 20, Width, 40);
    detailButton.tag = 10;
    detailButton.selected = YES;
    detailButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [detailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [detailButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [detailButton setTitle:@"图文详情" forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:detailButton];
    
}
-(void)createDetailView{
    
    _detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, Width, Height-105)];
//    _detailView.contentSize = CGSizeMake(Width, 630);
//    _detailView.delegate = self;
//    _detailView.showsVerticalScrollIndicator = NO;
    _detailView.backgroundColor = MyColor;
    [_scrollView addSubview:_detailView];
    
    //1.创建webview
    UIWebView *myWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    //根据屏幕大小自动调整页面尺寸
    myWebView.scalesPageToFit = YES;
    
    [_detailView addSubview:myWebView];
    //2.设置请求URL
    NSString * url = _goods_desc;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //加载页面
    [myWebView loadRequest:request];
    
}

-(void)createParameterView{
    _parameterView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, Width, Height-105)];
//    _parameterView.contentSize = CGSizeMake(Width, 630);
//    _parameterView.delegate = self;
//    _parameterView.showsVerticalScrollIndicator = NO;
    _parameterView.backgroundColor = MyColor;
    [_scrollView addSubview:_parameterView];
    
    //1.创建webview
    UIWebView *myWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    //根据屏幕大小自动调整页面尺寸
    myWebView.scalesPageToFit = YES;
    
    [_parameterView addSubview:myWebView];
    //2.设置请求URL
    NSString * url = _goods_attr_desc;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //加载页面
    [myWebView loadRequest:request];
    
}

-(void)createRecommendView{
    _recommendView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, Width, Height-105)];
    _recommendView.contentSize = CGSizeMake(Width, 630);
    _recommendView.delegate = self;
    _recommendView.showsVerticalScrollIndicator = NO;
    _recommendView.backgroundColor = MyColor;
    [_scrollView addSubview:_recommendView];
    
    for (int i=0; i<6; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =16+i;
        [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_recommendArray[i] goods_img]]]];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_recommendView addSubview:button];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.text = [_recommendArray[i] name];
        titleLabel.font = [UIFont systemFontOfSize:11];
        [_recommendView addSubview:titleLabel];
        
        UILabel * priceLabel = [[UILabel alloc]init];
        priceLabel.textColor = [UIColor redColor];
        priceLabel.text = [_recommendArray[i] shop_price];
        priceLabel.font = [UIFont systemFontOfSize:14];
        [_recommendView addSubview:priceLabel];
        
        NSInteger itemWidth = Width /2;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_recommendView.mas_top).with.offset(i/2*200+10);
            make.left.mas_equalTo(_recommendView.mas_left).with.offset((i%2)*itemWidth+10);
            make.width.mas_equalTo(itemWidth-20);
            make.height.mas_equalTo(130);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(button.mas_bottom);
            make.left.mas_equalTo(button.mas_left);
            make.width.mas_equalTo(itemWidth-20);
            make.height.mas_equalTo(30);
        }];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom);
            make.left.mas_equalTo(button.mas_left).with.offset(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
    };
}

//button点击触发事件
-(void)buttonClick:(UIButton *)button{

    
    GoodsShowViewController * gsvc = [[GoodsShowViewController alloc]init];
    switch (button.tag) {
        case 10:
            button.selected = YES;
            recommendButton.selected = NO;
            parameterButton.selected = NO;
            [_bottomLabel1 removeFromSuperview];
            [_bottomLabel2 removeFromSuperview];
            [self.view addSubview:_bottomLabel];
            
            if (isDetail == NO) {
                isDetail = YES;
                [self createDetailView];
            }
            [_parameterView removeFromSuperview];
            [_recommendView removeFromSuperview];
            isParameter = NO;
            isRecommend = NO;
//            NSLog(@"1");
            break;
        case 11:
            
            button.selected = YES;
            recommendButton.selected = NO;
            detailButton.selected = NO;
            [self.view addSubview:_bottomLabel1];
            [_bottomLabel removeFromSuperview];
            [_bottomLabel2 removeFromSuperview];
            
            if (isParameter == NO) {
                isParameter = YES;
                [self createParameterView];
            }
            [_detailView removeFromSuperview];
            [_recommendView removeFromSuperview];
            isDetail = NO;
            isRecommend = NO;
//            NSLog(@"2");
            break;
        case 12:
            
            button.selected = YES;
            detailButton.selected = NO;
            parameterButton.selected = NO;
            [_bottomLabel removeFromSuperview];
            [_bottomLabel1 removeFromSuperview];
            [self.view addSubview:_bottomLabel2];
            if (isRecommend == NO) {
                isRecommend = YES;
                [self createRecommendView];
            }
            [_parameterView removeFromSuperview];
            [_detailView removeFromSuperview];
            isDetail = NO;
            isParameter = NO;
//            NSLog(@"3");
            break;
            
        case 16:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[_tempArray[button.tag-16] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
            
            break;
        case 17:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[_tempArray[button.tag-16] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
            
            break;
        case 18:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[_tempArray[button.tag-16] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
            
            break;
        case 19:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[_tempArray[button.tag-16] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
            
            break;
        case 20:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[_tempArray[button.tag-16] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
            
            break;
        case 21:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[_tempArray[button.tag-16] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
//            NSLog(@"产品6");
            break;
            
        default:
            break;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.contentOffset.y);
    //
    if (scrollView == _scrollView && scrollView.contentOffset.y>0) {
        scrollView.scrollEnabled = NO;
        
    }else if(scrollView.contentOffset.y <= 0){
        _scrollView.scrollEnabled = YES;
    }
    //
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
