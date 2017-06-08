//
//  GSNewClassfiyViewController.m
//  guoshang
//
//  Created by Rechied on 2016/11/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNewClassfiyViewController.h"
#import "GSClassfiyLeftTableViewCell.h"
#import "GSClassfiyRightCollectionViewCell.h"
#import "GSClassfiyCollectionSectionHeaderView.h"

#import "GoodsViewController.h"
#import "GoodsDetailViewController.h"

#import "GSClassfiyMenuModel.h"
#import "GSClassfiyModel.h"

#import "RequestManager.h"
#import "MBProgressHUD.h"

#import "GSNewShopBaseViewController.h"
@interface GSNewClassfiyViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GSClassfiyCollectionSectionHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *ADImageView;

@property (copy, nonatomic) NSString *AD_goods_id;

@property (strong, nonatomic) NSMutableArray *menuDataSourceArray; //左边表数据源
@property (strong, nonatomic) NSMutableArray *dataSourceArray;     //右边CollectionView数据源
@end

@implementation GSNewClassfiyViewController

- (instancetype)init {
    self = ViewController_in_Storyboard(@"Main", @"GSNewClassfiyViewController");
    return self;
}

#pragma mark - getter
- (NSMutableArray *)menuDataSourceArray {
    if (!_menuDataSourceArray) {
        _menuDataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _menuDataSourceArray;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    [self setupTableView];
    [self getMenuData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UI
- (void)setupTableView {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.collectionView registerNib:[UINib nibWithNibName:@"GSClassfiyCollectionSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GSClassfiyCollectionSectionHeaderView"];
}

#pragma mark - Data
- (void)getMenuData {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"?m=Api&c=Category&a=index") parameters:nil completed:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (responseObject && responseObject[@"result"]) {
    
            weakSelf.menuDataSourceArray = [GSClassfiyMenuModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            [weakSelf.tableView reloadData];
            if (weakSelf.menuDataSourceArray.count != 0) {
                [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                [weakSelf tableView:weakSelf.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
        }
    }];
}

- (void)getClassfiyDataWithCat_id:(NSString *)cat_id {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.view];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"?m=Api&c=Category&a=getCateOne") parameters:@{@"cat_id":cat_id} completed:^(id responseObject, NSError *error) {
        
        if (responseObject && responseObject[@"result"]) {
            [weakSelf.ADImageView setImageWithURL:[NSURL URLWithString:responseObject[@"result"][@"banner"][@"goods_thumb"]]];
            weakSelf.AD_goods_id = responseObject[@"result"][@"banner"][@"goods_id"];
            weakSelf.dataSourceArray = [GSClassfiyModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"category"]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [weakSelf.collectionView reloadData];
        }
        
    }];
}

#pragma mark - Action
- (IBAction)ADButtonClick:(id)sender {
//    if (self.AD_goods_id && ![self.AD_goods_id isEqualToString:@""]) {
//        GoodsDetailViewController * show = [GoodsDetailViewController createGoodsDetailView];
//        show.goodsId = self.AD_goods_id;
//        
//        show.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:show animated:YES];
//    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuDataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSClassfiyLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSClassfiyLeftTableViewCell" forIndexPath:indexPath];
    if (indexPath.row < self.menuDataSourceArray.count) {
        cell.menuModel = self.menuDataSourceArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    if (indexPath.row < self.menuDataSourceArray.count) {
        GSClassfiyMenuModel *menuModel = self.menuDataSourceArray[indexPath.row];
        [self getClassfiyDataWithCat_id:menuModel.ID];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSourceArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section < self.dataSourceArray.count) {
        GSClassfiyModel *classfiyModel = self.dataSourceArray[section];
        return classfiyModel.cat_id.count;
    } else {
        return 0;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSClassfiyRightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GSClassfiyRightCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section < self.dataSourceArray.count) {
        GSClassfiyModel *tempModel = self.dataSourceArray[indexPath.section];
        cell.itemModel = tempModel.cat_id[indexPath.item];
        
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    GSClassfiyCollectionSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GSClassfiyCollectionSectionHeaderView" forIndexPath:indexPath];
    
    if (indexPath.section < self.dataSourceArray.count) {
        headerView.sectionModel = self.dataSourceArray[indexPath.section];
        headerView.delegate = self;
    }
    return headerView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.dataSourceArray.count) {
        GSClassfiyModel *classfiyModel = self.dataSourceArray[indexPath.section];
        if (indexPath.item < classfiyModel.cat_id.count) {
            GSClassfiyItemModel *itemModel = classfiyModel.cat_id[indexPath.item];
            GoodsViewController * goodsViewController = [[GoodsViewController alloc]init];
            goodsViewController.ID = itemModel.ID;
            goodsViewController.name = itemModel.name;
            
            GSNewShopBaseViewController *shopViewController = [[GSNewShopBaseViewController alloc] init];
            shopViewController.cat_id = itemModel.ID;
            shopViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shopViewController animated:YES];
        }
    }
}




#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.dataSourceArray.count) {
        GSClassfiyModel *tempModel = self.dataSourceArray[indexPath.section];
        if (indexPath.item < tempModel.cat_id.count) {
            GSClassfiyItemModel *itemModel = tempModel.cat_id[indexPath.item];
            CGRect titleRect = [itemModel.name boundingRectWithSize:CGSizeMake(0, 1000) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
            return (titleRect.size.width + 20) < 65 ? CGSizeMake(65, 30) : CGSizeMake(titleRect.size.width + 20, 30);
        }
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section < self.dataSourceArray.count) {
        return CGSizeMake(Width - 20 - 70 * 375.0/Width, 30);
    } else {
        return CGSizeZero;
    }
}

#pragma mark - GSClassfiyCollectionSectionHeaderViewDelegate
- (void)collectionViewDidSelectSectionWithCat_id:(NSString *)cat_id name:(NSString *)name {
    GoodsViewController * goodsViewController = [[GoodsViewController alloc]init];
    goodsViewController.ID = cat_id;
    goodsViewController.name = name;
    goodsViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsViewController animated:YES];
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
