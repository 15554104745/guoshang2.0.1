//
//  GoodsInformationView.h
//  guoshang
//
//  Created by JinLian on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^passBlock)(NSDictionary *dic);
@interface GoodsInformationView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *goods_name;

@property (weak, nonatomic) IBOutlet UITextField *goods_subNme;

@property (weak, nonatomic) IBOutlet UITextField *inventory;//库存

@property (weak, nonatomic) IBOutlet UITextField *marketPrice;

@property (weak, nonatomic) IBOutlet UITextField *sellingPrice;

@property (weak, nonatomic) IBOutlet UIButton *addStockBtn;


@property(nonatomic,retain)NSMutableDictionary *dataList;


@property (nonatomic, copy)passBlock block;

- (void)returnVale:(passBlock)block;
- (void)passValue;

@end


@interface UIView (UIViewController)

- (UIViewController *)viewController;

@end