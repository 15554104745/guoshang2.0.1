//
//  HomeHeaderCell.m
//  home
//
//  Created by 宗丽娜 on 16/2/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "HomeHeaderCell.h"
#import "HomeModel.h"
//#import "GoodsShowViewController.h"
#import "GoodsViewController.h"
//#import "LimitViewController.h"
#import "SearchResultViewController.h"
#import "YGViewController.h"
#import "ShoppingViewController.h"
#import "SpecialSaleViewController.h"
#import "MySideViewController.h"
#import "GSBusinessHomeViewController.h"
#import "GSNearbyShopListViewController.h"
#import "GSNearbyStoreListViewController.h"
#import "GoodsListViewController.h"
#import "ShopBasicViewController.h"

#import "GSNewBaseLimiteController.h"

#define HEADPOD (self.frame.size.width- 20)/3.0
@implementation HomeHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        [self createUI];
        
        
        
        
    }
    return self;
}
-(NSArray *)setArray{
    
    if (_setArray == nil) {
        NSMutableArray * arr = [NSMutableArray array];
        _setArray = [NSArray array];
        
        NSArray * aa = @[@"yigoushop",@"易购商城",@"YGViewController"];
        [arr addObject:aa];
        
        NSArray * bb = @[@"guobishop",@"国币商城",@"ShoppingViewController"];
        [arr addObject:bb];
        
        NSArray * cc = @[@"seshop",@"特卖商城",@"SpecialSaleViewController"];
        [arr addObject:cc];
        
        NSArray * dd = @[@"myside",@"身边门店",@"StoreListViewController"];
        
        [arr addObject:dd];
        
        
        _setArray = arr;
    }
    
    return _setArray;
}

-(void)setLimitArray:(NSArray *)limitArray{
    
    _limitArray = limitArray;
    [self setttingLimitData];
}


