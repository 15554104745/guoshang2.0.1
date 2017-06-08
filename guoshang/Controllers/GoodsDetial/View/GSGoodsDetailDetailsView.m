//
//  GSGoodsDetailDetailsView.m
//  guoshang
//
//  Created by Rechied on 2016/11/16.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetailDetailsView.h"
#import "STTopBar.h"

@interface GSGoodsDetailDetailsView()<STTabBarDelegate>
@property (weak, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *detailRequest;
@property (strong, nonatomic) NSURLRequest *specificationsRequest;
@end

@implementation GSGoodsDetailDetailsView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    STTopBar *toolsBar = [[STTopBar alloc] initWithArray:@[@"图文详情",@"产品参数"]];
    toolsBar.delegate = self;
    [self addSubview:toolsBar];
    [toolsBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.offset(44.0f);
    }];
    
    UIWebView *webView = [[UIWebView alloc] init];
    [self addSubview:webView];
    webView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.webView = webView;
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.equalTo(toolsBar.mas_bottom);
    }];
}

- (NSURLRequest *)detailRequest {
    if (!_detailRequest) {
        _detailRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsDetailModel.goodsinfo.goods_desc]];
    }
    return _detailRequest;
}

- (NSURLRequest *)specificationsRequest {
    if (!_specificationsRequest) {
        _specificationsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsDetailModel.goodsinfo.goods_attr_desc]];
    }
    return _specificationsRequest;
}

- (void)setGoodsDetailModel:(GSGoodsDetailModel *)goodsDetailModel {
    _goodsDetailModel = goodsDetailModel;
    
    [self.webView loadRequest:self.detailRequest];
}

- (void)tabBar:(STTopBar *)tabBar didSelectIndex:(NSInteger)index {
    [self.webView loadRequest:index == 0 ? self.detailRequest : self.specificationsRequest];
}

@end
