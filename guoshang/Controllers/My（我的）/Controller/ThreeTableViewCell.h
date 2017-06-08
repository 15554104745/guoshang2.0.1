//
//  ThreeTableViewCell.h
//  guoshang
//
//  Created by JinLian on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)NSArray *dataList;

@end