-(void)setttingLimitData{
    for (NSInteger i  = 0; i < 4; i++) {
        
        if (i < _limitArray.count) {
            HomeModel * model = _limitArray[i];
            UIButton * btn = (UIButton *)[self viewWithTag:5040 + i];
            [btn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
//            NSLog(@"图片数据%@",model.goods_img);
            UILabel * priceTitle = (UILabel *)[self viewWithTag:5050 + i];
            priceTitle.text = model.promote_price;
            
            UILabel * otherTitle = (UILabel *)[self viewWithTag:5060 + i];
            otherTitle.text = model.shop_price;
            
            btn.hidden = NO;
            priceTitle.hidden = NO;
            otherTitle.hidden = NO;
            [self viewWithTag:6430 + i].hidden = NO;

            
        } else {
            UIButton * btn = (UIButton *)[self viewWithTag:5040 + i];
            btn.hidden = YES;
            UILabel * priceTitle = (UILabel *)[self viewWithTag:5050 + i];
            priceTitle.hidden = YES;
            UILabel * otherTitle = (UILabel *)[self viewWithTag:5060 + i];
            otherTitle.hidden = YES;
            [self viewWithTag:6430 + i].hidden = YES;
        }
        
        
    }
    
    
}
-(void)createUI{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _View = view;
    _View.backgroundColor = MyColor;
    _View.userInteractionEnabled = YES;
    [self addSubview:_View];
    
    ImagesScrollView * sc = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
    sc.isLoop = YES;
    sc.placeholderImage = [UIImage imageNamed:@"设置"];
    sc.autoScrollInterval = 2;
    sc.placeholderImage = [UIImage imageNamed:@"ic_load_image_pleaceholder"];
    sc.delegate = self;
    [_View addSubview:sc];
    
    
    //商城代码
    NSInteger count = 4;
    CGFloat  oneXpace = 10;
    CGFloat xSpace = (self.bounds.size.width - 50 * 4 - 20) / 3;
//    NSLog(@"间隙%f",xSpace);
    for (NSInteger i = 0 ; i < 4; i++) {
        NSArray * array = self.setArray[i];
        if (i == 0) {
            
            LNButton * btn = [LNButton buttonWithFrame:CGRectMake(15+(i%count)*(oneXpace+50), 160+(i/count)*(xSpace+50 + 20), 50, 50)Type:UIButtonTypeCustom Title:nil TitleColor:nil Font:14.0f BackgroundImage:array[0] andBlock:^(LNButton *button) {
                ShopBasicViewController *shopViewController = [[ShopBasicViewController alloc] init];
                shopViewController.title = @"易购商城";
                shopViewController.cat_id = @"0";
                shopViewController.hidesBottomBarWhenPushed = YES;
                [self.popView.navigationController pushViewController:shopViewController animated:YES];
            }];
            
            [_View addSubview:btn];
            
            LNLabel * lab = [LNLabel addLabelWithTitle:array[1] TitleColor:[UIColor redColor] Font:13.0f BackGroundColor: [UIColor clearColor]];
            lab.frame = CGRectMake(15+(i%count)*(oneXpace+50), 160 + 55+(i/count)*(xSpace+50 + 20), 60, 20);
            [_View addSubview:lab];
            
            
        } else {
            LNButton * btn = [LNButton buttonWithFrame:CGRectMake((i%count)*(xSpace+50), 160+(i/count)*(xSpace+50 + 20), 50, 50)Type:UIButtonTypeCustom Title:nil TitleColor:nil Font:14.0f BackgroundImage:array[0] andBlock:^(LNButton *button) {
                if (i == 3) {
                    
                    GSNearbyStoreListViewController *nearbyShopListViewController = ViewController_in_Storyboard(@"Main", @"nearbyStoreListViewController");
                    nearbyShopListViewController.hidesBottomBarWhenPushed = YES;
                    [self.popView.navigationController pushViewController:nearbyShopListViewController animated:YES];
                } else {
                    

                    UIViewController * contr = [[NSClassFromString(array[i])alloc]init];
              
                    [self.popView.navigationController pushViewController:contr animated:YES];

                }

            }];
            
            [_View addSubview:btn];
            UIColor * labelColor;
            switch (i) {
                case 0:{
                    labelColor = [UIColor colorWithRed:240/255.0 green:108/255.0 blue:108/255.0 alpha:1.0];
                }
                    
                    break;
                    
                case 1:{
                    labelColor = [UIColor colorWithRed:244/255.0 green:174/255.0 blue:53/255.0 alpha:1.0];
                }
                    
                    break;
                    
                case 2:{
                    labelColor = [UIColor colorWithRed:247/255.0 green:17/255.0 blue:25/255.0 alpha:1.0];
                }
                    
                    break;
                    
                case 3:{
                    labelColor = [UIColor colorWithRed:252/255.0 green:122/255.0 blue:49/255.0 alpha:1.0];
                }
                    
                    break;
                    
                default:
                    break;
            }
            
            LNLabel * lab = [LNLabel addLabelWithTitle:array[1] TitleColor:labelColor Font:13.0f BackGroundColor: [UIColor clearColor]];
            lab.frame = CGRectMake((i%count)*(xSpace+50), 160 + 55+(i/count)*(xSpace+50 + 20), 60, 20);
            lab.tag = 404040 + i;
            [_View addSubview:lab];
            
        }
    }
    
    UILabel * lab = (UILabel *)[self.View viewWithTag:404041];
    UIImageView * wire = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
    [_View addSubview:wire];
    [wire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).equalTo(@5);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
    
    
    //跳进限时抢购
    LNButton * secondBtn = [LNButton buttonWithFrame:CGRectMake(0, 0, 40, 20) Type:UIButtonTypeCustom Title:nil TitleColor:nil Font:14.0f BackgroundImage:@"zhanna" andBlock:^(LNButton *button) {
       GSNewBaseLimiteController * limit = [[GSNewBaseLimiteController alloc] init];
//        GoodsListViewController * limit = [[GoodsListViewController alloc] init];
        
        limit.hidesBottomBarWhenPushed = YES;
//        limit.informNum = 3;
//         [[NSUserDefaults standardUserDefaults] setObject:@3 forKey:@"listOrder"];
        [self.popView.navigationController pushViewController:limit animated:YES];
    }];
    [_View addSubview:secondBtn];
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wire.mas_bottom).equalTo(@10);
        make.right.equalTo(self.mas_right).equalTo(@-10);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    //爆款
    //
    
    LNLabel * goodsLb = [LNLabel addLabelWithTitle:@"爆款尖货轮番炒" TitleColor:WordColor Font:12.0f BackGroundColor: [UIColor clearColor]];
    [_View addSubview:goodsLb];
    [goodsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wire.mas_bottom).equalTo(@5);
        make.right.equalTo(secondBtn.mas_left).equalTo(@5);
        make.width.equalTo(@90);
        make.height.equalTo(@20);
    }];
    
    
    UIImageView * secondImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"miaosha"]];
    [_View addSubview:secondImage];
    [secondImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wire.mas_bottom).equalTo(@10);
        make.left.equalTo(self.mas_left).equalTo(@10);
        
    }];
    UIView * backView = [[UIView alloc] init];
    [_View addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondImage.mas_bottom).equalTo(@5);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
    
    
    
    //限时抢购页面
    NSInteger newcount = 4;
    CGFloat Space =10;
    CGFloat imageSize = (self.bounds.size.width - 50) / 4;
    for (NSInteger i = 0 ; i < 4; i++) {
        LNButton * btn = [LNButton buttonWithFrame:CGRectMake(Space+(i%newcount)*(Space+imageSize), 5+(i/newcount)*(Space+imageSize + 20), imageSize, imageSize)Type:UIButtonTypeCustom Title:nil TitleColor:nil Font:14.0f BackgroundImage:@"111" andBlock:^(LNButton *button) {
            
            HomeModel *homeModel = _limitArray[i];
            GoodsShowViewController *showViewController = [[GoodsShowViewController alloc] init];
            showViewController.goodId = homeModel.goods_id;
            if (_limitBtnClickBlock) {
                _limitBtnClickBlock(showViewController);
            }
            //                UIViewController * contr = [[NSClassFromString(array[2])alloc]init];
            //              [self.popView.navigationController pushViewController:contr animated:YES];
        }];
        btn.tag = 5040 + i;
        [backView addSubview:btn];
        
        LNLabel * lab = [LNLabel addLabelWithTitle:@"￥397.00" TitleColor:[UIColor redColor] Font:13.0f BackGroundColor: [UIColor clearColor]];
        lab.tag = 5050 + i;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.frame = CGRectMake(Space+(i%newcount)*(Space + imageSize), imageSize+ 8+(i/newcount)*(Space+imageSize + 20), imageSize, 20);
        [backView addSubview:lab];
        
        //原价
        LNLabel * otherLabel = [LNLabel addLabelWithTitle:@"￥397.00" TitleColor:[UIColor grayColor] Font:11.0f BackGroundColor:[UIColor clearColor]];
        otherLabel.tag = 5060 + i;
        otherLabel.textAlignment = NSTextAlignmentCenter;
        otherLabel.frame = CGRectMake(Space+(i%newcount)*(Space + imageSize), imageSize+ 30+(i/newcount)*(Space+imageSize + 20), imageSize, 20);
        [backView addSubview:otherLabel];
        //线
        LNLabel * wire = [LNLabel addLabelWithTitle:nil TitleColor:[UIColor grayColor] Font:11.0f BackGroundColor:[UIColor grayColor]];
        wire.frame = CGRectMake(Space+(i%newcount)*(Space + imageSize)+ 20, imageSize+ 40+(i/newcount)*(Space+imageSize + 20), imageSize - 35, 1);
        [backView addSubview:wire];
        wire.tag = 6430 + i;
        
        
    }
    
    
    UILabel * wireL = (UILabel *)[self viewWithTag:5060];
    
    UIImageView * goodsImage = [[UIImageView alloc] init];
    [_View addSubview:goodsImage];
    goodsImage.tag = 7070;
    [goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wireL.mas_bottom).equalTo(@5);
        make.left.equalTo(_View.mas_left);
        make.right.equalTo(_View.mas_right);
        make.height.equalTo(@65);
    }];
    
    UIImageView * titleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiatingriyong"]];
    [_View addSubview:titleImage];
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsImage.mas_bottom).equalTo(@5);
        make.left.equalTo(self.mas_left).equalTo(@((self.frame.size.width -215)/2));
        make.width.equalTo(@215);
        make.height.equalTo(@15);
    }];
    
}




