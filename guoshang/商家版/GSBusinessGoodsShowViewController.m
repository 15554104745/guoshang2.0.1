//
//  GoodsShowViewController.m
//  guoshang
//
//  Created by 张涛 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSBusinessGoodsShowViewController.h"
#import "DetailsViewController.h"
#import "ImagesScrollView.h"
#import "RecomendModel.h"
//#import "LoginViewController.h"
#import "GSNewLoginViewController.h"
#import "MoneyViewController.h"
#import "GBOrderViewController.h"
#import "AttributeModel.h"
#import "ClassifyViewController.h"
#import "goodsDetailView.h"
#import "UIScrollView+JYPaging.h"
#import "UIImageView+WebCache.h"
#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "GSStoreDetailViewController.h"
#import "GSStoreListModel.h"
#import "CarViewController.h"

@interface GSBusinessGoodsShowViewController ()<UIScrollViewDelegate,ImagesScrollViewDelegate>

{
    NSInteger contentHeight;
    UIView * downView;
    UIScrollView * showView;
    
    BOOL isSelected;
    BOOL end;
    BOOL is_down;
    BOOL is_setAttr; //判断是否加入购物车
    NSInteger addCart; //商品数量
    UILabel * _carveLabel1;
    UILabel * _carveLabel2;
    UIView  * _goodsList;
    UILabel * badgeLabel;
    UIButton * recommendButton;
    UIButton * hotButton;
    UIButton * selectButton;
    
    UIView * transparentView;
    
    UILabel * countLabel;
    UILabel * priceLabel1;
    NSInteger goodsCount; //购物车中的商品数
    float goodsPrice;
    NSInteger backViewHight;
    NSInteger cartCount;
    
    NSMutableString * goods_attr_desc;
    NSMutableString * goods_desc;
    NSMutableString * attr_id;  //商品属性id
    NSMutableString * type;
    NSString * rec_id;
    
    NSMutableArray * attrArray; //商品属性
    NSMutableArray * bestArray;
    NSMutableArray * hotArray;
    NSMutableArray * tempArray;
    
    NSMutableDictionary *shopDic; //存放商品对应的商家信息
    
    
    UIButton * backButton;
    UIButton * cartButton;
    UIButton * menuButton;
    
    
    
    NSString *image_name_Url;
    NSMutableDictionary *addressDic;
    NSInteger toBUY; //从立即购买进入选择商品界面
    NSInteger toCAR; //从添加到购物车进入选择商品界面
    
}
@end

//#define SHAREURL @"http://m.ibg100.com/index.php?m=default&c=goods&a=index&id="

@implementation GSBusinessGoodsShowViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    if (!UserId || [UserId isEqualToString:@""]) {
        
    }
    
    
    contentHeight = Width+600;
    
    [self dataInit];
    [self createRecat];
    
    //    _goodId = @"18050";
//    NSLog(@"%@",_goodId);
    self.view.backgroundColor = MyColor;
    isSelected = NO;
    is_down = NO;
    is_setAttr = NO;
    
    goodsCount = 1;
    cartCount  = 0;
    
    toBUY = 0; //从立即购买进入选择商品界面
    toCAR = 0; //从添加到购物车进入选择商品界面

    
    _dataArray = [[NSMutableArray alloc]init];
    _picArray = [[NSMutableArray alloc]init];
    attrArray = [[NSMutableArray alloc]init];
    bestArray = [[NSMutableArray alloc]init];
    hotArray = [[NSMutableArray alloc]init];
    tempArray = [[NSMutableArray alloc]init];
    shopDic = [[NSMutableDictionary alloc]init];
    addressDic = [[NSMutableDictionary alloc]init];

}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"本页面仅供查看显示效果,无法进行购买等操作!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
}



