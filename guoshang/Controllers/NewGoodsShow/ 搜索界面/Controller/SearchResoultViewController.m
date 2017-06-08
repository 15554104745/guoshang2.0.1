//
//  SearchResoultViewController.m
//  guoshang
//
//  Created by JinLian on 16/9/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SearchResoultViewController.h"
#import "SearchTitleView.h"
#import "SearchResultModel.h"
#import "SearchCollectionViewCell_column.h"
#import "SearchCollectionViewCell_TwoColumns.h"
#import "GSGoodsDetailInfoViewController.h"
static NSString *collectionView_column = @"collectionView_column";
static NSString *collectionView_Twocolumns = @"collectionView_Twocolumns";

@interface SearchResoultViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    BOOL is_showTtileView;              //是否隐藏头视图
    BOOL is_showTwoColumns;             //判断横向展示一个还是展示两个商品
    CGFloat collectionViewContentOfSet_Y;
    NSInteger page;
    NSDictionary *paramsDic;
}

@property (nonatomic, strong)SearchTitleView *searchTitleView;
@property (nonatomic, strong)UITableView *searchTableView;
@property (nonatomic, strong)UIView *titleBackView;
@property (nonatomic, strong)NSString *sort;
@property (nonatomic, strong)NSString *order;
@property (nonatomic, strong)NSMutableArray *goodsDataArr;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray * TypeArr;
@end

@implementation SearchResoultViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    is_showTtileView = YES;
    is_showTwoColumns = NO;
    page = 0;
    self.TypeArr  = [[NSMutableArray alloc]init];
    [self.TypeArr addObject:@"易购商品"];
     [self.TypeArr addObject:@"国币商品"];
     [self.TypeArr addObject:@"特卖商品"];
    [self loadData];
    [self registerCollectionViewCell];
}
-(void)jiazai
{
    page ++;
    NSLog(@"keyWords = %@",self.keyWords);
    NSString * TempStr = [[NSString alloc]init];
    if ([self.TypeArr containsObject:@"易购商品"]) {
        TempStr  = @"yigou#";
    }
    if ([self.TypeArr containsObject:@"国币商品"]) {
        TempStr  = [TempStr stringByAppendingString:@"guobi#"];
    }
    if ([self.TypeArr containsObject:@"特卖商品"]) {
        TempStr  = [TempStr stringByAppendingString:@"temai#"];
    }
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"order=%@,sort=%@,page=%@,keyword=%@,select=%@",paramsDic[@"order"] ? paramsDic[@"order"]: @"",paramsDic[@"sort"] ? paramsDic[@"sort"] : @"",[NSString stringWithFormat:@"%ld",(long)page],self.keyWords,TempStr];
    encryptString = [userId encryptStringWithKey:KEY];

    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Goods/search")parameters:@{@"token":encryptString} success:^(id responseObject) {
        //        if ([[responseObject objectForKey:@"status"] integerValue] == 3) {
        for (NSArray *arr in responseObject[@"result"]) {
            SearchResultModel *model = [SearchResultModel mj_objectWithKeyValues:arr];
            [self.goodsDataArr addObject:model];
        }

        [weakSelf.collectionView.mj_footer endRefreshing];
        //        }
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_footer endRefreshing];
        
    }];

}
- (void)loadData {
    page=1;
    NSLog(@"keyWords = %@",self.keyWords);
    NSString * TempStr = [[NSString alloc]init];

    if (self.TypeArr.count == 0) {
        TempStr =@"yigou#guobi#temai";
    }
else
{
    if ([self.TypeArr containsObject:@"易购商品"]) {
        TempStr  = @"yigou#";
    }
    if ([self.TypeArr containsObject:@"国币商品"]) {
        TempStr  = [TempStr stringByAppendingString:@"guobi#"];
    }
    if ([self.TypeArr containsObject:@"特卖商品"]) {
        TempStr  = [TempStr stringByAppendingString:@"temai#"];
    }

    TempStr = [TempStr substringToIndex:TempStr.length-1];
}
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"order=%@,sort=%@,page=%@,keyword=%@,select=%@",paramsDic[@"order"] ? paramsDic[@"order"]: @"",paramsDic[@"sort"] ? paramsDic[@"sort"] : @"",[NSString stringWithFormat:@"%ld",(long)page],self.keyWords,TempStr];
    encryptString = [userId encryptStringWithKey:KEY];

    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/Goods/search")parameters:@{@"token":encryptString} success:^(id responseObject) {
