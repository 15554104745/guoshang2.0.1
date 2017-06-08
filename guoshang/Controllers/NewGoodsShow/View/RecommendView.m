//
//  RecommendView.m
//  Demo
//
//  Created by JinLian on 16/8/10.
//  Copyright © 2016年 GroupFly. All rights reserved.
//

#import "RecommendView.h"
#import "RecommendCollectionViewCell.h"
#import "HotGoodsModel.h"
#import "GoodsDetailViewController.h"
#import "UIView+UIViewController.h"
static NSString *identifier = @"cell";

@implementation RecommendView



- (instancetype)initWithFrame:(CGRect)frame {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 20;   //列间距
    flowLayout.minimumLineSpacing = 20;        //行间距
    flowLayout.itemSize = CGSizeMake((frame.size.width-60)/2, 200);
    //NSLog(@"%f",frame.size.width);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
     
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"RecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        
    }
    return self;
}
#pragma mark - UICollectionViewDelegate  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    HotGoodsModel *model = [self.dataList objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}




@end