- (void)createRecat {
    if (UserId && _goodId) {
        
        NSDictionary *dic = @{@"user_id":UserId,@"goods_id":_goodId};
 
        [HttpTool POST:URLDependByBaseURL(@"/Api/User/AddUserBrowseGoods") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
        
    }
}
-(void)dataInit{
//    NSLog(@"— goodID%@",_goodId);
    if (_goodId) {
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:[[UIApplication sharedApplication].delegate window]];
//        NSLog(@"%@",UserId);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_group_t getDataGroup = dispatch_group_create();
            
            dispatch_group_enter(getDataGroup);
            NSLog(@"%@",_goodId);
            
            NSDictionary *dic;
            if (UserId) {
                dic = @{@"user_id":UserId,
                        @"goods_id":_goodId
                        };
            }else {
                dic = @{@"goods_id":_goodId};
            }
            __weak typeof(self) weakSelf = self;
             [HttpTool POST:URLDependByBaseURL(@"/Api/Goods/noSaleView") parameters:dic success:^(id responseObject) {
                
//                NSLog(@"%@",responseObject);
//                NSLog(@"商品详情请求数据：%@",[responseObject objectForKey:@"message"]);
                
                if ([responseObject[@"status"] integerValue]==2) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                    
                }else if([responseObject[@"status"] integerValue]==1){
                    
                    //等于1 接口返回数据成功
                    if (responseObject[@"result"][@"goodsinfo"]==false) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                    
                    NSDictionary *dic = responseObject[@"result"][@"goodsinfo"];
                    GoodsDetailModel * model = [[GoodsDetailModel alloc]initWithDictionary:dic error:nil];
                    [_dataArray addObject:model];
                    
                    //图文详情
                    goods_attr_desc = responseObject[@"result"][@"goodsinfo"][@"goods_attr_desc"];
                    goods_desc = responseObject[@"result"][@"goodsinfo"][@"goods_desc"];
                    
                    shopDic = responseObject[@"result"][@"shop_info"];  //存放商品对应得商家信息。
                    //大图图片
                    image_name_Url = responseObject[@"result"][@"goodsinfo"][@"original_img"];
                    
                    for (NSDictionary * dic1 in responseObject[@"result"][@"pictures"]) {
                        NSString *imageUrl = dic1[@"img_original"];
                        if (![imageUrl isKindOfClass:[NSNull class]] && imageUrl != nil) {
                            [_picArray addObject:imageUrl];
                        }
                    }
                    
                    if (responseObject[@"result"][@"attribute"] != nil) {
                        for (NSDictionary * dic in responseObject[@"result"][@"attribute"]) {
                            AttributeModel * model = [[AttributeModel alloc]init];
                            [model setValuesForKeysWithDictionary:dic];
                            [attrArray addObject:model];
                        }
                    }
                    if (attrArray.count != 0) {
                        backViewHight = 250;
                        type = [NSMutableString stringWithString:[attrArray[0] attr_names]];
                    }else{
                        backViewHight = 180;
                    }
                    
                    dispatch_group_leave(getDataGroup);
                }
                
                
                
            } failure:^(NSError *error) {
                
                dispatch_group_leave(getDataGroup);
                
            }];
            
            
            //精选推荐
            dispatch_group_enter(getDataGroup);
            [HttpTool POST:URLDependByBaseURL(@"/Api/Index/get_recommend_goods") parameters:@{@"type":@"best",@"amount":@"6"} success:^(id responseObject) {
                for (NSDictionary * dic in responseObject[@"result"]) {
                    RecomendModel * model = [[RecomendModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [bestArray addObject:model];
                }
                tempArray = bestArray;
                
                dispatch_group_leave(getDataGroup);
            } failure:^(NSError *error) {
                dispatch_group_leave(getDataGroup);
            }];
            //门店热销
            
            dispatch_group_enter(getDataGroup);
            [HttpTool POST:URLDependByBaseURL(@"/Api/Index/get_recommend_goods") parameters:@{@"type":@"hot",@"amount":@"6"} success:^(id responseObject) {
                for (NSDictionary * dic in responseObject[@"result"]) {
                    RecomendModel * model = [[RecomendModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [hotArray addObject:model];
                }
                dispatch_group_leave(getDataGroup);
            } failure:^(NSError *error) {
                dispatch_group_leave(getDataGroup);
            }];
            
//            //获取正在展示的商品的购物车数量
//            if (UserId) {
//                
//                dispatch_group_enter(getDataGroup);
//                [HttpTool POST:URLDependByBaseURL(@"/Api/Cart/SumUserCartSingleGoods") parameters:@{@"token":[ @{@"user_id":UserId,@"goods_id":_goodId} paramsDictionaryAddSaltString]} success:^(id responseObject) {
//
//                    if (_dataArray.count > 0 && [[_dataArray[0] is_exchange] isEqualToNumber:@0]) {
//                        cartCount  = [[[responseObject objectForKey:@"result"] objectForKey:@"total_num"] integerValue];
//                        
//                    }else {
//                        cartCount = 0;
//                    }
//                    
//                    
//                    dispatch_group_leave(getDataGroup);
//                } failure:^(NSError *error) {
//                    dispatch_group_leave(getDataGroup);
//                }];
//                
//            }
            
            dispatch_group_wait(getDataGroup, DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                [weakSelf createUI];
            });
        });
        
        
        
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)createUI{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    _scrollView.contentSize = CGSizeMake(Width, contentHeight);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    //顶部返回按钮
    backButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 30, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"tubiao1"] forState:UIControlStateNormal];
    backButton.tag = 21;
    [backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //顶部购物者按钮
    cartButton = [[UIButton alloc]initWithFrame:CGRectMake(Width-100, 20, 30, 30)];
    [cartButton setBackgroundImage:[UIImage imageNamed:@"gouwuche1-1"] forState:UIControlStateNormal];
    cartButton.tag = 22;
    [cartButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cartButton];
    
    //顶部分类按钮
    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(Width-50, 20, 30, 30)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"tubiao2"] forState:UIControlStateNormal];
    menuButton.tag = 23;
    [menuButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    //底部收藏按钮
    UIButton * collectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, Height-50, Width/3, 50)];
    [collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang1"] forState:UIControlStateSelected];
    collectButton.tag = 24;
    if (_dataArray.count > 0) {
        if ([_dataArray[0] iscollect]) {
            collectButton.selected = YES;
        }else{
            collectButton.selected = NO;
        }
    }
    
    [collectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectButton];
    
    //底部加入购物车
    UIButton * addToButton = [[UIButton alloc]initWithFrame:CGRectMake(Width/3, Height-50, Width/3, 50)];
    [addToButton setBackgroundImage:[UIImage imageNamed:@"addToCar"] forState:UIControlStateNormal];
    addToButton.tag = 25;
    [addToButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addToButton];
    
    //底部立即购买按钮
    UIButton * buyButton = [[UIButton alloc]initWithFrame:CGRectMake(Width/3*2, Height-50, Width/3, 50)];
    [buyButton setBackgroundImage:[UIImage imageNamed:@"buy"] forState:UIControlStateNormal];
    buyButton.tag = 26;
    [buyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
    
//返回顶部
//    UIButton *topbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    topbutton.backgroundColor = [UIColor lightGrayColor];
//    topbutton.alpha = 0.5;
//    buyButton.titleLabel.font = [UIFont systemFontOfSize:8];
//    [topbutton setTitle:@"顶部" forState:UIControlStateNormal];
//    topbutton.frame = CGRectMake(Width-50, Height-100, 40, 40);
//    [self.view addSubview:topbutton];
//    topbutton.layer.cornerRadius = 20;
//    topbutton.clipsToBounds = YES;
//    [topbutton addTarget:self action:@selector(returnTop) forControlEvents:UIControlEventTouchUpInside];
//
    
    //徽标
    badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width/3*2-25, Height-60, 24, 24)];
    badgeLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:1/255.0 blue:1/255.0 alpha:0.8];
    badgeLabel.layer.cornerRadius = 12;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.font = [UIFont systemFontOfSize:13];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.textColor = [UIColor whiteColor];
    if (cartCount != 0) {
        badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)cartCount];
        [self.view addSubview:badgeLabel];
    }
    
    
    //轮播图
    ImagesScrollView * adSC = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Width)];
    adSC.isLoop = NO;
    adSC.placeholderImage = [UIImage imageNamed:@"ic_load_image_pleaceholder"];
    adSC.autoScrollInterval = 10000000;
    adSC.delegate = self;
    [_scrollView addSubview:adSC];
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Width, Width, 185)];
    contentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:contentView];
    //商品标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Width-20, 40)];
    if (_dataArray.count > 0) {
        titleLabel.text = [_dataArray[0] goods_name];
    }
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:titleLabel];
    
    //商品描述
    UILabel * desLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, Width, 30)];
    if (_dataArray.count > 0) {
        desLabel.text = [_dataArray[0] goods_brief];;
    }
    desLabel.numberOfLines = 0;
    desLabel.textColor = [UIColor grayColor];
    desLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:desLabel];
    
    if ([[_dataArray[0] is_exchange] isEqualToNumber:@0]) {
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 90, 30)];
        priceLabel.text = [_dataArray[0] shop_price_formated];
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.textColor = [UIColor redColor];
        priceLabel.font = [UIFont systemFontOfSize:15];
        [contentView addSubview:priceLabel];
        
        if ([[_dataArray[0] is_promote] isEqualToString:@"1"]) {
            priceLabel.text = [_dataArray[0] promote_price];
        }
        
        if ([[_dataArray[0] is_give_integral] isEqualToNumber:@0]) {
            UILabel * preLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 70, 100, 19)];
            UIColor * color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"duihuakuang"]];
            [preLabel setBackgroundColor:color];
            preLabel.text = [NSString stringWithFormat:@"  送%@国币",[_dataArray[0] shop_price]];
            preLabel.textAlignment = NSTextAlignmentCenter;
            preLabel.textColor = [UIColor whiteColor];
            preLabel.font = [UIFont systemFontOfSize:15];
            [contentView addSubview:preLabel];
        }
    }else if ([[_dataArray[0] is_exchange] isEqualToNumber:@1]){
        UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 70, 30, 30)];
        [iconImage setImage:[UIImage imageNamed:@"guobi"]];
        [contentView addSubview:iconImage];
        
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 70, 100, 30)];
        priceLabel.text = [NSString stringWithFormat:@"%@个",[_dataArray[0] shop_price]];
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.textColor = [UIColor redColor];
        priceLabel.font = [UIFont systemFontOfSize:15];
        [contentView addSubview:priceLabel];
    }
    
    
    //原价
    UILabel * ppLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 100, 30)];
    ppLabel.text = [NSString stringWithFormat:@"原价:%@",[_dataArray[0] market_price]];
    ppLabel.font = [UIFont boldSystemFontOfSize:13];
    ppLabel.tag = 9;
    ppLabel.textColor = [UIColor grayColor];
    [contentView addSubview:ppLabel];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(15, 115, 80, 1)];
    line.backgroundColor = [UIColor redColor];
    [contentView addSubview:line];
    
