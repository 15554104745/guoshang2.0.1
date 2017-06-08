//
//  GSHomeHeaderCollectionReusableView.m
//  guoshang
//
//  Created by Rechied on 16/8/5.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSHomeHeaderCollectionReusableView.h"
#import "GSNearbyStoreListViewController.h"
#import "ShopBasicViewController.h"
#import "GoodsViewController.h"
#import "GSHomeLimitCell.h"
#import "GSHomeLimitModel.h"
#import "UIColor+HaxString.h"

#import "GSNewBaseLimiteController.h"

#import "GSNewShopBaseViewController.h"
#import "GSGoodsDetailInfoViewController.h"
#import "GSNewPointShopViewController.h"

@implementation GSHomeHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    _weakView = view;
    _weakView.backgroundColor = [UIColor whiteColor];
    _weakView.userInteractionEnabled = YES;
    [self addSubview:_weakView];
    
    self.banner = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (Width * 300.0f)/750.0f)];
//    _banner.isLoop = YES;
//    _banner.autoScrollInterval = 2;
//    _banner.contentMode = UIViewContentModeScaleAspectFill;
    _banner.placeholderImage = [UIImage imageNamed:@"ic_load_image_pleaceholder"];
    _banner.delegate = self;
    [_weakView addSubview:_banner];
    
    [self setupToolBar];
    [self setupLimitModule];
}

- (void)setupToolBar {
    
    _toolView = [[UIView alloc] init];
    [_weakView addSubview:_toolView];
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(_banner.mas_bottom).offset(0);
        make.height.offset(90.0f);
    }];
    
    NSArray *toolArray =
  @[@[@"icon_home_yigouShop",@"易购商城",@"GSNewShopBaseViewController"],
  @[@"icon_home_guobiShop",@"国币商城",@"GSNewPointShopViewController"],
  @[@"icon_home_hotShop",@"限时抢购",@"GSNewBaseLimiteController"],
  @[@"icon_home_nearbyShop",@"身边门店",@"MyGSViewController"]];
    //NSArray *colorArray = @[[UIColor colorWithRed:240/255.0 green:108/255.0 blue:108/255.0 alpha:1.0],[UIColor colorWithRed:244/255.0 green:174/255.0 blue:53/255.0 alpha:1.0],[UIColor colorWithRed:247/255.0 green:17/255.0 blue:25/255.0 alpha:1.0],[UIColor colorWithRed:252/255.0 green:122/255.0 blue:49/255.0 alpha:1.0]];
    __weak typeof(self) weakSelf = self;
    __block UIView *lastView = nil;
    [toolArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *tempView = [[UIView alloc] init];
        [_toolView addSubview:tempView];
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            if (!lastView) {
                make.left.offset(10);
            } else {
                make.left.equalTo(lastView.mas_right).offset(10);
                make.width.equalTo(lastView.mas_width);
            }
            
            if (obj == [toolArray lastObject]) {
                make.right.offset(-10);
            }
            
            lastView = tempView;
        }];

        LNButton *button = [LNButton buttonWithType:UIButtonTypeCustom Title:nil TitleColor:nil Font:0 image:toolArray[idx][0] andBlock:^(LNButton *button) {
            
            if (weakSelf.pushBlock) {
                UIViewController *viewController = [[NSClassFromString(obj[2]) alloc] init];
                viewController.hidesBottomBarWhenPushed = YES;
                weakSelf.pushBlock(viewController);
                
//                if (idx == 0) {
//                    GoodsViewController *shopBusicViewController = [[GoodsViewController alloc] init];
//                    shopBusicViewController.hidesBottomBarWhenPushed = YES;
//                    shopBusicViewController.ID = @"0";
//                    shopBusicViewController.title = @"易购商城";
//                    weakSelf.pushBlock(shopBusicViewController);
//                } else if (idx == 3) {
//                    GSNearbyStoreListViewController *nearbyShopListViewController = ViewController_in_Storyboard(@"Main", @"nearbyStoreListViewController");
//                    weakSelf.pushBlock(nearbyShopListViewController);
//                    
//                } else {
//                    UIViewController *viewController = [[NSClassFromString(obj[2]) alloc] init];
//                    weakSelf.pushBlock(viewController);
//                }
            }
        }];
        [tempView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_offset(0);
        }];
    }];
    
}

