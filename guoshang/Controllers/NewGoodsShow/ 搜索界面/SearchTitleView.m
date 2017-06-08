//
//  SearchTitleView.m
//  guoshang
//
//  Created by JinLian on 16/9/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SearchTitleView.h"
#import "UIView+UIViewController.h"

@interface SearchTitleView () {
    
    UIButton *bottomSelectBtn;
    BOOL is_selectBottomBtn;
}

@end

@implementation SearchTitleView

- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc]init];
    }
    return _params;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = MyColor;
        [self createTitleView];
        [self createTitleCenterBtn];
        [self createTitleBottomBtn];
    }
    return self;
}

#pragma mark - 导航栏
- (void)createTitleView {
    
    UIView *titleBakView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    titleBakView.backgroundColor = NewRedColor;
    [self addSubview:titleBakView];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"back_jt"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleBakView addSubview:leftBtn];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-200)/2, 20, 200, 44)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"搜索结果";
    [titleBakView addSubview:titleLab];
    
    
}

#pragma  mark - button创建
- (void)createTitleCenterBtn {
    
    NSArray *titleCenterBtnName = @[@"易购商品",@"国币商品",@"特卖商品"];
    CGFloat height = 64;
    CGFloat space = 5;
    CGFloat btnWidth = (self.frame.size.width - space * titleCenterBtnName.count+1) / titleCenterBtnName.count;
    CGFloat btnHeight = 40;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i = 0; i < titleCenterBtnName.count; i++) {
        
        x = space + (space + btnWidth) * i;
        y = height;
        
        UIButton *centerBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, btnWidth, btnHeight)];
        [centerBtn setTitle:titleCenterBtnName[i] forState:UIControlStateNormal];
        [centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [centerBtn setTitleColor:NewRedColor forState:UIControlStateSelected];
        centerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [centerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [centerBtn setImage:[UIImage imageNamed:@"resultweixuanzhong"] forState:UIControlStateNormal];
        [centerBtn setImage:[UIImage imageNamed:@"resultxuanzhong"] forState:UIControlStateSelected];
        centerBtn.tag = i;
        centerBtn.selected = YES;
        [centerBtn addTarget:self action:@selector(createTitleCenterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:centerBtn];
    }
}

- (void)createTitleBottomBtn {
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 104, Width, 1)];
    imageView.image = [UIImage imageNamed:@"xuxian"];
    [self addSubview:imageView];
    
    NSArray *titleCenterBtnName = @[@"按人气",@"按销量",@"按价格",@""];
    CGFloat height = 115;
    CGFloat btnWidth = 60;
    CGFloat space = (self.frame.size.width - btnWidth * titleCenterBtnName.count) / (titleCenterBtnName.count + 1);
    CGFloat btnHeight = 20;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i = 0; i < titleCenterBtnName.count; i++) {
        
        x = space + (space + btnWidth) * i;
        y = height;
        
        UIButton *bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, btnWidth, btnHeight)];
        [bottomBtn setTitle:titleCenterBtnName[i] forState:UIControlStateNormal];
        bottomBtn.backgroundColor = COLOR(240, 241, 255, 1);
        bottomBtn.layer.cornerRadius = 5;
        bottomBtn.clipsToBounds = YES;
        [bottomBtn setTitleColor:textColour forState:UIControlStateNormal];
        [bottomBtn setTitleColor:NewRedColor forState:UIControlStateSelected];
        bottomBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        bottomBtn.tag = i+20;
        [bottomBtn addTarget:self action:@selector(createTitleBottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomBtn];
        
        [bottomBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, -40)];
        [bottomBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [bottomBtn setImage:[UIImage imageNamed:@"daoxu"] forState:UIControlStateNormal];
        [bottomBtn setImage:[UIImage imageNamed:@"zhengxu"] forState:UIControlStateSelected];
        
}
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 144, Width, 1)];
    imageView2.image = [UIImage imageNamed:@"xuxian"];
    [self addSubview:imageView2];
}

#pragma mark - buttonAction
- (void)createTitleCenterBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
            //易购商品
        case 0:{
            
        }
            break;
            //国币商品
        case 1:{
                
            }
            break;
            //特卖商品
        case 2:{
                
            }
            break;
            
        default:
            break;
    }
    
}

- (void)createTitleBottomBtnAction:(UIButton *)sender {
    
    bottomSelectBtn.selected = NO;
    sender.selected = YES;
    bottomSelectBtn = sender;
    NSInteger index = sender.tag - 20;

    is_selectBottomBtn = !is_selectBottomBtn;
    if (is_selectBottomBtn) {
        [sender setImage:[UIImage imageNamed:@"zhengxu"] forState:UIControlStateSelected];
        [self.params setObject:@"ASC" forKey:@"order"];     //升序
    }else {
        [sender setImage:[UIImage imageNamed:@"daoxu"] forState:UIControlStateSelected];
        [self.params setObject:@"DESC" forKey:@"order"];    //降序
    }
    
    switch (index) {
            //按人气
        case 0:{
            [self.params setObject:@"click_count" forKey:@"sort"];
            }
            break;
            //按销量
        case 1:{
            [self.params setObject:@"salesnum" forKey:@"sort"];
            }
            break;
            //按价格
        case 2:{
            [self.params setObject:@"shop_price" forKey:@"sort"];
            
            }
            break;
            //列表切换
        case 3:{
                
            }
            break;
            
        default:
            break;
    }
    
    if (self.block) {
        self.block(self.params);
    }
    
}


- (void)titleBtnAction:(UIButton *)sender {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}


@end