#pragma mark- 修改 --------------------------------------------------------------------------------------------
    
    _goodsList = [[UIView alloc]initWithFrame:CGRectMake(0, Width+155, Width, 285)];
    //        _goodsList.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1];
    _goodsList.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_goodsList];
    
    //选择尺码，颜色
    selectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 130, Width, 25)];
    selectButton.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:12];
    selectButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [selectButton setTitle:@"请选择尺码、颜色分类" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
    [selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [selectButton setImageEdgeInsets:UIEdgeInsetsMake(0, Width-20, 0, -Width+20)];
    selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    selectButton.tag = 10;
    [selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:selectButton];
//    //送至label
//    UILabel * sendToLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 38, 30)];
//    sendToLabel.textColor =[UIColor grayColor];
//    sendToLabel.font = [UIFont systemFontOfSize:13];
//    sendToLabel.textAlignment = NSTextAlignmentCenter;
//    sendToLabel.text = [NSString stringWithFormat:@"送至:"];
//    [_goodsList addSubview:sendToLabel];
//    
//    UILabel  *sendToLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 150, 30)];
//    sendToLabel1.font = [UIFont systemFontOfSize:13];
//    sendToLabel1.numberOfLines = 1;
//    NSString *str = [addressDic objectForKey:@"province"];
//    sendToLabel1.text = [NSString stringWithFormat:@"%@>%@>%@",[addressDic objectForKey:@"province"],[addressDic objectForKey:@"city"],[addressDic objectForKey:@"district"]];
//    [_goodsList addSubview:sendToLabel1];
    
//    //送至 lab的右侧的地图按钮
//    UIButton *locationBtn = [[UIButton alloc]init];
//    [locationBtn setImage:[UIImage imageNamed:@"image_name_Url.png"] forState:UIControlStateNormal];
//    [sendToLabel1 addSubview:locationBtn];
//    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(sendToLabel1.mas_top);
//        make.left.mas_equalTo(sendToLabel1.mas_right);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(30);
//        
//    }];
    
    //运费label
    UILabel * costLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 38, 30)];
    costLabel.text = @"运费:";
    costLabel.textColor = [UIColor grayColor];
    costLabel.textAlignment = NSTextAlignmentCenter;
    costLabel.font = [UIFont boldSystemFontOfSize:13];
    [_goodsList addSubview:costLabel];
    
    UILabel * costLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 60, 30)];
    costLabel1.textColor = [UIColor grayColor];
    if ([[_dataArray[0] shipping_price] floatValue] == 0) {
        costLabel1.text = @"包邮";
    }else{
        costLabel1.text = [_dataArray[0] shipping_price];
    }
    costLabel1.font = [UIFont systemFontOfSize:13];
    [_goodsList addSubview:costLabel1];
    
    //服务label
    UILabel * serveLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 38, 30)];
    serveLabel.text = @"服务:";
    serveLabel.textColor = [UIColor grayColor];
    serveLabel.textAlignment = NSTextAlignmentCenter;
    serveLabel.font = [UIFont boldSystemFontOfSize:13];
    [_goodsList addSubview:serveLabel];
    
    UILabel  *serveLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, Width-60, 30)];
    serveLabel1.textColor = [UIColor grayColor];
    serveLabel1.font = [UIFont systemFontOfSize:13];
    serveLabel1.numberOfLines = 1;
    serveLabel1.text = [NSString stringWithFormat:@"由%@为您派送",[shopDic objectForKey:@"shop_title"]];
    [_goodsList addSubview:serveLabel1];
    
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(5, 70, Width-10, 1)];
    line1.backgroundColor =[UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1];
    [_goodsList addSubview:line1];

    
    //商店信息View
    UIView * shopView = [[UIView alloc]init];
    shopView.backgroundColor = [UIColor whiteColor];
    [_goodsList addSubview:shopView];
    
    //头像
    UIImageView *headerImgV = [[UIImageView alloc]init];
    headerImgV.layer.cornerRadius = 20;
    headerImgV.clipsToBounds = YES;
    NSString *shoplogo = [shopDic objectForKey:@"shoplogo"];
    [headerImgV sd_setImageWithURL:[NSURL URLWithString:shoplogo] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    [shopView addSubview:headerImgV];
    
    //商店名字label
    UILabel *shopNameLabel = [[UILabel alloc]init];
    shopNameLabel.text = [shopDic objectForKey:@"shop_title"];
    shopNameLabel.font = [UIFont systemFontOfSize:13];
    shopNameLabel.textColor = [UIColor grayColor];
    [shopView addSubview:shopNameLabel];
    
    //关注
    UIButton *attractBtn = [[UIButton alloc]init];
    attractBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    attractBtn.layer.cornerRadius = 15;
    attractBtn.tag = 32;
    attractBtn.selected = NO;
    [attractBtn setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
    [attractBtn setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateSelected];
    //[attractBtn addTarget:self action:@selector(dmButton:) forControlEvents:UIControlEventTouchUpInside];
    [shopView addSubview:attractBtn];
    if ([[shopDic objectForKey:@"is_collect"] isEqualToString:@"Y"]) {
        attractBtn.selected = YES;
    }else {
        attractBtn.selected = NO;
    }
    
    //进店逛逛
    UIButton *incomeShopBtn = [[UIButton alloc]init];
    incomeShopBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [incomeShopBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [incomeShopBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [incomeShopBtn addTarget:self action:@selector(incomeShopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [incomeShopBtn setTitle:@"进店逛逛>" forState:UIControlStateNormal];
    //    [incomeShopBtn addTarget:self action:@selector(incomeShopBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    
    [shopView addSubview:incomeShopBtn];
    
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 124, Width, 1)];
    line2.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1];
    [shopView addSubview:line2];
    
    [shopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_top).offset(1);
        make.left.mas_equalTo(_goodsList.mas_left);
        make.width.mas_equalTo(_goodsList.mas_width);
        make.height.mas_equalTo(125);
    }];
    
    [headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(shopView.mas_top).with.offset(5);
        make.left.mas_equalTo(shopView.mas_left).with.offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        
    }];
    
    [shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(shopView.mas_top).with.offset(5);
        make.left.mas_equalTo(headerImgV.mas_right).with.offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        
    }];
    
    [attractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(shopView.mas_top).with.offset(10);
        make.right.mas_equalTo(shopView.mas_right).with.offset(-5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
        
    }];
    
    [incomeShopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(shopView.mas_bottom).with.offset(-5);
        make.right.mas_equalTo(shopView.mas_right).with.offset(-10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        
        
    }];
    
    
    NSInteger itemWidth = (Width-50)/4;
    NSArray *arr = @[@"全部宝贝",@"新上宝贝",@"关注人数"];
    
    if ([shopDic allKeys].count > 0) {
    NSArray *arr2 = @[[shopDic objectForKey:@"goods_num"],[shopDic objectForKey:@"new_num"],[shopDic objectForKey:@"collect_num"]];
    for (int i=0; i<3; i++) {
        
        //titlelabel
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = arr[i];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [shopView addSubview:titleLabel];
        
        //numberLabel
        UILabel *numberLabel = [[UILabel alloc]init];
        if ([arr2[i] isEqualToString:@""]) {
            numberLabel.text = @"0";
        }else {
            numberLabel.text = arr2[i];
        }
        numberLabel.font = [UIFont systemFontOfSize:13];
        numberLabel.textColor = [UIColor grayColor];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        [shopView addSubview:numberLabel];
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(headerImgV.mas_bottom).with.offset(5);
            make.left.mas_equalTo(headerImgV.mas_left).with.offset(i*itemWidth);
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(30);
            
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(numberLabel.mas_bottom);
            make.left.mas_equalTo(headerImgV.mas_left).with.offset(i*itemWidth);
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(30);
        }];
        
        
        if (i != 2) {
            
            UIImageView *imageV = [[UIImageView alloc]init];
            [shopView addSubview:imageV];
            imageV.image = [UIImage imageNamed:@"xuxian"];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(numberLabel.mas_top).offset(10);
                make.right.equalTo(titleLabel.mas_right);
                make.bottom.equalTo(titleLabel.mas_bottom).offset(-5);
                make.width.equalTo(@1);
            }];
            
        }
    }
    }
    
    NSMutableAttributedString *promptLab = [[NSMutableAttributedString alloc]initWithString:@"继续滑动查看图文详情"];
    [promptLab addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    UILabel *lab = [[UILabel alloc]init];
    lab.attributedText = promptLab;
    [shopView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopView.mas_bottom).offset(30);
        make.centerX.equalTo(shopView.mas_centerX);
        make.height.equalTo(@30);
    }];
    lab.font = [UIFont systemFontOfSize:14];
    
    
    /*
     
     //    UILabel * costLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 38, 30)];
     //    costLabel.text = @"运费:";
     //    costLabel.textColor = [UIColor grayColor];
     //    costLabel.textAlignment = NSTextAlignmentCenter;
     //    costLabel.font = [UIFont boldSystemFontOfSize:13];
     //    [contentView addSubview:costLabel];
     //
     //    UILabel * costLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 170, 60, 30)];
     //    if ([[_dataArray[0] shipping_price] isEqualToString:@"0.00"]) {
     //        costLabel1.text = @"包邮";
     //    }else{
     //        costLabel1.text = [_dataArray[0] shipping_price];
     //    }
     //    costLabel1.font = [UIFont boldSystemFontOfSize:13];
     //    [contentView addSubview:costLabel1];
     //
     //    recommendButton = [[UIButton alloc]initWithFrame:CGRectMake(0, Width+195, Width/2, 40)];
     //    recommendButton.backgroundColor = [UIColor whiteColor];
     //    [recommendButton setTitle:@"精选推荐" forState:UIControlStateNormal];
     //    [recommendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
     //    [recommendButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
     //    recommendButton.titleLabel.font = [UIFont systemFontOfSize:12];
     //    recommendButton.tag = 12;
     //    recommendButton.selected = YES;
     //    [recommendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
     //    [_scrollView addSubview:recommendButton];
     //
     //    hotButton = [[UIButton alloc]initWithFrame:CGRectMake(Width/2, Width+195, Width/2, 40)];
     //    hotButton.backgroundColor = [UIColor whiteColor];
     //    [hotButton setTitle:@"门店热销" forState:UIControlStateNormal];
     //    [hotButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
     //    [hotButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
     //    hotButton.titleLabel.font = [UIFont systemFontOfSize:12];
     //    hotButton.tag = 13;
     //    [hotButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
     //    [_scrollView addSubview:hotButton];
     //
     //    UILabel * carveLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width/2-1, Width+200, 2, 25)];
     //    carveLabel.backgroundColor = [UIColor grayColor];
     //    [showView addSubview:carveLabel];
     //
     //    _carveLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, Width+228, Width/2, 1)];
     //    _carveLabel1.backgroundColor = [UIColor redColor];
     //    [_scrollView addSubview:_carveLabel1];
     //
     //    _carveLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(Width/2-1, Width+228, Width/2, 1)];
     //    _carveLabel2.backgroundColor = [UIColor redColor];
     //
     //    UIButton * mostButton = [[UIButton alloc]initWithFrame:CGRectMake(0, Width+560, Width, 40)];
     //    mostButton.backgroundColor = [UIColor whiteColor];
     //    [mostButton setTitle:@"查看更多精选推荐商品>>" forState:UIControlStateNormal];
     //    [mostButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     //    mostButton.titleLabel.font = [UIFont systemFontOfSize:14];
     //    mostButton.tag = 20;
     //    [mostButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
     //    [_scrollView addSubview:mostButton];
     //
     //        UILabel * upLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Width+401, Width, 50)];
     //        upLabel.backgroundColor = MyColor;
     //        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"继续上滑查看商品图文详情"];
     //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
     //        upLabel.text = str;
     //        upLabel.textAlignment = NSTextAlignmentCenter;
     //        upLabel.font = [UIFont boldSystemFontOfSize:15];
     //        [_scrollView addSubview:upLabel];
     //
     //    _goodsList = [[UIView alloc]initWithFrame:CGRectMake(0, Width+231, Width, 320)];
     //    _goodsList.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1];
     //    [_scrollView addSubview:_goodsList];
     //
     //    for (int i=0; i<6; i++) {
     //        UIView * backView = [[UIView alloc]init];
     //        backView.backgroundColor = [UIColor whiteColor];
     //        [_goodsList addSubview:backView];
     //
     //        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
     //        button.backgroundColor = [UIColor whiteColor];
     //        button.tag =14+i;
     //        [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.ibg100.com%@",[tempArray[i] goods_img]]]];
     //        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
     //        [backView addSubview:button];
     //
     //        UILabel * titleLabel = [[UILabel alloc]init];
     //        titleLabel.textColor =[UIColor grayColor];
     //        titleLabel.tag = 1000+i;
     //        titleLabel.font = [UIFont systemFontOfSize:8];
     //        titleLabel.numberOfLines = 2;
     //        titleLabel.text = [tempArray[i] name];
     //        [backView addSubview:titleLabel];
     //
     //        UILabel * priceLabel = [[UILabel alloc]init];
     //        priceLabel.tag =1010+i;
     //        priceLabel.font = [UIFont systemFontOfSize:10];
     //        priceLabel.textColor =[UIColor redColor];
     //        priceLabel.text = [tempArray[i] shop_price];
     //        [backView addSubview:priceLabel];
     //
     //        NSInteger itemWidth = Width /3-10;
     //        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
     //            make.top.mas_equalTo(_goodsList.mas_top).with.offset(i/3*160+10);
     //            make.left.mas_equalTo(_goodsList.mas_left).with.offset((i%3)*(itemWidth+5)+10);
     //            make.width.mas_equalTo(itemWidth);
     //            make.height.mas_equalTo(150);
     //        }];
     //
     //        [button mas_makeConstraints:^(MASConstraintMaker *make) {
     //            make.top.mas_equalTo(backView.mas_top);
     //            make.left.mas_equalTo(backView.mas_left);
     //            make.width.mas_equalTo(itemWidth);
     //            make.height.mas_equalTo(100);
     //        }];
     //
     //        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
     //            make.top.mas_equalTo(button.mas_bottom);
     //            make.left.mas_equalTo(button.mas_left);
     //            make.width.mas_equalTo(itemWidth);
     //            make.height.mas_equalTo(30);
     //        }];
     //
     //        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
     //            make.top.mas_equalTo(titleLabel.mas_bottom);
     //            make.left.mas_equalTo(button.mas_left);
     //            make.width.mas_equalTo(itemWidth);
     //            make.height.mas_equalTo(20);
     //        }];
     //    };
     //    }
     */
    //详情页面
    //        GoodsDetailView * gdView = [[GoodsDetailView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(showView.frame), Width, Height)];
    //        gdView.recommendArray = bestArray;
    //        gdView.goods_id = _goodId;
    //        gdView.attr_id = [_dataArray[0] attr_id];
    //        gdView.is_exchange = [NSString stringWithFormat:@"%@",[_dataArray[0] is_exchange]];
    //        gdView.goods_desc = goods_desc;
    //        gdView.goods_attr_desc = goods_attr_desc;
    //        gdView.dataArray = _dataArray;
    //        gdView.tempArray = tempArray;
    //        [_scrollView addSubview:gdView];
    //
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    DetailsViewController * dvc = [[DetailsViewController alloc]init];
    dvc.recommendArray = bestArray;
    dvc.goods_id = _goodId;
    dvc.attr_id = [_dataArray[0] attr_id];
    dvc.is_exchange = [NSString stringWithFormat:@"%@",[_dataArray[0] is_exchange]];
    dvc.goods_desc = goods_desc;
    dvc.goods_attr_desc = goods_attr_desc;
    dvc.dataArray = _dataArray;
