 //
//  GoodsInfoViewController.m
//  guoshang
//
//  Created by JinLian on 16/7/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsInfoViewController.h"
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
#import "GoodsInfoSecondViewController.h"
#import "SucceedPayViewController.h"
#import "OrderPayViewController.h"
#import "GSMyOrderPayController.h"
#import "MBProgressHUD.h"
#import "GSChackOutOrderViewController.h"
#import "GSChackOutOrderViewController.h"
#import "GSBusinessCarViewController.h"
@interface GoodsInfoViewController ()<UIScrollViewDelegate,ImagesScrollViewDelegate>

{
    UIScrollView * _scrollView;
    NSInteger contentHeight;
    UIView * downView;
    UIScrollView * showView;
    
    BOOL isSelected;
    BOOL end;
    BOOL is_down;
    BOOL is_setAttr;
    BOOL is_buyNow;
    NSInteger addCart;
    
    UIView  * _goodsList;
    
    UIButton * selectButton;
    
    UIView * transparentView;
    
    UILabel * countLabel;
    UILabel * priceLabel1;
    NSInteger goodsCount;
    CGFloat goodsPrice;
    NSInteger backViewHight;
    NSInteger cartCount;
    
    NSMutableString * goods_attr_desc;
    NSMutableString * goods_desc;
    NSMutableString * attr_id;
    NSMutableString * type;
    NSString * rec_id;
    
    NSMutableArray * attrArray;
    NSMutableArray * bestArray;
    NSMutableArray * hotArray;
    NSMutableArray * tempArray;
    
    NSMutableDictionary *shopDic; //存放商品对应的商家信息
    
    UIButton * backButton;
    UIButton * cartButton;
    UIButton * menuButton;
    
    float temp;
    NSString *image_name_Url;
    NSMutableDictionary *addressDic;
    
    UIButton * buyButton; //立即购买
   
    
}
@property (nonatomic, strong)UILabel *badgeLabel;

@end

//#define SHAREURL @"http://m.ibg100.com/index.php?m=default&c=goods&a=index&id="

@implementation GoodsInfoViewController

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        //徽标
        _badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width/2-25, Height-60, 24, 24)];
        _badgeLabel.backgroundColor = NewRedColor;
        _badgeLabel.layer.cornerRadius = 12;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.hidden = YES;
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_badgeLabel];
    }
    return _badgeLabel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self carCountData];
}


