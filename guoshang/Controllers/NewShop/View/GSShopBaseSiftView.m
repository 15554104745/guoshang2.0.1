//
//  GSShopBaseSiftView.m
//  guoshang
//
//  Created by Rechied on 2016/11/5.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSShopBaseSiftView.h"
#import "GSShopBaseSiftCollectionViewCell.h"
#import "GSShopBaseSiftSectionCollectionReusableView.h"
#import "GSShopBaseSiftCollectionBottomFooter.h"

#import "GSShopBaseBrandModel.h"
#import "GSShopBaseCategoryModel.h"

#import "UIColor+HaxString.h"
#import "RequestManager.h"
#import "MBProgressHUD.h"

@interface GSShopBaseSiftView()<GSShopBaseSiftSectionCollectionReusableViewDelegate,GSShopBaseSiftCollectionBottomFooterDelegate>
@property (weak, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) BOOL showAllCategory;
@property (assign, nonatomic) BOOL showAllBrand;
@property (strong, nonatomic) NSMutableDictionary *selectItems;
@property (copy, nonatomic) NSArray *sectionTitleArray;
@end

@implementation GSShopBaseSiftView

- (NSMutableDictionary *)selectItems {
    if (!_selectItems) {
        _selectItems = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _selectItems;
}

- (NSArray *)sectionTitleArray {
    if (!_sectionTitleArray) {
        _sectionTitleArray = @[@"分类：",@"销售类别：",@"品牌："];
    }
    return _sectionTitleArray;
}

- (void)setBrandArray:(NSMutableArray *)brandArray {
    if (brandArray.count != 0) {
        _brandArray = brandArray;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        [brandArray enumerateObjectsUsingBlock:^(GSShopBaseBrandModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.selected isEqualToString:@"1"]) {
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:2] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                [self.selectItems setObject:[NSIndexPath indexPathForItem:idx inSection:2] forKey:@(2)];
                return;
            }
        }];
    }
}

