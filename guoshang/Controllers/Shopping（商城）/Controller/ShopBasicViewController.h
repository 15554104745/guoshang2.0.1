//
//  ShopBasicViewController.h
//  guoshang
//
//  Created by 张涛 on 16/4/6.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsModel.h"
#import "BrandModel.h"
#import "CategoryModel.h"


@interface ShopBasicViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

//筛选按钮
@property (strong,nonatomic) UIButton * siftButton;
//数据数组
@property (strong,nonatomic) NSMutableArray * dataArray;
//筛选品牌数组
@property (strong,nonatomic) NSMutableArray * brandArray;
//筛选类型数组
@property (strong,nonatomic) NSMutableArray * classArray;
//按人气排序数组
@property (strong,nonatomic) NSMutableArray * popArray;
//按销量排序数组
@property (strong,nonatomic) NSMutableArray * salArray;
//按价格排序数组
@property (strong,nonatomic) NSMutableArray * priArray;

@property (strong,nonatomic) UIView * buttonsView;
@property (strong,nonatomic) UITableView * menuView;
@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) UICollectionView * collectionView;

@property (copy, nonatomic) NSString * url;
@property (copy, nonatomic) NSString * keywords;

@property (copy, nonatomic) NSString * classTitle;;

@property (copy, nonatomic) NSString * order;
@property (copy, nonatomic) NSString * sort;
@property (copy, nonatomic) NSString * cat_id;
@property (copy, nonatomic) NSString * brand;
@property (strong,nonatomic) NSNumber * is_exchange;
@property (nonatomic, assign) NSInteger page; // 页码
@property (nonatomic,strong) NSDictionary *parameters;


-(void)dataInit;
-(void)allDataInit;
-(void)toMenu;
@end