//购物车数量
- (void)carCountData {
    if (UserId ) {
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:URLDependByBaseURL(@"/Api/RepositoryCart/SumUserCartSingleGoods") parameters:@{@"token":[ @{@"shop_id":GS_Business_Shop_id,@"goods_id":_goodId} paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
            NSInteger goods_car_count  = [[[responseObject objectForKey:@"result"] objectForKey:@"total_num"] integerValue];
            if (goods_car_count == 0 ) {
                weakSelf.badgeLabel.hidden = YES;
            } else {
                weakSelf.badgeLabel.hidden = NO;
                weakSelf.badgeLabel.text = [NSString stringWithFormat:@"%ld",goods_car_count];
                           }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    contentHeight = Width+300;
    
    self.view.backgroundColor = MyColor;
    isSelected = NO;
    is_down = NO;
    is_setAttr = NO;
    
    goodsCount = 1;
    cartCount  = 0;
    
    _dataArray = [[NSMutableArray alloc]init];
    _picArray = [[NSMutableArray alloc]init];
    attrArray = [[NSMutableArray alloc]init];
    bestArray = [[NSMutableArray alloc]init];
    hotArray = [[NSMutableArray alloc]init];
    tempArray = [[NSMutableArray alloc]init];
    shopDic = [[NSMutableDictionary alloc]init];
    addressDic = [[NSMutableDictionary alloc]init];

    [self dataInit];
}

-(void)dataInit{
//    NSLog(@"%@",_goodId);
    
//        NSLog(@"%@",UserId);
    NSString *urlstr;
    if (_incomStyle == 0) {
        urlstr = URLDependByBaseURL(@"/Api/Shop/ShopProductView");
    }else {
        urlstr = URLDependByBaseURL(@"/Api/Repository/GoodsDetail");
    }
    
    
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:[[UIApplication sharedApplication].delegate window]];

    if (_goodId) {
        __weak typeof(self) weakSelf = self;
    [HttpTool POST:urlstr parameters:@{@"token":[@{@"goods_id":_goodId} paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
//            NSLog(@"商品详情请求数据：%@",[responseObject objectForKey:@"message"]);
                NSInteger status = [responseObject[@"status"] integerValue];
            if ( status ==2 || status == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[responseObject objectForKey:@"message"]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
                
            }else if( status == 0 ){   //等于1 接口返回数据成
        
                NSDictionary *dic = responseObject[@"result"];
                goods_attr_desc = responseObject[@"result"][@"goods_attr_desc"];
                goods_desc = responseObject[@"result"][@"goods_desc"];
                GoodsDetailModel * model = [[GoodsDetailModel alloc]initWithDictionary:dic error:nil];
                [_dataArray addObject:model];
                
                shopDic = responseObject[@"result"][@"shop_info"];  //存放商品对应得商家信息。
                //大图图片
                image_name_Url = responseObject[@"result"][@"original_img"];
                
                for (NSDictionary * dic1 in responseObject[@"result"][@"pictures"]) {
                    [_picArray addObject:dic1[@"img_url"]];
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
                
                [weakSelf createUI];
            }
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];

        } failure:^(NSError *error) {
            
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];

        }];
    
        
    }else {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
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
    cartButton = [[UIButton alloc]initWithFrame:CGRectMake(Width-40, 20, 30, 30)];
    [cartButton setBackgroundImage:[UIImage imageNamed:@"gouwuche1-1"] forState:UIControlStateNormal];
    cartButton.tag = 22;
    [cartButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cartButton];

    
    
    //底部立即购买按钮
    buyButton = [[UIButton alloc]initWithFrame:CGRectMake(Width/2, Height-44, Width/2, 44)];
    buyButton.backgroundColor = NewRedColor;
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    buyButton.tag = 26;
    [buyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
   

    UIButton * addToButton = [[UIButton alloc]initWithFrame:CGRectMake(0, Height-44, Width/2, 44)];
    addToButton.tag = 25;
    addToButton.backgroundColor = [UIColor colorWithRed:252/255.0 green:168/255.0 blue:44/255.0 alpha:1];
    [addToButton setTitle:@"加入进货单" forState:UIControlStateNormal];
    [addToButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addToButton];
    
    //轮播图
    ImagesScrollView * adSC = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Width)];
    adSC.backgroundColor = [UIColor whiteColor];
    adSC.isLoop = NO;
    adSC.placeholderImage = [UIImage imageNamed:@"ic_load_image_pleaceholder"];
    adSC.autoScrollInterval = 10000000;
    adSC.delegate = self;
//    [adSC setImageViewContentMode:UIViewContentModeScaleAspectFit];
    [_scrollView addSubview:adSC];
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Width, Width, 200)];
    contentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:contentView];
    
    //商品标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Width-20, 40)];
    titleLabel.text = [_dataArray[0] goods_name];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:titleLabel];
    
    //商品描述
    UILabel * goodsBriefLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, Width-20, 30)];
    goodsBriefLabel.text = [_dataArray[0] goods_brief];
    goodsBriefLabel.numberOfLines = 0;
    goodsBriefLabel.textColor = [UIColor grayColor];
    goodsBriefLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:goodsBriefLabel];
    
    //进货价
    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 300, 30)];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.textColor = [UIColor redColor];
    priceLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:priceLabel];
    if (_incomStyle == 0) {
        priceLabel.text = [NSString stringWithFormat:@"进货价：%@",[_dataArray[0] shop_price]];
    }else {
    priceLabel.text = [NSString stringWithFormat:@"进货价：%@",[_dataArray[0] purchase_price]];
    }
    
    //市场价
    UILabel * ppLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 150, 30)];
    ppLabel.text = [NSString stringWithFormat:@"市场价:%@",[_dataArray[0] market_price]];