-(void)setBannerArr:(NSMutableArray *)bannerArr{
    _bannerArr = bannerArr;

}


-(NSInteger)numberOfImagesInImagesScrollView:(ImagesScrollView *)imagesScrollView{
    return _bannerArr.count;
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    UIImageView * goodsImage = (UIImageView *)[self viewWithTag:7070];
//    NSLog(@"%@",_titleStr);
    [goodsImage setImageWithURL:[NSURL URLWithString:_titleStr] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    
}
//填充图片
-(NSString *)imagesScrollView:(ImagesScrollView *)imagesScrollView imageUrlStringWithIndex:(NSInteger)index{
    
    HomeModel * model = _bannerArr[index];
    
    return model.image_url;
    
}


//-(void)toPush:(UIButton *)button{
//
//    if (button.tag == 105) {
//        LimitViewController * limit = [[LimitViewController alloc] init];
//        limit.hidesBottomBarWhenPushed = YES;
//        [self.popView.navigationController pushViewController:limit animated:YES];
//
//    }else{
//
//        HomeModel * model = _otherArray[button.tag - 100];
//        NSLog(@"eeeee%@",model.type);
//        if ([model.type isEqualToString:@"goods_id"]){
//
//            GoodsShowViewController * goods = [[GoodsShowViewController alloc] init];
//            goods.goodId = model.params;
//            goods.hidesBottomBarWhenPushed = YES;
//            [self.popView.navigationController pushViewController:goods animated:YES];
//
//        } else if ([model.type isEqualToString:@"cat_id"]) {
//            GoodsViewController * good = [[GoodsViewController alloc] init];
//            good.hidesBottomBarWhenPushed = YES;
//            good.ID = model.params;
//            good.hidesBottomBarWhenPushed = YES;
//            [self.popView.navigationController pushViewController:good animated:YES];
//
//        }else if ([model.type isEqualToString:@"keywords"]){
//
//            //调到搜素页面;
//            SearchResultViewController * search = [[SearchResultViewController alloc] init];
//            search.words = model.params;
//            search.hidesBottomBarWhenPushed = YES;
//            [self.popView.navigationController pushViewController:search animated:YES];
//
//        }else if (model.type == nil){
//
//            NSLog(@"为空");
//        }
//
//    }
//}

-(void)imagesScrollView:(ImagesScrollView *)imagesScrollView didSelectIndex:(NSInteger)index{
    
//    NSLog(@"轮播图的跳转");
    //
}


@end