//    NSLog(@"%@",tempArray);
    dvc.tempArray = tempArray;
    [self addChildViewController:dvc];
    
    //    just for force load view
    if (dvc.view != nil) {
        _scrollView.secondScrollView = dvc.scrollView;
        [[dvc.scrollView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isMemberOfClass:[UIButton class]]) {
               obj.userInteractionEnabled = NO;
            }
            
        }];
    }
    
}

//点击购物车时功能弹出底部界面
-(void)createView{
    
    transparentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, self.view.bounds.size.height)];
    transparentView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.7];
    [self.view addSubview:transparentView];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, transparentView.bounds.size.height-backViewHight, Width, backViewHight)];
    backView.backgroundColor = [UIColor whiteColor];
    [transparentView addSubview:backView];
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, transparentView.bounds.size.height-backViewHight-25, 50, 50)];
    [icon sd_setImageWithURL:[NSURL URLWithString:image_name_Url] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    [transparentView addSubview:icon];
    icon.layer.borderWidth  =2;
    icon.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    priceLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 150, 20)];
    [backView addSubview:priceLabel1];
    if (attrArray.count != 0) {
        goodsPrice = [[attrArray[0] shop_price]floatValue];
        priceLabel1.text = [NSString stringWithFormat:@"￥%ld",(long)goodsPrice];
    }
    if ([[_dataArray[0] is_exchange] isEqualToNumber:@0]) {
        goodsPrice = [[_dataArray[0] shop_price_formated] floatValue];
        
    }
    if ([[_dataArray[0] is_promote] isEqualToString:@"1"]) {
        NSString *priceStr = [_dataArray[0] promote_price];
        goodsPrice = [[priceStr substringFromIndex:1] floatValue];
        priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",goodsPrice];

    }
    else{
        NSString *str = [_dataArray[0] shop_price];
        goodsPrice = [str floatValue];
//        NSLog(@"%f",goodsPrice);
        priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",goodsPrice];
    }
    
    if (attrArray.count != 0) {
        UILabel * typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, backView.bounds.size.height-210, 40, 20)];
        typeLabel.text = @"类型:";
        typeLabel.font = [UIFont systemFontOfSize:15];
        [backView addSubview:typeLabel];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(65, backView.bounds.size.height-210, Width-80, 80)];
        [backView addSubview:view];
        
        int len = (Width-80)/4;
        for (int i =0; i<attrArray.count; i++) {
            UIButton * typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            typeButton.frame = CGRectMake(i%4*len, i/4*30, len-5, 25);
            typeButton.backgroundColor = [UIColor whiteColor];
            typeButton.tag = 50+i;
            if (i==0) {
                typeButton.selected = YES;
            }else{
                typeButton.selected = NO;
            }
            typeButton.layer.borderColor = [UIColor grayColor].CGColor;
            typeButton.layer.borderWidth = 1;
            typeButton.layer.cornerRadius = 5;
            typeButton.titleLabel.font = [UIFont systemFontOfSize:10];
            typeButton.titleLabel.numberOfLines = 2;
            [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [typeButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [typeButton setTitle:[NSString stringWithString:[attrArray[i] attr_names]] forState:UIControlStateNormal];
            typeButton.titleLabel.adjustsFontSizeToFitWidth = YES;//字体大小自适应
            //[typeButton addTarget: self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:typeButton];
        }
    }
    
    UILabel * countLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15, backView.bounds.size.height-120, 40, 20)];
    countLabel1.text = @"数量:";
    countLabel1.font = [UIFont systemFontOfSize:15];
    [backView addSubview:countLabel1];
    
    UIButton * descButton = [UIButton buttonWithType:UIButtonTypeCustom];
    descButton.frame = CGRectMake(Width/2-90, countLabel1.frame.origin.y, 30, 30);
    descButton.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    descButton.tag = 1;
    descButton.layer.cornerRadius = 5;
    [descButton setImage:[UIImage imageNamed:@"jianhao"] forState:UIControlStateNormal];
    [descButton addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:descButton];
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(Width/2+60, countLabel1.frame.origin.y, 30, 30);
    addButton.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    addButton.tag = 2;
    addButton.layer.cornerRadius = 5;
    [addButton setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [addButton addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:addButton];
    
    countLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width/2-30, countLabel1.frame.origin.y, 60, 30)];
    countLabel.text = [NSString stringWithFormat:@"%ld",(long)goodsCount];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.layer.borderColor = [UIColor grayColor].CGColor;
    countLabel.layer.borderWidth = 1.0;
    countLabel.layer.cornerRadius = 5;
    [backView addSubview:countLabel];
    
    UIButton * certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    certainButton.frame = CGRectMake(Width/2-110, backViewHight-60, 70, 40);
    [certainButton setTitle:@"确定" forState:UIControlStateNormal];
    certainButton.tag = 3;
    certainButton.layer.cornerRadius = 8;
    certainButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
    [certainButton addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:certainButton];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(Width/2+40, backViewHight-60, 70, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.tag = 4;
    cancelButton.layer.cornerRadius = 8;
    cancelButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
    [cancelButton addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelButton];
    
}

