//
//  GSNewShopBaseViewController.h
//  guoshang
//
//  Created by Rechied on 2016/11/3.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSNewShopBaseViewController : UIViewController

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSString *cat_id;
@property (copy, nonatomic) NSString *requestURL;

@property (copy, nonatomic) NSString *keywords;

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@end