//    NSLog(@"%@",ppLabel.text);
    ppLabel.font = [UIFont boldSystemFontOfSize:13];
    ppLabel.tag = 9;
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",ppLabel.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    ppLabel.attributedText = newPrice;
    ppLabel.textColor = [UIColor grayColor];
    [contentView addSubview:ppLabel];
    
    selectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, Width, 30)];
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
#pragma mark- 修改 --------------------------------------------------------------------------------------------
  /*
//    _goodsList = [[UIView alloc]initWithFrame:CGRectMake(0, Width+100, Width, 215)];
//    //        _goodsList.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1];
//    _goodsList.backgroundColor = [UIColor whiteColor];
//    [_scrollView addSubview:_goodsList];
//    
//    
//    //由商家版进入界面
//    
//    //商店信息View
//    UIView * shopView = [[UIView alloc]init];
//    shopView.backgroundColor = [UIColor whiteColor];
//    [_goodsList addSubview:shopView];
//    
//    //头像
//    UIImageView *headerImgV = [[UIImageView alloc]init];
//    headerImgV.layer.cornerRadius = 20;
//    headerImgV.clipsToBounds = YES;
//    //    [headerImgV sd_setImageWithURL:[NSURL URLWithString:[shopDic objectForKey:@"shoplogo"]]];
//    [headerImgV setImageWithURL:[NSURL URLWithString:[shopDic objectForKey:@"shoplogo"]]];
//    [shopView addSubview:headerImgV];
//    
//    //商店名字label
//    UILabel *shopNameLabel = [[UILabel alloc]init];
//    shopNameLabel.text = [shopDic objectForKey:@"shop_title"];
//    shopNameLabel.font = [UIFont systemFontOfSize:13];
//    shopNameLabel.textColor = [UIColor grayColor];
//    [shopView addSubview:shopNameLabel];
//    
//    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 124, Width, 1)];
//    line2.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1];
//    [shopView addSubview:line2];
//    
//    [shopView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_goodsList.mas_top).with.offset(10);
//        make.left.mas_equalTo(_goodsList.mas_left);
//        make.width.mas_equalTo(_goodsList.mas_width);
//        make.height.mas_equalTo(125);
//    }];
//    
//    [headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(shopView.mas_top).with.offset(5);
//        make.left.mas_equalTo(shopView.mas_left).with.offset(10);
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(40);
//        
//    }];
//    
//    [shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(shopView.mas_top).with.offset(5);
//        make.left.mas_equalTo(headerImgV.mas_right).with.offset(10);
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(30);
//        
//    }];
//    
//    
//    NSInteger itemWidth = (Width-40)/3;
//    NSArray *arr = @[@"全部宝贝",@"新上宝贝",@"关注人数"];
//    
//    NSArray *arr2 = @[[shopDic objectForKey:@"goods_num"],[shopDic objectForKey:@"new_num"],[shopDic objectForKey:@"goods_num"]];
//    for (int i=0; i<3; i++) {
//        
//        //titlelabel
//        UILabel *titleLabel = [[UILabel alloc]init];
//        titleLabel.text = arr[i];
//        titleLabel.font = [UIFont systemFontOfSize:13];
//        titleLabel.textColor = [UIColor grayColor];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        [shopView addSubview:titleLabel];
//        
//        //numberLabel
//        UILabel *numberLabel = [[UILabel alloc]init];
//        numberLabel.text = arr2[i];
//        numberLabel.font = [UIFont systemFontOfSize:13];
//        numberLabel.textColor = [UIColor grayColor];
//        numberLabel.textAlignment = NSTextAlignmentCenter;
//        [shopView addSubview:numberLabel];
//        
//        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.mas_equalTo(headerImgV.mas_bottom).with.offset(5);
//            make.left.mas_equalTo(headerImgV.mas_left).with.offset(i*itemWidth);
//            make.width.mas_equalTo(itemWidth);
//            make.height.mas_equalTo(30);
//            
//        }];
//        
//        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(numberLabel.mas_bottom);
//            make.left.mas_equalTo(headerImgV.mas_left).with.offset(i*itemWidth);
//            make.width.mas_equalTo(itemWidth);
//            make.height.mas_equalTo(30);
//        }];
//        
//        
//        if (i != 2) {
//            //
//            UIImageView *imageV = [[UIImageView alloc]init];
//            imageV.image = [UIImage imageNamed:@"xuxian"];
//            [shopView addSubview:imageV];
//            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(numberLabel.mas_top).offset(3);
//                make.right.equalTo(titleLabel.mas_right).offset(5);
//                make.bottom.equalTo(titleLabel.mas_bottom).offset(-3);
//                make.width.equalTo(@1);
//            }];
//            
//            
//        }
//        
//    }
//    
//    NSMutableAttributedString *promptLab = [[NSMutableAttributedString alloc]initWithString:@"继续滑动查看图文详情"];
//    [promptLab addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
//    UILabel *lab = [[UILabel alloc]init];
//    lab.attributedText = promptLab;
//    [shopView addSubview:lab];
//    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(shopView.mas_bottom).offset(30);
//        make.centerX.equalTo(shopView.mas_centerX);
//        make.height.equalTo(@30);
//    }];
//    lab.font = [UIFont systemFontOfSize:14];
//    
   */
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    GoodsInfoSecondViewController * dvc = [[GoodsInfoSecondViewController alloc]init];
    dvc.hidesBottomBarWhenPushed = YES;
    dvc.recommendArray = bestArray;
    dvc.goods_id = _goodId;
    dvc.attr_id = [_dataArray[0] attr_id];
    dvc.is_exchange = [NSString stringWithFormat:@"%@",[_dataArray[0] is_exchange]];
    dvc.goods_desc = goods_desc;
    dvc.goods_attr_desc = goods_attr_desc;
    dvc.dataArray = _dataArray;
    dvc.tempArray = tempArray;
    [self addChildViewController:dvc];

    if (dvc.view != nil) {
        _scrollView.secondScrollView = dvc.scrollView;
    }
    
    //将badgeLabel放到view的最前面 避免遮挡
    [self.view bringSubviewToFront:self.badgeLabel];

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
    
    NSString *baseimageurl = @"http";
    if ([image_name_Url rangeOfString:baseimageurl].location == NSNotFound) {
        image_name_Url = [NSString stringWithFormat:@"%@%@",ImageBaseURL,image_name_Url];
    }
    
    [icon sd_setImageWithURL:[NSURL URLWithString:image_name_Url]];
    [transparentView addSubview:icon];
    
    priceLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 150, 20)];
    [backView addSubview:priceLabel1];
    if (attrArray.count != 0) {
        goodsPrice = [[attrArray[0] purchase_price]floatValue];
        priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",goodsPrice];
    }else{
        goodsPrice = [[_dataArray[0] purchase_price]floatValue];
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
            [typeButton addTarget: self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
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
    certainButton.frame = CGRectMake(Width/2+40, backViewHight-60, 70, 40);
    [certainButton setTitle:@"确定" forState:UIControlStateNormal];
    certainButton.tag = 3;
    certainButton.layer.cornerRadius = 8;
    certainButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
    [certainButton addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:certainButton];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(Width/2-110, backViewHight-60, 70, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.tag = 5;
    cancelButton.layer.cornerRadius = 8;
    cancelButton.backgroundColor = [UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1];
    [cancelButton addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelButton];
    
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
    
    if (_scrollView.contentOffset.y >800) {
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



-(void)buttonClick:(UIButton *)button{
    
//    NSString * is_exchange = [NSString stringWithFormat:@"%@",[_dataArray[0] is_exchange]];
//    GoodsInfoViewController * gsvc = [[GoodsInfoViewController alloc]init];
//    MoneyViewController * mvc = [[MoneyViewController alloc]init];
    GSNewLoginViewController * Lvc = [[GSNewLoginViewController alloc]init];
//    GBOrderViewController * gbvc = [[GBOrderViewController alloc]init];
    switch (button.tag) {
        case 10:
            
            if (_incomStyle == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该界面不能购买商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }

            
            is_buyNow = NO;
            [self createView];
            break;
            
        case 21://返回
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 22: {
//            self.tabBarController.selectedIndex = 2;
            
            GSBusinessCarViewController *carView = [[GSBusinessCarViewController alloc]init];
            [self.navigationController pushViewController:carView animated:YES];
            
            
        }
            break;

//            case 23://下拉菜单
//            is_down = !is_down;
//            if (is_down) {
//                [self createDownView];
//            }else{
//                [downView removeFromSuperview];
//            }
//            break;
            
          //加入进货单
        case 25: {
            
            
            if (_incomStyle == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该界面不能购买商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }

            
            if (UserId) {
                
                is_buyNow = NO;
                
                [self createView];
                
            }else {
                Lvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:Lvc animated:YES];
            }
        }
            break;

        case 26://立即购买
            
            
            if (_incomStyle == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该界面不能购买商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }
            
            [transparentView removeFromSuperview];
            
            if (UserId) {
                
                is_buyNow = YES;
                [self createView];
                

            }else{
                Lvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:Lvc animated:YES];
                
            }
            break;
            
        default:
            break;
    }
}
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
    
    if (_picArray.count > 0) {
        NSString *urlStr = _picArray[index];
        
        NSString *subStr = [urlStr substringToIndex:4];
        if ([subStr isEqualToString:@"http"]) {
            return _picArray[index];
        }else {
            NSString *urlStr = [NSString stringWithFormat:@"http://www.ibg100.com/%@",_picArray[index]];
            return urlStr;
        }
    }else {
        if (image_name_Url.length > 0) {
            
            NSString *subStr = [image_name_Url substringToIndex:4];
            if ([subStr isEqualToString:@"http"]) {
                return image_name_Url;
            }else {
                return [NSString stringWithFormat:@"http://www.ibg100.com/%@",image_name_Url];
            }
        }
    }
    return nil;
    //    NSString * urlStr = [NSString stringWithFormat:@"http://www.ibg100.com%@",_picArray[index]];
}

//选择商品属性按钮点击事件
-(void)btnClick:(UIButton *)button{
    
    GSNewLoginViewController * Lvc = [[GSNewLoginViewController alloc]init];

    switch (button.tag) {
        case 1:
            //减号
            if (goodsCount>=1) {
                goodsCount --;
                temp = goodsCount * goodsPrice;
                countLabel.text = [NSString stringWithFormat:@"%ld",(long)goodsCount];
                priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",temp];
            }
            break;
        case 2:
            //加号
            goodsCount ++;
            temp = goodsCount * goodsPrice;
            countLabel.text = [NSString stringWithFormat:@"%ld",(long)goodsCount];
            priceLabel1.text = [NSString stringWithFormat:@"￥%.2f",temp];
            break;
            
            //确定
        case 3:
        {
            temp = goodsCount * goodsPrice;
            if (UserId) {
                
                [self addToCard];
                
            }else {
                
                [self.navigationController pushViewController:Lvc animated:YES];
            }
        }
            break;
        case 5:
            //取消
            [transparentView removeFromSuperview];
            goodsCount = 1;
            break;
            
        default:
            break;
    }
}

//添加商品到进货单
- (void)addToCard {
    
    NSDictionary *dic = @{@"shop_id":GS_Business_Shop_id,
                          @"goods_id":_goodId,
                          @"num":[NSString stringWithFormat:@"%ld",goodsCount]};
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/RepositoryCart/new_add_cart") parameters:@{@"token":[dic paramsDictionaryAddSaltString]} success:^(id responseObject) {
      
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 2 && !is_buyNow)  {
            
            
            [weakSelf carCountData];
        }
        
        //立即购买
        if ([[responseObject objectForKey:@"status"] integerValue] == 2 && is_buyNow) {
            
            /*
            GSCarMoneyViewController *mvc = [[GSCarMoneyViewController alloc]init];
            mvc.tokenStr = [responseObject objectForKey:@"result"];
            mvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mvc animated:YES];
            */
            GSChackOutOrderViewController *chackOutOrder = ViewController_in_Storyboard(@"Main", @"GSChackOutOrderViewController");
            chackOutOrder.chackOutOrderType = GSChackOutOrderTypeBusiness;
            chackOutOrder.hidesBottomBarWhenPushed = YES;
            chackOutOrder.tokenStr = [responseObject objectForKey:@"result"];
            [weakSelf.navigationController pushViewController:chackOutOrder animated:YES];

            
        }else {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [transparentView removeFromSuperview];
      
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)addAlertViewWithStr:(NSString *)str {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"提示" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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
            self.tabBarController.selectedIndex = 0;
            [downView removeFromSuperview];
            is_down = NO;
            break;
            
        default:
            break;
    }
}


@end