//        if ([[responseObject objectForKey:@"status"] integerValue] == 3) {
        self.goodsDataArr = [[NSMutableArray alloc]init];
        for (NSArray *arr in responseObject[@"result"]) {
            SearchResultModel *model = [SearchResultModel mj_objectWithKeyValues:arr];
            [self.goodsDataArr addObject:model];
        }
        
        [weakSelf.collectionView.mj_footer endRefreshing];
//        }
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_footer endRefreshing];

    }];
    
}

- (void)registerCollectionViewCell {
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchCollectionViewCell_column" bundle:nil] forCellWithReuseIdentifier:collectionView_column];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchCollectionViewCell_TwoColumns" bundle:nil] forCellWithReuseIdentifier:collectionView_Twocolumns];
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsDataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (is_showTwoColumns) {
        SearchCollectionViewCell_TwoColumns *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionView_Twocolumns forIndexPath:indexPath];
        cell.model = self.goodsDataArr[indexPath.row];
        return cell;
    }else {
        SearchCollectionViewCell_column *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionView_column forIndexPath:indexPath];
        cell.model = self.goodsDataArr[indexPath.row];
        return cell;
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (is_showTwoColumns) {
        return CGSizeMake(self.view.frame.size.width/2-10, self.view.frame.size.width/2-10 + 65);
    }else {
        return CGSizeMake(self.view.frame.size.width, 110);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (is_showTwoColumns) {
        return 5;
    }else {
        return 0.01;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GSGoodsDetailInfoViewController * gsvc = [[GSGoodsDetailInfoViewController alloc] init];
    gsvc.hidesBottomBarWhenPushed = YES;
    //    NSLog(@"%@",self.url);
    gsvc.recommendModel = self.goodsDataArr[indexPath.row];
    [self.navigationController pushViewController:gsvc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height) {
        return;
    }
    if (scrollView.contentOffset.y>0 && scrollView.contentOffset.y > collectionViewContentOfSet_Y  && is_showTtileView ) {
        [self titleViewHiden];
    }
    if (scrollView.contentOffset.y>0 && scrollView.contentOffset.y < collectionViewContentOfSet_Y && !is_showTtileView) {
        [self titleViewShow];
    }
    collectionViewContentOfSet_Y = scrollView.contentOffset.y;
}

- (void)titleViewHiden {
    is_showTtileView = NO;
    [UIView animateWithDuration:0.25 animations:^{
        CGAffineTransform transform = self.searchTitleView.transform;
        self.searchTitleView.transform = CGAffineTransformTranslate(transform, 0, -81);
        CGAffineTransform transform2 = self.collectionView.transform;
        self.collectionView.transform = CGAffineTransformTranslate(transform2, 0, -81);
    } completion:^(BOOL finished) {
        [self.view addSubview:self.titleBackView];
    }];
}
- (void)titleViewShow {
    is_showTtileView = YES;
    [self.titleBackView removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        self.collectionView.transform = CGAffineTransformIdentity;
        self.searchTitleView.transform = CGAffineTransformIdentity;
    }]; 
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.searchTitleView.frame.origin.y+145, Width, Height-64) collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = MyColor;
        __weak typeof(self) weakSelf = self;
        _collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//            page = 1;
            [weakSelf jiazai];
        }];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (SearchTitleView *)searchTitleView {
    if (!_searchTitleView) {
        _searchTitleView = [[SearchTitleView alloc]initWithFrame:CGRectMake(0, 0, Width, 145)];
        [self.view addSubview:_searchTitleView];
        __weak typeof(self) weakSelf = self;
        _searchTitleView.block = ^(NSDictionary *params){
            paramsDic = [NSDictionary dictionaryWithDictionary:params];
            page = 0;
            [weakSelf loadData];
        };
        _searchTitleView.exchangeBlock = ^(BOOL isShowTwoColumns) {
            is_showTwoColumns = isShowTwoColumns;
            [weakSelf.collectionView reloadData];
        };

        _searchTitleView.SearchTypeBlock = ^(NSString *type){

            if ([weakSelf.TypeArr containsObject:type]) {
                [weakSelf.TypeArr removeObject:type];
            }
            else
            {
                [weakSelf.TypeArr addObject:type];
            }
            page = 0;
            [weakSelf loadData];
 NSLog(@"%@",weakSelf.TypeArr);
        };
    }
    return _searchTitleView;
}

- (UIView *)titleBackView {
    if (!_titleBackView) {
        _titleBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 25)];
        _titleBackView.backgroundColor = [UIColor whiteColor];
    }
    return _titleBackView;
}

- (NSMutableArray *)goodsDataArr {
    if (!_goodsDataArr) {
        _goodsDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _goodsDataArr;
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