//Action

-(void)incomeShopBtnAction{
    /*
     NSMutableDictionary *shopInfo = [NSMutableDictionary dictionaryWithDictionary:shopDic];
     GSStoreDetailViewController *detailVC =ViewController_in_Storyboard(@"Main", @"storeDetailViewController");
     detailVC.hidesBottomBarWhenPushed = NO;
     //detailVC.view.backgroundColor = [UIColor whiteColor];
     detailVC.storeModel = [GSStoreListModel mj_objectWithKeyValues:shopInfo];
     [self.navigationController pushViewController:detailVC animated:YES];
     */
}

-(void)goodsListReload{
    for (int i=0; i<6; i++) {
        UIButton * button = [_goodsList viewWithTag:14+i];
        [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tempArray[i] goods_img]]]];
        UILabel * label = [_goodsList viewWithTag:1000+i];
        label.text = [tempArray[i] name];
        UILabel * label1 = [_goodsList viewWithTag:1010+i];
        label1.text = [tempArray[i] shop_price];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"%f",scrollView.contentOffset.y);
    if (_scrollView.contentOffset.y >460) {
        [UIView animateWithDuration:0.5 animations:^{
            backButton.hidden = YES;
            cartButton.hidden = YES;
            menuButton.hidden = YES;
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            backButton.hidden = NO;
            cartButton.hidden = NO;
            menuButton.hidden = NO;
        }];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffse{
    if (end) {
        //                DetailsViewController * dvc = [[DetailsViewController alloc]init];
        //                dvc.hidesBottomBarWhenPushed = YES;
        //                dvc.recommendArray = bestArray;
        //                dvc.goods_id = _goodId;
        //                dvc.attr_id = [_dataArray[0] attr_id];
        //                dvc.is_exchange = [NSString stringWithFormat:@"%@",[_dataArray[0] is_exchange]];
        //                dvc.goods_desc = goods_desc;
        //                dvc.goods_attr_desc = goods_attr_desc;
        //                dvc.dataArray = _dataArray;
        //                dvc.tempArray = tempArray;
        //                [self.navigationController pushViewController:dvc animated:YES];
    }
}

-(void)buttonClick:(UIButton *)button{
    if (button.tag == 21) {
        [self.navigationController popViewControllerAnimated:YES];
    }
//    NSString * is_exchange = [NSString stringWithFormat:@"%@",[_dataArray[0] is_exchange]];
    /*
    GSBusinessGoodsShowViewController * gsvc = [[GSBusinessGoodsShowViewController alloc]init];
//    MoneyViewController * mvc = [[MoneyViewController alloc]init];
    LoginViewController * Lvc = [[LoginViewController alloc]init];
    GBOrderViewController * gbvc = [[GBOrderViewController alloc]init];
    
    switch (button.tag) {
        case 10:
            addCart = 1;   //点击尺码选择 进入购物车
            [self createView];
            break;
        case 11:
//            NSLog(@"地址");
            break;
            
        case 12://精选推荐
            button.selected = YES;
            hotButton.selected = NO;
            tempArray = bestArray;
            [self goodsListReload];
            [_carveLabel2 removeFromSuperview];
            [_scrollView addSubview:_carveLabel1];
            break;
        case 13://门店热销
            button.selected = YES;
            recommendButton.selected = NO;
            tempArray = hotArray;
            [self goodsListReload];
            [_carveLabel1 removeFromSuperview];
            [_scrollView addSubview:_carveLabel2];
            break;
        case 14:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[tempArray[button.tag-14] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
            break;
        case 15:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[tempArray[button.tag-14] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
            break;
        case 16:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[tempArray[button.tag-14] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
            break;
        case 17:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[tempArray[button.tag-14] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
            break;
        case 18:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[tempArray[button.tag-14] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
            break;
        case 19:
            gsvc.goodId = [NSString stringWithFormat:@"%@",[tempArray[button.tag-14] goods_id]];
            [self.navigationController pushViewController:gsvc animated:YES];
            break;
        case 20:
            if (self.tabBarController.selectedIndex == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                self.tabBarController.selectedIndex = 1;
            }
            break;
            
        case 21://返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 22: { //去往购物车
            self.tabBarController.selectedIndex = 2;
        }
            break;
        case 23://下拉菜单
            is_down = !is_down;
            if (is_down) {
                [self createDownView];
            }else{
                [downView removeFromSuperview];
            }
            break;
        case 24://收藏
            isSelected = !isSelected;
            [self addToMyCollect];
            break;
        case 25://加入购物车

            if (self.from.integerValue==1) {
         [AlertTool alertTitle:@"提示" mesasge:@"国币商品需直接购买" preferredStyle:UIAlertControllerStyleAlert confirmHandler:nil viewController:self];

            }
            else
            {
            addCart = 1;
            [self createView];
            }
            
            break;


        case 26://立即购买
            
            [transparentView removeFromSuperview];
      
//            if (is_setAttr) {
            
            if ([[_dataArray[0] is_exchange] isEqualToNumber:@0]) {    //0:不支持使用国币兑换  1：支持使用国币兑换

                if (cartCount > 0) {  //如果已经加入购物车，进入购买页面
                    //金币
                    if (UserId) {
                        if (rec_id.length) {
                            
                            [self payMoney];
                            
                        }else{
                            
                            //添加商品到购物车
                            [self addToCart];

                        }
                    }else{
                        Lvc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:Lvc animated:YES];
                    }
                
            }else{
                
                addCart = 1;
                toBUY = 1; //当从立即购买进入商品数量选择时设置值为1；
                [self createView];
                
            }
        
        }else{
            //国币
            if (UserId) {
                
            [self addToCart];
            gbvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gbvc animated:YES];
                
            }else{
                Lvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:Lvc animated:YES];
            }
        
            }

            break;
            
        default:
            break;
    }
     */
}

/*
- (void)payMoney {
    
    MoneyViewController * mvc = [[MoneyViewController alloc]init];
    LoginViewController * Lvc = [[LoginViewController alloc]init];
    GBOrderViewController * gbvc = [[GBOrderViewController alloc]init];
    
    if ([[_dataArray[0] is_exchange] isEqualToNumber:@0]) {    //0:不支持使用国币兑换  1：支持使用国币兑换
        //金币
        if (UserId) {
            if (rec_id.length) {
                
                mvc.tokenStr = rec_id;
                mvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:mvc animated:YES];
                
            }else{
                
                [self addToCart];

            }
        }else{
            Lvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:Lvc animated:YES];
        }
    }else{
        //国币
        if (UserId) {
            [self addToCart];
            gbvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gbvc animated:YES];
        }else{
            Lvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:Lvc animated:YES];
        }
    }
}
*/


//添加收藏
-(void)addToMyCollect{
    
    UIButton * button = [self.view viewWithTag:24];
    if (UserId) {
        NSString * userId = [NSString stringWithFormat:@"user_id=%@,goods_id=%@",UserId,_goodId];
        NSString * encryptString = [userId encryptStringWithKey:KEY];
        [HttpTool POST:URLDependByBaseURL(@"/Api/User/addcollect") parameters:@{@"token":encryptString} success:^(id responseObject) {
            if ([responseObject[@"status"] isEqualToNumber:@0]) {
                button.selected = YES;
            }else if ([responseObject[@"status"] isEqualToNumber:@3]){
                button.selected = NO;
            }
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } failure:^(NSError *error) {
            
        }];
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请登录..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        GSNewLoginViewController * lvc = [[GSNewLoginViewController alloc]init];
        lvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lvc animated:YES];
    }
    
}

