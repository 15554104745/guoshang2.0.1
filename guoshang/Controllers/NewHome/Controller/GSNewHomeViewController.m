//
//  GSNewHomeViewController.m
//  guoshang
//
//  Created by Rechied on 16/8/5.
//  Copyright © 2016年 hi. All rights reserved.
//


#import "GSNewHomeViewController.h"

#import "UIColor+HaxString.h"

#import "GSHomeHeaderCollectionReusableView.h"
#import "GSCustomIconAndTitleButton.h"
#import "GSStoreDetailCollectionFlowViewCell.h"
#import "GSHomeCollectionViewCell.h"
#import "RequestManager.h"

#import "GoodsShowViewController.h"
#import "GoodsDetailViewController.h"

#import "SearchViewController.h"
#import "GSCaptureScanViewController.h"

#import "GSHomeLimitModel.h"
#import "GSHomeRecommendModel.h"
#import "GSHomeCollectionCellModel.h"
#import "MBProgressHUD.h"

#import "GSGoodsDetailInfoViewController.h"
#import "GSActivityManager.h"

typedef NS_ENUM(NSInteger, RefreshType) {
    RefreshTypeClear = 0,
    RefreshTypeAdd,
};

static NSString * homeColleciontViewCellID = @"homeCollectionViewCell";

@interface GSNewHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,GSHomeCollectionViewCellDelegate>
{
    
    UIButton * _searchBtn;
}
@property (strong, nonatomic) UIView *navView;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) GSHomeHeaderCollectionReusableView *header;

@property (strong, nonatomic) NSMutableArray *recommendArray;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@property (strong, nonatomic) NSMutableDictionary *sizeDictionary;

@property (assign, nonatomic) BOOL footerReady;
@end

@implementation GSNewHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self refreshDataWithRefreshType:RefreshTypeClear];
}


- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.navView];
}

- (NSMutableArray *)recommendArray {
    if (!_recommendArray) {
        _recommendArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _recommendArray;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}

- (NSMutableDictionary *)sizeDictionary {
    if (!_sizeDictionary) {
        _sizeDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _sizeDictionary;
}

- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 64)];
        _navView.backgroundColor = [UIColor colorWithHexString:@"e42144" alpha:1];
        UIFont *font = [UIFont systemFontOfSize:10];
        UIColor *color = [UIColor whiteColor];
        
        // 扫一扫
        __weak typeof(self) weakSelf = self;
        GSCustomIconAndTitleButton *scanButton = [[GSCustomIconAndTitleButton alloc] initWithIcon:[UIImage imageNamed:@"saoyisao"] title:@"扫啊扫" titleColor:color titleFont:font];
        scanButton.clickBlock = ^{
            GSCaptureScanViewController *scanViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"captureScanViewController"];
            [weakSelf.navigationController pushViewController:scanViewController animated:YES];
        };
        [_navView addSubview:scanButton];
        [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.bottom.offset(-5);
            make.width.height.mas_offset(35);
        }];
        
        //消息
        GSCustomIconAndTitleButton *messageButton = [[GSCustomIconAndTitleButton alloc] initWithIcon:[UIImage imageNamed:@"news"] title:@"消息" titleColor:color titleFont:font];
        messageButton.clickBlock = ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该功能正在施工中,敬请期待!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
        };
        [_navView addSubview:messageButton];
        [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.bottom.offset(-5);
            make.width.height.mas_offset(35);
        }];
        
        UIView *searchView = [[UIView alloc] init];
        searchView.layer.cornerRadius = 16.5;
        searchView.layer.masksToBounds = YES;
        searchView.backgroundColor = [UIColor colorWithHexString:@"fefefe" alpha:0.8];
        [_navView addSubview:searchView];
        [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(scanButton.mas_right).offset(10);
            make.right.equalTo(messageButton.mas_left).offset(-10);
            make.height.offset(33);
            make.centerY.offset(10);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home_magnifyingGlass"]];
        [searchView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(searchView.mas_centerY);
        }];
        
        LNLabel *label = [LNLabel addLabelWithTitle:@"搜索关键字" TitleColor:[UIColor colorWithHexString:@"656565"] Font:13 BackGroundColor:[UIColor clearColor]];
        [searchView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(imageView.mas_centerY);
        }];
        
        LNButton *searchButton = [LNButton buttonWithType:UIButtonTypeSystem Title:@"" TitleColor:nil Font:0 image:nil andBlock:^(LNButton *button) {
            SearchViewController *search = [[SearchViewController alloc] init];
            [weakSelf.navigationController pushViewController:search animated:YES];
        }];
        [searchView addSubview:searchButton];
        [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_offset(0);
        }];
    }
    return _navView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, Width, Height - 49) collectionViewLayout:layOut];
        [_collectionView registerClass:[GSHomeHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"recommendHeader"];
        [_collectionView registerNib:[UINib nibWithNibName:@"GSHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:homeColleciontViewCellID];
        [_collectionView registerNib:[UINib nibWithNibName:@"GSStoreDetailCollectionFlowViewCell" bundle:nil] forCellWithReuseIdentifier:@"storeGoodsCollectionViewCell"];
        [self.view addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.collectionView.mj_footer resetNoMoreData];
            [weakSelf refreshDataWithRefreshType:RefreshTypeClear];
        }];
        
        
    }
    
    return _collectionView;
}