- (void)setCategoryArray:(NSMutableArray *)categoryArray {
    if (categoryArray.count != 0) {
        _categoryArray = categoryArray;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [categoryArray enumerateObjectsUsingBlock:^(GSShopBaseBrandModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.selected isEqualToString:@"1"]) {
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                [self.selectItems setObject:[NSIndexPath indexPathForItem:idx inSection:0] forKey:@(0)];
                return;
            }
        }];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        collectionView.allowsMultipleSelection = YES;
        [collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [collectionView registerNib:[UINib nibWithNibName:@"GSShopBaseSiftCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GSShopBaseSiftCollectionViewCell"];
        [collectionView registerNib:[UINib nibWithNibName:@"GSShopBaseSiftSectionCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GSShopBaseSiftSectionCollectionReusableView"];
        [collectionView registerNib:[UINib nibWithNibName:@"GSShopBaseSiftCollectionBottomFooter" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"GSShopBaseSiftCollectionBottomFooter"];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.bounces = NO;
        _collectionView = collectionView;
        return _collectionView;
    }
    return _collectionView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _collectionView) {
        if (_collectionView.contentSize.height > 0) {
            if ([_delegate respondsToSelector:@selector(siftViewDidUpdateHeight:)]) {
                [_delegate siftViewDidUpdateHeight:_collectionView.contentSize.height];
            }
        }
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)dealloc {
    [_collectionView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)createUI {
    [self addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_offset(0);
        //make.bottom.offset(-40);
    }];
    [self setupSelectPayType];
}

- (void)setupSelectPayType {
    
    if (self.selectItems[@(1)]) {
        [_collectionView deselectItemAtIndexPath:self.selectItems[@(1)] animated:YES];
    }
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.selectItems setObject:[NSIndexPath indexPathForRow:0 inSection:1] forKey:@(1)];
}

#pragma mark - GSShopBaseSiftSectionCollectionReusableViewDelegate
- (void)showAllButtonDidClickWithSection:(NSInteger)section selected:(BOOL)selected {
    
    if (section == 0) {
        self.showAllCategory = selected;
    }
    
    if (section == 2) {
        self.showAllBrand = selected;
    }
    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
    [_collectionView selectItemAtIndexPath:self.selectItems[@(section)] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - GSShopBaseSiftCollectionBottomFooterDelegate
- (void)resertButtonClick {
    [self setCategoryArray:_categoryArray];
    [self setBrandArray:_brandArray];
    [self setupSelectPayType];
}

- (void)commitButtonClick {
    if ([_delegate respondsToSelector:@selector(siftView:didFinishedSelctSiftWithCat_id:is_exchange:brand_id:)]) {
        __block NSString *cat_id = nil;
        __block BOOL is_exchange = NO;
        __block NSString *brand_id = nil;
        [[self.selectItems allValues] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.section == 0) {
                GSShopBaseCategoryModel *categoryModel = self.categoryArray[obj.item];
                cat_id = categoryModel.cat_id;
            }
            
            if (obj.section == 1) {
                is_exchange = (BOOL)obj.item;
            }
            
            if (obj.section == 2) {
                GSShopBaseBrandModel *brandModel = self.brandArray[obj.item];
                brand_id = brandModel.brand_id;
            }
        }];
        [_delegate siftView:self didFinishedSelctSiftWithCat_id:cat_id is_exchange:is_exchange brand_id:brand_id];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.categoryArray.count >= 3 && !self.showAllCategory) {
            return 3;
        } else {
            return self.categoryArray.count;
        }
        
    } else if (section == 1) {
        return 0;
    } else if (section == 2) {
        if (self.brandArray.count >= 9 && !self.showAllBrand) {
            return 9;
        } else {
            return self.brandArray.count;
        }
    } else {
        return 0;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSShopBaseSiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GSShopBaseSiftCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.item < self.categoryArray.count) {
            GSShopBaseCategoryModel *categoryModel = self.categoryArray[indexPath.item];
            cell.titleLabel.text = categoryModel.cat_name;
        } else {
            cell.titleLabel.text = @"";
        }
    }
    
    if (indexPath.section == 1) {
        cell.titleLabel.text = @[@"金币",@"国币"][indexPath.item];
    }
    
    if (indexPath.section == 2) {
        if (indexPath.item < self.brandArray.count) {
            GSShopBaseBrandModel *brandModel = self.brandArray[indexPath.item];
            cell.titleLabel.text = brandModel.brand_name ? brandModel.brand_name : @"";
        } else {
            cell.titleLabel.text = @"";
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        GSShopBaseSiftSectionCollectionReusableView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GSShopBaseSiftSectionCollectionReusableView" forIndexPath:indexPath];
        if (indexPath.section != 1) {
            sectionHeader.delegate = self;
            sectionHeader.section = indexPath.section;
            sectionHeader.showAllButton.hidden = NO;
            if (indexPath.section == 0) {
                sectionHeader.showAllButton.selected = self.showAllCategory;
            } else {
                sectionHeader.showAllButton.selected = self.showAllBrand;
            }
        } else {
            sectionHeader.showAllButton.hidden = YES;
        }
        sectionHeader.titleLabel.text = self.sectionTitleArray[indexPath.section];
        return sectionHeader;
    } else {
        if (indexPath.section == 2) {
            GSShopBaseSiftCollectionBottomFooter *sectionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"GSShopBaseSiftCollectionBottomFooter" forIndexPath:indexPath];
            sectionFooter.delegate = self;
            return sectionFooter;
        } else {
            return nil;
        }
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(15, 15, 20, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectItems[@(indexPath.section)] != indexPath) {
        
        [collectionView deselectItemAtIndexPath:self.selectItems[@(indexPath.section)] animated:YES];
        
        [self.selectItems setObject:indexPath forKey:@(indexPath.section)];
        if (indexPath.section == 0) {
            GSShopBaseCategoryModel *categoryModel = self.categoryArray[indexPath.row];
            [self getBrandDataWithCat_id:categoryModel.cat_id is_exchange:(BOOL)[(NSIndexPath *)self.selectItems[@(1)] item]];
        } else if (indexPath.section == 1) {
            NSIndexPath *selectIndexPath = self.selectItems[@(0)];
            GSShopBaseCategoryModel *categoryModel = self.categoryArray[selectIndexPath.item];
            [self getBrandDataWithCat_id:categoryModel.cat_id is_exchange:(BOOL)indexPath.item];
        }
    }
    
    
}

- (void)getBrandDataWithCat_id:(NSString *)cat_id is_exchange:(BOOL)is_exchange {
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:self];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"?m=Api&c=Category&a=category") parameters:@{@"cat_id":cat_id,@"is_exchange":[NSString stringWithFormat:@"%zi",is_exchange]} completed:^(id responseObject, NSError *error) {
        
        if (responseObject[@"result"]) {
            weakSelf.brandArray = [GSShopBaseBrandModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"select"][@"brand"]];
            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        }
    }];

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return 35;
    } else {
        return 25;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return CGSizeMake((Width - 65) / 2, 27);
    } else {
        return CGSizeMake((Width - 80) / 3, 27);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeZero;
    }
    return CGSizeMake(Width, 35);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return CGSizeMake(Width, 30);
    } else {
        return CGSizeZero;
    }
}



@end