//添加购物车
/*
-(void)addToCart{
    if (UserId) {
        
        if (toBUY == 1) {    //点击立即购买直接支付

        NSString * is_exchange = [NSString stringWithFormat:@"%@",[_dataArray[0] is_exchange]];
        //暂定商品属性
            if (!attr_id) {
                attr_id = [NSMutableString stringWithFormat:@"0"];
            }
            
        NSString *num = [NSString stringWithFormat:@"%ld",goodsCount];
        NSDictionary *dic = @{@"user_id":UserId,
                              @"goods_id":_goodId,
                              @"num":num,
                              @"attr_id":attr_id,
                              @"is_exchange":is_exchange};
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_group_t getDataGroup = dispatch_group_create();
            dispatch_group_enter(getDataGroup);
        [HttpTool POST:URLDependByBaseURL(@"/Api/Cart/add_cart") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
//            NSLog(@"%@",responseObject[@"message"]);
            rec_id = responseObject[@"result"];
            if ([responseObject[@"status"] isEqual:@2]) {
                cartCount =0;
                [badgeLabel removeFromSuperview];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"库存不足！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            dispatch_group_leave(getDataGroup);
        } failure:^(NSError *error) {
            dispatch_group_leave(getDataGroup);
        }];
            
        dispatch_group_wait(getDataGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self payMoney]; //支付
            
            });
        });
            
        }else {
            
            NSString * is_exchange = [NSString stringWithFormat:@"%@",[_dataArray[0] is_exchange]];
            //暂定商品属性
            if (!attr_id) {
                attr_id = [NSMutableString stringWithFormat:@"0"];
            }
            
            NSString *num = [NSString stringWithFormat:@"%ld",goodsCount];
            NSDictionary *dic = @{@"user_id":UserId,
                                  @"goods_id":_goodId,
                                  @"num":num,
                                  @"attr_id":attr_id,  //商品属性
                                  @"is_exchange":is_exchange};
  
                [HttpTool POST:URLDependByBaseURL(@"/Api/Cart/add_cart") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
//                    NSLog(@"%@",responseObject[@"message"]);
                    rec_id = responseObject[@"result"];
                    if ([responseObject[@"status"] isEqual:@2]) {
                        cartCount =0;
                        [badgeLabel removeFromSuperview];
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"库存不足！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                } failure:^(NSError *error) {
                }];
        }
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请登录..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        LoginViewController * lvc = [[LoginViewController alloc]init];
        lvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lvc animated:YES];
    }
    
    toBUY = 0;
}
 */