- (void)refreshDataWithRefreshType:(RefreshType)refreshType {
    __weak typeof(self) weakSelf = self;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"10" forKey:@"amount"];
        if (refreshType != RefreshTypeClear) {
            [params setObject:[NSString stringWithFormat:@"%zi",self.recommendArray.count] forKey:@"last"];
            
        } else {
            
            [params setObject:@"0" forKey:@"last"];
            dispatch_group_t requestGroup = dispatch_group_create();
            
            dispatch_group_enter(requestGroup);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
            });
            
            [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Index/getIndexGoods") parameters:nil completed:^(id responseObject, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [weakSelf.dataSourceArray removeAllObjects];
                NSArray *keyArray = @[@"jiatingriyong",@"jiayongdianqi",@"muyingyongpin",@"meizhuanggehu",@"shipinyinliao"];
                if (responseObject[@"result"][@"flash_images"]) {
                    if (weakSelf.header) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            weakSelf.header.bannerArray = [GSBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"flash_images"]];
//                            weakSelf.header.banner.pageControl.currentPage = 0;
//                            [weakSelf.header.banner reloadData];
                        });
                        
                    }
                }
                
                [keyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSString *topStr = [NSString stringWithFormat:@"%@_top",obj];
                    NSString *botStr = [NSString stringWithFormat:@"%@_floor",obj];
                    
                    if (responseObject[@"result"][topStr] && responseObject[@"result"][botStr]) {
                        
                        GSHomeCollectionCellModel *cellModel = [[GSHomeCollectionCellModel alloc] init];
                        cellModel.topModel = [GSHomeCellTopModel mj_objectWithKeyValues:responseObject[@"result"][topStr]];
                        cellModel.botModel = [GSHomeCellBotModel mj_objectWithKeyValues:responseObject[@"result"][botStr]];
                        cellModel.topTitleImageName = obj;
                        [weakSelf.dataSourceArray addObject:cellModel];
                        
                    }
                }];
                
                dispatch_group_leave(requestGroup);
            }];
            
            dispatch_group_enter(requestGroup);
            [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Index/MiaoshaGoods") parameters:nil completed:^(id responseObject, NSError *error) {
                
                if (responseObject[@"result"] && [responseObject[@"result"] count] > 0) {
                    if (weakSelf.header) {
                        NSArray *tempArray = [GSHomeLimitModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                        [weakSelf.header setLimitArray:[[NSArray alloc] initWithArray:tempArray]];
                    }
                }
                dispatch_group_leave(requestGroup);
            }];
            
            dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.collectionView reloadData];
            });
        }
        
        
        
        [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Index/get_recommend_goods") parameters:params  completed:^(id responseObject, NSError *error) {
            //            NSLog(@"---%@",responseObject);
            [weakSelf.collectionView.mj_footer endRefreshing];
            switch (refreshType) {
                case RefreshTypeClear: {
                    weakSelf.recommendArray = [GSHomeRecommendModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                    if (weakSelf.recommendArray.count < 10) {
                        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                    break;
                    
                case RefreshTypeAdd: {
                    NSArray *tempArray = [GSHomeRecommendModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                    if (tempArray.count < 10) {
                        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [weakSelf.recommendArray addObjectsFromArray:tempArray];
                }
                    break;
                    
                default:
                    break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
                
                if (!weakSelf.footerReady) {
                    weakSelf.footerReady = YES;
                    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf refreshDataWithRefreshType:RefreshTypeAdd];
                    }];
                }
                
            });
            
        }];
    });
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return self.recommendArray.count;
    } else {
        return self.dataSourceArray.count;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!self.header) {
            __weak typeof(self) weakSelf = self;
            self.header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            _header.backgroundColor = [UIColor colorWithRed:239 green:239 blue:244 alpha:1];
            _header.pushBlock = ^(UIViewController *viewController) {
                if ([viewController isKindOfClass:NSClassFromString(@"MyGSViewController")]) {
                    [weakSelf.navigationController.tabBarController setSelectedIndex:3];
                } else {
                    [weakSelf.navigationController pushViewController:viewController animated:YES];
                }
            };
            _header.bannerBlock = ^(NSString *bannerURL) {
                [GSActivityManager pushToActivityWithActiviryURL:bannerURL navigationController:weakSelf.navigationController];
            };
        }
        
        return _header;
        
    } else {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"recommendHeader" forIndexPath:indexPath];
        [[reusableView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 10)];
        view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        [reusableView addSubview:view];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zuixintuijian"]];
        [reusableView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(reusableView.mas_centerX);
            make.centerY.equalTo(reusableView.mas_centerY);
        }];
        return reusableView;
    }
}

