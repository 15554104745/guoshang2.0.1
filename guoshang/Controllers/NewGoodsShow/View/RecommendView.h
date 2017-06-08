//
//  RecommendView.h
//  Demo
//
//  Created by JinLian on 16/8/10.
//  Copyright © 2016年 GroupFly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign)NSArray *dataList;

@end