#pragma mark - 浏览大图 代理方法
//图片数量
-(NSInteger)numberOfImagesInImagesScrollView:(ImagesScrollView *)imagesScrollView{
    
    if (_picArray.count > 0) {
        return _picArray.count;
    }
    return 1;
}
//填充图片
-(NSString *)imagesScrollView:(ImagesScrollView *)imagesScrollView imageUrlStringWithIndex:(NSInteger)index{
    
    if (_picArray.count > 0 ) {
        NSString *urlStr = _picArray[index];
        
        NSString *subStr = [urlStr substringToIndex:4];
        if ([subStr isEqualToString:@"http"]) {
            return _picArray[index];
        }else {
            NSString *urlStr = [NSString stringWithFormat:@"http://www.ibg100.com/%@",_picArray[index]];
            return urlStr;
        }

    }else {
        if (![image_name_Url isKindOfClass:[NSNull class]]) {
            
            NSString *subStr = [image_name_Url substringToIndex:4];
            if ([subStr isEqualToString:@"http"]) {
                return image_name_Url;
            }else {
                return [NSString stringWithFormat:@"http://www.ibg100.com/%@",image_name_Url];
            }
        }
    }

    return nil;

}

//选择商品属性按钮点击事件
-(void)btnClick:(UIButton *)button{
    /*
    float temp = goodsPrice;
    NSString * is_exchange = [NSString stringWithFormat:@"%@",[_dataArray[0] is_exchange]];
    
    LoginViewController * myvc = [[LoginViewController alloc]init];
    
    GBOrderViewController * gbvc = [[GBOrderViewController alloc]init];
    
    switch (button.tag) {
        case 1:
            //减号
            if (goodsCount>=1) {
                goodsCount --;
                temp *= goodsCount;
                countLabel.text = [NSString stringWithFormat:@"%ld",(long)goodsCount];
                priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",temp];
            }
            break;
        case 2:
            //加号
            goodsCount ++;
            temp *= goodsCount;
            countLabel.text = [NSString stringWithFormat:@"%ld",(long)goodsCount];
            priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",temp];
            break;
        case 3:{
            //确定
            
            [transparentView removeFromSuperview];
            is_setAttr = YES;
            if (addCart == 0) {
                if (attrArray.count==0) {
                    [selectButton setTitle:[NSString stringWithFormat:@"已选 数量 *%ld",goodsCount] forState:UIControlStateNormal];
                }else{
                    [selectButton setTitle:[NSString stringWithFormat:@"已选 %@ 数量 *%ld",type,goodsCount] forState:UIControlStateNormal];
                }
            }else{
                if (UserId) {
                    //登录状态
                    [self addToCart];
                    
                    if ([is_exchange isEqualToString:@"1"]) {
                        gbvc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:gbvc animated:YES];
                    }else{
                        cartCount += goodsCount;
                        badgeLabel.text = [NSString stringWithFormat:@"%ld",cartCount];
                        [self.view addSubview:badgeLabel];
                    }
                    
                }else{
                    myvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myvc animated:YES];
                }
            }
        }
            break;
        case 4:
            //取消
            [transparentView removeFromSuperview];
            goodsCount = 1;
            break;
            
        default:
            break;
    }
}

//类型属性选择
-(void)button:(UIButton *)button{
    for (int i = 50 ; i<attrArray.count+50; i++) {
        if (button.tag == i) {
            button.selected = YES;
            goodsPrice = [attrArray[i-50]shop_price].floatValue;
            type = [NSMutableString stringWithString:[attrArray[i-50] attr_names]];
            attr_id = [NSMutableString stringWithString:[attrArray[i-50] ID]];
            priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",goodsPrice*goodsCount];
        }else{
            UIButton * button1 = [transparentView viewWithTag:i];
            button1.selected = NO;
        }
    }
}

-(void)createDownView{
    downView = [[UIView alloc]initWithFrame:CGRectMake(Width-70, 70, 70, 60)];
    downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
    
    UIButton * classButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classButton.frame = CGRectMake(0, 0, downView.bounds.size.width, 29);
    classButton.backgroundColor = [UIColor colorWithRed:75/255.0 green:57/255.0 blue:51/255.0 alpha:1];
    [classButton setTitle:@"分类" forState:UIControlStateNormal];
    classButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [classButton setImage:[UIImage imageNamed:@"fenlei"] forState:UIControlStateNormal];
    [classButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    classButton.tag = 30;
    [classButton addTarget:self action:@selector(dmButton:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:classButton];
    
    UIButton * homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0, 30, downView.bounds.size.width, 30);
    homeButton.backgroundColor = [UIColor colorWithRed:75/255.0 green:57/255.0 blue:51/255.0 alpha:1];
    [homeButton setTitle:@"主页" forState:UIControlStateNormal];
    homeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [homeButton setImage:[UIImage imageNamed:@"shouye1"] forState:UIControlStateNormal];
    [homeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [homeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    homeButton.tag = 31;
    [homeButton addTarget:self action:@selector(dmButton:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:homeButton];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (is_down) {
        [downView removeFromSuperview];
        is_down = NO;
    }
}
//下拉菜单按钮点击事件  关注按钮
-(void)dmButton:(UIButton *)button{
    switch (button.tag) {
        case 30:
        {
            ClassifyViewController * cvc = [[ClassifyViewController alloc]init];
            [self.navigationController pushViewController:cvc animated:YES];
            [downView removeFromSuperview];
            is_down = NO;
        }
            break;
        case 31:
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            [downView removeFromSuperview];
            is_down = NO;
            break;
        case 32:{  //关注功能
            if (UserId) {
                
//                button.selected = !button.selected;
                NSString *shopid = [shopDic objectForKey:@"shop_id"];
                NSDictionary *dic = @{@"user_id":UserId,@"shop_id":shopid};
//                NSLog(@"--%@",[dic paramsDictionaryAddSaltString]);
                [HttpTool POST:URLDependByBaseURL(@"/Api/Collect/CollectShop") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
                    
                    NSString *message = [responseObject objectForKey:@"message"];
                    
                    if ([message isEqualToString:@"取消收藏店铺成功"]) {
                        button.selected = NO;
                    }
                    if ([message isEqualToString:@"收藏店铺成功"]) {
                        button.selected = YES;
                    }
                    
                } failure:^(NSError *error) {
                    
                }];
                
            }
            
        }
            break;
        default:
            break;
    }
     */
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