#pragma mark GSHomeCollectionViewCellDelegate
- (void)homeCellWillPushViewController:(UIViewController *)viewController {
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)homeCellDidFinishLoadImageWithIndexPath:(NSIndexPath *)indexPath imageSize:(CGSize)imageSize {
    
    if ([self.sizeDictionary objectForKey:[self stringWithIndexPath:indexPath]]) {
        if (imageSize.height == [[self.sizeDictionary objectForKey:[self stringWithIndexPath:indexPath]] floatValue]) {
            return;
        }
    } else {
        [self.sizeDictionary setObject:[NSString stringWithFormat:@"%f",imageSize.height] forKey:[self stringWithIndexPath:indexPath]];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GSHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeColleciontViewCellID forIndexPath:indexPath];
        if (self.dataSourceArray.count > indexPath.item) {
            //__weak typeof(self) weakSelf = self;
            cell.cellModel = [self.dataSourceArray objectAtIndex:indexPath.item];
            cell.indexPath = indexPath;
            cell.delegate = self;

        }
        return cell;
    } else {
        GSStoreDetailCollectionFlowViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"storeGoodsCollectionViewCell" forIndexPath:indexPath];
        if (self.recommendArray.count > indexPath.item) {
            cell.recommendModel = self.recommendArray[indexPath.item];
        }
        return cell;
    }
    
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (self.recommendArray.count > indexPath.item) {
            GSHomeRecommendModel *recommendModel = self.recommendArray[indexPath.item];
//            GoodsDetailViewController *goodsShowViewController = [GoodsDetailViewController createGoodsDetailView];
//            goodsShowViewController.hidesBottomBarWhenPushed = YES;
//            goodsShowViewController.goodsId = recommendModel.goods_id;
            
            GSGoodsDetailInfoViewController *detailViewController = ViewController_in_Storyboard(@"Main", @"GSGoodsDetailInfoViewController");
            detailViewController.recommendModel = recommendModel;
            detailViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        CGFloat adViewHeight = 0;
        if (self.dataSourceArray.count > indexPath.item) {
            GSHomeCollectionCellModel *cellModel = [self.dataSourceArray objectAtIndex:indexPath.item];
            
            if (cellModel.topModel.top && [cellModel.topModel.top containsString:@"http://"]) {
                adViewHeight = (Width * 140 / 720) + 10;
            }
            
        }
        
        CGFloat imageHeight = 340;
        if ([self.sizeDictionary objectForKey:[self stringWithIndexPath:indexPath]]) {
            
            float height = [[self.sizeDictionary objectForKey:[self stringWithIndexPath:indexPath]] floatValue];
            
            imageHeight = height;
        }
        
        CGFloat titleViewHeight = 40.0f;
        CGFloat itemCellHeight = (Width - 30)/3 + 80;
        CGFloat sepHeight = 10;
        CGFloat height = (imageHeight*Width)/720 + titleViewHeight +adViewHeight + itemCellHeight + sepHeight;
        //        NSLog(@"%f",height);
        return CGSizeMake(Width, height);
        
        //return CGSizeMake(Width, 100);
    } else {
        return CGSizeMake((Width - 30)/2, (Width - 30)/ 2 + 65);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(0, 10, 10, 10);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 10;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat bannerHeight = (Width * 300.0)/750.0;
        CGFloat toolsBarHeight = 90.0f;
        CGFloat limitLine = 10.0f;
        CGFloat limitToolsHeight = 50.0f;
        CGFloat limitHeight = (112.5*(Height/667.0));
        if (self.header) {
            if (self.header.limitArray.count == 0) {
                
                return CGSizeMake(Width, bannerHeight + toolsBarHeight + limitLine + limitToolsHeight);
            } else
                return CGSizeMake(Width, bannerHeight + toolsBarHeight + limitLine + limitHeight + limitToolsHeight);
            
        } else {
            return CGSizeMake(Width,  bannerHeight + toolsBarHeight + limitLine + limitHeight + limitToolsHeight);
        }
        
    } else {
        return CGSizeMake(Width, 50);
    }
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ([scrollView isKindOfClass:[UICollectionView class]]) {
//        if (scrollView.contentOffset.y < (Width * 310)/720) {
//            [UIView animateWithDuration:0.5 animations:^{
//                _navView.backgroundColor = [UIColor colorWithHexString:@"d9d9d9" alpha:0.25];
//            }];
//        } else {
//            //             if (((Width * 310)/720) + 200 > scrollView.contentOffset.y && scrollView.contentOffset.y > (Width * 310)/720)
//            [UIView animateWithDuration:0.5 animations:^{
//                _navView.backgroundColor = [UIColor colorWithHexString:@"e42144" alpha:1];
//                //                (scrollView.contentOffset.y - ((Width * 310)/720)) / 200.0f]
//                
//            }];
//        }
//        
//        //NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)stringWithIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"%zi%zi",indexPath.section,indexPath.item];
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
