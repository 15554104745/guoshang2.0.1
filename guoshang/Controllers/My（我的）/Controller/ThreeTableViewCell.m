//
//  ThreeTableViewCell.m
//  guoshang
//
//  Created by JinLian on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "ThreeTableViewCell.h"
#import "ThreeCollectionViewCell.h"
#import "GoodsShowViewController.h"
#import "UIView+UIViewController.h"
#import "ThreeViewModel.h"
#import "GSGoodsDetailInfoViewController.h"
#define KScreen_W [UIScreen mainScreen].bounds.size.width

@interface ThreeTableViewCell (){
    UICollectionView *collectVeiw;
}

@end

@implementation ThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];



}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:@"threeCell"]) {
        
        [self createSubView];
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList {
    
    _dataList = dataList;
    
    [collectVeiw reloadData];
}

/**
 *  未调用
 */
- (void)createSubView {
    
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(0, 0, KScreen_W, 30);
    title.text = @"精选推荐";
    title.textColor = [UIColor redColor];
    title.font = [UIFont systemFontOfSize:12];
    title.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:title];
    
    UIImageView *labView = [[UIImageView alloc]init];
    labView.frame = CGRectMake(10, title.frame.origin.y+30, KScreen_W-20, 1);
    labView.image = [UIImage imageNamed:@"xuxian"];
    [self.contentView addSubview:labView];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    NSInteger itemW = ([UIScreen mainScreen].bounds.size.width-60)/3;
    NSInteger itemH = itemW+47;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    collectVeiw = [[UICollectionView alloc]initWithFrame: CGRectMake(0, 33,KScreen_W, itemH*2+20) collectionViewLayout:flowLayout];
    collectVeiw.dataSource = self;
    collectVeiw.delegate = self;
    collectVeiw.scrollEnabled = NO;
    collectVeiw.backgroundColor = [UIColor whiteColor];
    [collectVeiw registerNib:[UINib nibWithNibName:@"ThreeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"threeCollectionCell"];
    [self.contentView addSubview:collectVeiw];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataList.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ThreeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"threeCollectionCell" forIndexPath:indexPath];
    cell.model = _dataList[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GSGoodsDetailInfoViewController *goodsShow = [[GSGoodsDetailInfoViewController alloc] init];
    goodsShow.hidesBottomBarWhenPushed = YES;
    ThreeViewModel *model = _dataList[indexPath.row];
    goodsShow.recommendModel = model;
    [self.viewController.navigationController pushViewController:goodsShow animated:YES];
}








- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