- (void)setupLimitModule {
    
    UIView *limitModuleView = [[UIView alloc] init];
    [_weakView addSubview:limitModuleView];
    
    
    //
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [limitModuleView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.offset(10);
    }];
    
    
    UIView *topView = [[UIView alloc] init];
    [limitModuleView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(line.mas_bottom).offset(0);
        make.height.offset(50.0f);
    }];
    
    UIImage *image = [UIImage imageNamed:@"miaosha"];
    
    UIImageView *limitIcon = [[UIImageView alloc] initWithImage:image];
    [topView addSubview:limitIcon];
    
    [limitIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17.5f);
        make.centerY.offset(0);
        //make.size.sizeOffset(image.size);
        //make.bottom.offset(-10);
    }];
    
    LNLabel *label = [LNLabel addLabelWithTitle:@"查看更多 >" TitleColor:[UIColor colorWithHexString:@"8f8f8f"] Font:11 BackGroundColor:[UIColor clearColor]];
    [topView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.right.equalTo(icon.mas_left).offset(-2);
        make.right.offset(-17.5);
        make.centerY.equalTo(topView.mas_centerY);
    }];
    
    LNButton *topButton = [LNButton buttonWithType:UIButtonTypeSystem Title:@"" TitleColor:nil Font:0 image:nil andBlock:^(LNButton *button) {
        if (_pushBlock) {
            GSNewBaseLimiteController *limitViewController = [[GSNewBaseLimiteController alloc] init];
            limitViewController.hidesBottomBarWhenPushed = YES;
            _pushBlock(limitViewController);
        }
    }];
    
    [topView addSubview:topButton];
    [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
    
    
    
    _limitContentView = [[UIView alloc] init];
    [limitModuleView addSubview:_limitContentView];
    [_limitContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(0);
        make.height.offset(112.5*(Height/667.0));
        make.left.right.mas_offset(0);
    }];
    
    [limitModuleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(_toolView.mas_bottom).offset(0);
        make.bottom.equalTo(_limitContentView.mas_bottom);
    }];
    
//    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_limit_jt"]];
//    [topView addSubview:icon];
//    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset(-8);
//        make.centerY.equalTo(topView.mas_centerY).offset(-1);
//    }];
    
    
    
    __block GSHomeLimitCell *lastCell = nil;
    for (NSInteger i = 0; i < 4; i ++) {
        GSHomeLimitCell *limitCell = [[GSHomeLimitCell alloc] init];
        //limitCell.backgroundColor = [UIColor orangeColor];
        limitCell.hidden = YES;
        limitCell.tag = 100 + i;
        
        limitCell.clickBlock = ^(GSHomeLimitModel *limitModel) {
            GSGoodsDetailInfoViewController *showViewController = [[GSGoodsDetailInfoViewController alloc] init];
            showViewController.hidesBottomBarWhenPushed = YES;
            showViewController.recommendModel = limitModel;
            
            if (_pushBlock) {
                _pushBlock(showViewController);
            }
            
        };
        
        [_limitContentView addSubview:limitCell];
        [limitCell mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!lastCell) {
                make.left.offset(17.5);
            } else {
                make.left.equalTo(lastCell.mas_right).offset(22.5);
                make.width.equalTo(lastCell.mas_width);
            }
            
            if (i == 3) {
                make.right.offset(-17.5);
                
            }
            
            make.top.offset(0);
            
            make.bottom.offset(0);
            
            lastCell = limitCell;
            
        }];
        
    }
    
}

- (void)setBannerArray:(NSArray *)bannerArray {
    _bannerArray = bannerArray;
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    [bannerArray enumerateObjectsUsingBlock:^(GSBannerModel * _Nonnull bannerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageArray addObject:bannerModel.image_url];
    }];
    [_banner setImageArray:imageArray];
    //[_banner reloadData];
}

- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index {
    if (self.bannerBlock) {
        GSBannerModel *bannerModel = self.bannerArray[index];
        self.bannerBlock(bannerModel.goto_url);
    }
}


- (void)setLimitArray:(NSArray *)limitArray {
    _limitArray = limitArray;
    for (NSInteger i = 0; i < 4; i ++ ) {
        GSHomeLimitCell *limitCell = [_limitContentView viewWithTag:100+i];
        if (i < limitArray.count) {
            GSHomeLimitModel *limitModel = limitArray[i];
            limitCell.hidden = NO;
            limitCell.limitModel = limitModel;
        } else {
            limitCell.hidden = YES;
        }
    }
}




@end
