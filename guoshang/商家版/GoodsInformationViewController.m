//
//  GoodsInformationViewController.m
//  guoshang
//
//  Created by JinLian on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsInformationViewController.h"
#import "SendGoodsInformantionView.h"

@interface GoodsInformationViewController () {
    
    UIScrollView *_scrollerView;
    NSInteger _scrollerViewHeight;
}

@property (nonatomic, strong)SendGoodsInformantionView *goodsView;

@end

@implementation GoodsInformationViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    _scrollerViewHeight = 2*Height;

    [self creteUI];
    [self creatButton];
}

- (SendGoodsInformantionView *)goodsView {
    
    if (!_goodsView) {
        
        _goodsView = [[SendGoodsInformantionView alloc]init];
        _goodsView.backgroundColor = MyColor;
    }
    return _goodsView;
}

#pragma mark - 界面button按钮
- (void)creatButton {
    
    //头部返回按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 20, 30, 30);
    [leftButton setImage:[UIImage imageNamed:@"tubiao1"] forState:UIControlStateNormal];
    leftButton.tag = 901;
    [leftButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    //购物车按钮
    UIButton *goodsCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goodsCartButton.frame = CGRectMake(Width-80, 20, 30, 30);
    [goodsCartButton setImage:[UIImage imageNamed:@"gouwuche1-1"] forState:UIControlStateNormal];
    goodsCartButton.tag = 902;
    [goodsCartButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goodsCartButton];

    //顶部详情按钮
    UIButton *informantionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    informantionButton.frame = CGRectMake(Width-40, 20, 30, 30);
    [informantionButton setImage:[UIImage imageNamed:@"tubiao2"] forState:UIControlStateNormal];
    informantionButton.tag = 903;
    [informantionButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:informantionButton];

    //收藏
    UIButton * collectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, Height-50, Width/3, 50)];
    [collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang1"] forState:UIControlStateSelected];
    collectButton.tag = 904;
//    if ([_dataArray[0] iscollect]) {
//        collectButton.selected = YES;
//    }else{
//        collectButton.selected = NO;
//    }
    [collectButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectButton];
    
    //加入购物车
    UIButton * addToButton = [[UIButton alloc]initWithFrame:CGRectMake(Width/3, Height-50, Width/3, 50)];
    [addToButton setBackgroundImage:[UIImage imageNamed:@"addToCar"] forState:UIControlStateNormal];
    addToButton.tag = 905;
    [addToButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addToButton];
    
    //立即购买
    UIButton * buyButton = [[UIButton alloc]initWithFrame:CGRectMake(Width/3*2, Height-50, Width/3, 50)];
    [buyButton setBackgroundImage:[UIImage imageNamed:@"buy"] forState:UIControlStateNormal];
    buyButton.tag = 906;
    [buyButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
}

#pragma mark - 界面控件
- (void)creteUI {
    
    _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, Width, Height)];
    _scrollerView.contentSize = CGSizeMake(Width, _scrollerViewHeight);
    _scrollerView.backgroundColor = MyColor;
    [self.view addSubview:_scrollerView];
    
    //大图
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, Width)];
    imageView.backgroundColor = [UIColor orangeColor];
    [_scrollerView addSubview:imageView];
    

    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Width, Width, 170)];
    contentView.backgroundColor = MyColor;
    [_scrollerView addSubview:contentView];
    //商品标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Width-20, 40)];
    titleLabel.text = @"2015冬装新款大码女装秋冬季新品修身中长款连帽加厚棉衣棉袄外套afml";
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:titleLabel];
    
    //商品描述
    UILabel * desLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, Width-20, 30)];
    desLabel.text =@"2015冬装新款大码女装秋冬季新品修身中长款连帽加厚棉衣棉袄外套afml";
    desLabel.numberOfLines = 0;
    desLabel.textColor = [UIColor grayColor];
    desLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:desLabel];
    
    //现价
    UILabel * newPrice = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, Width-20, 40)];
    newPrice.text =@"￥99.00";
    newPrice.numberOfLines = 0;
    newPrice.textColor = [UIColor redColor];
    newPrice.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:newPrice];
    
    //原价
    UILabel * ppLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 100, 30)];
    ppLabel.font = [UIFont boldSystemFontOfSize:12];
    ppLabel.textColor = [UIColor grayColor];
    [contentView addSubview:ppLabel];
    NSString *str = @"原价：188.00";
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSUInteger length = [str length];
    [attriStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(3, length-3)];
    [attriStr addAttribute:NSStrikethroughColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, length-3)];
    [ppLabel setAttributedText:attriStr];
    
    UILabel *sellLab = [[UILabel alloc]init];
    sellLab.text = @"已售：12.34万";
    sellLab.font = [UIFont systemFontOfSize:12];
    sellLab.textAlignment = NSTextAlignmentRight;
    [contentView addSubview:sellLab];
    [sellLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.height.equalTo(@30);
        make.bottom.equalTo(ppLabel.mas_bottom);
        make.width.equalTo(@100);
    }];
    
    //选择尺码，颜色
    UIButton *selectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 140, Width, 30)];
    selectButton.backgroundColor = [UIColor colorWithRed:253/255.0f green:225/255.0f blue:178/255.0f alpha:1];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [selectButton setTitle:@"请选择尺码、颜色分类" forState:UIControlStateNormal];
    [selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -Width/2, 0, 0)];
    [selectButton setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
    [selectButton setImageEdgeInsets:UIEdgeInsetsMake(0, Width/2+140, 0, 0)];
    [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectButton.tag = 907;
    [selectButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:selectButton];

    //位置、运费、服务界面
//    self.goodsView = [[SendGoodsInformantionView alloc]init];
//    self.goodsView.backgroundColor = [UIColor redColor];
    [_scrollerView addSubview:self.goodsView];
    self.goodsView.frame = CGRectMake(0, Width + 170, Width, 90);

    
    
}

-(void)clickButtonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:{ //购物车
        }
            break;
        case 3:{ //右侧详情
            }
            break;
        case 4:{ //收藏
        }
            break;
        case 5:{ //加入购物车
        }
            break;
        case 6:{ //立即购买
        }
            break;
        case 7:{ //尺码选择，颜色
        }
            break;

        default:
            break;
    }
}

#pragma mark - 系统自带方法
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}


@end
