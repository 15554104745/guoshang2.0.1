//
//  GSGoodsDetialRecommendGoodsCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetialRecommendGoodsCell.h"
#import "STTopBar.h"
#import "RequestManager.h"
#import "GSGoodsDetialRecommendGoodsCollectionViewCell.h"
#import "MBProgressHUD.h"
#import "GSHomeRecommendModel.h"

typedef NS_ENUM(NSInteger, GSGoodsDetailRecommendType) {
    GSGoodsDetailRecommendTypeBest = 0,
    GSGoodsDetailRecommendTypeShop,
};

@interface GSGoodsDetialRecommendGoodsCell() <STTabBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *topToolsView;
@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (assign, nonatomic) BOOL initDataReady;
@property (assign, nonatomic) GSGoodsDetailRecommendType recommendType;
@end

@implementation GSGoodsDetialRecommendGoodsCell



- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    STTopBar *topBar = [[STTopBar alloc] initWithArray:@[@"精选推荐",@"门店热销"]];
    topBar.backgroundColor = [UIColor clearColor];
    topBar.delegate = self;
    [self.topToolsView addSubview:topBar];
    
    [topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17.5);
        make.right.offset(-17.5);
        make.top.offset(5);
        make.bottom.offset(0);
    }];
    // Initialization code
    
    self.recommendCollectionView.delegate = self;
    self.recommendCollectionView.dataSource = self;
    
    [self.recommendCollectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    CGSize size = self.recommendCollectionView.contentSize;
    
    if (self.recommendContentViewHeight.constant != size.height) {
        self.recommendContentViewHeight.constant = size.height;
        if ([_delegate respondsToSelector:@selector(goodsDetailRecommendGoodsCellDidUpdateHeight)]) {
            [_delegate goodsDetailRecommendGoodsCellDidUpdateHeight];
        }
    }
}

- (void)tabBar:(STTopBar *)tabBar didSelectIndex:(NSInteger)index {
    self.recommendType = index;
    [self.dataSourceArray removeAllObjects];
    [self getDataWithStartCount:0 recommendType:self.recommendType];
}

- (void)dealloc {
    [self.recommendCollectionView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)setDetailModel:(GSGoodsDetailModel *)detailModel {
    [super setDetailModel:detailModel];
    if (self.dataSourceArray.count == 0) {
        [self getDataWithStartCount:0 recommendType:GSGoodsDetailRecommendTypeBest];
    }
}

- (IBAction)seeMoreButtonClick:(UIButton *)sender {
    
    [self getDataWithStartCount:self.dataSourceArray.count recommendType:GSGoodsDetailRecommendTypeBest];
}


- (void)getDataWithStartCount:(NSInteger)startCount recommendType:(GSGoodsDetailRecommendType)recommendType {
    __weak typeof(self) weakSelf = self;
    switch (recommendType) {
        case GSGoodsDetailRecommendTypeBest: {
            [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.contentView];
            [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Index/get_recommend_goods") parameters:@{@"amount":@"6",@"last":@(startCount)} completed:^(id responseObject, NSError *error) {
                
                [weakSelf.dataSourceArray addObjectsFromArray:[GSHomeRecommendModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]]];
                [weakSelf.recommendCollectionView reloadData];
                [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
            }];
        }
            break;
            
        case GSGoodsDetailRecommendTypeShop: {
            [MBProgressHUD showHUDWithCustomAnimationAddedTo:self.contentView];
            [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Goods/shop_hot_sale") parameters:[@{@"goods_id":self.detailModel.goodsinfo.goods_id,@"num":@(startCount + 6)} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
                
                weakSelf.dataSourceArray = [GSHomeRecommendModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
                [weakSelf.recommendCollectionView reloadData];
                [MBProgressHUD hideHUDForView:weakSelf.contentView animated:YES];
            }];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIColectionViewFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Width - 35 - 10) / 3, (Width - 35 - 10) / 3 + 50);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSGoodsDetialRecommendGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GSGoodsDetialRecommendGoodsCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.item < self.dataSourceArray.count) {
        cell.recommendModel = self.dataSourceArray[indexPath.item];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSourceArray.count) {
        GSHomeRecommendModel *recommendModel = self.dataSourceArray[indexPath.item];
        if ([_delegate respondsToSelector:@selector(goodsDetailRecommendGoodsCellDidSelectGoodsWithGoodsModel:)]) {
            [_delegate goodsDetailRecommendGoodsCellDidSelectGoodsWithGoodsModel:recommendModel];
        }
    }
    
}

@end
