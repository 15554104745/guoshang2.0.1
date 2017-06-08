//
//  GSCarEditCell.h
//  guoshang
//
//  Created by 金联科技 on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSCarModel.h"
/**
 cell是否被选中的回调
 @param select 是否被选中
 */

typedef void(^GSCartBlock)(BOOL select);
typedef void(^GSDelectBlock)();
@interface GSCarEditCell : UITableViewCell
@property(nonatomic)BOOL isSelect;
@property (weak, nonatomic) IBOutlet UIButton *selection;//选中button
@property (weak, nonatomic) IBOutlet UIImageView *iconView;//图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *rankLable;//规格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//单品个数
@property (weak, nonatomic) IBOutlet UILabel *frieghtLable;//运费
//@property (weak, nonatomic) IBOutlet UILabel *GBLable;//送金币个数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankWith;
@property (weak, nonatomic) IBOutlet UIButton *delectBtn;
@property (weak, nonatomic) IBOutlet UILabel *shopUser;
@property(nonatomic,copy)GSCartBlock gsCarBlock;//回调
@property(nonatomic,copy)GSDelectBlock gsDeleteBlock;//删除回调
@property(nonatomic,strong)GSCarModel * model;

- (IBAction)deleteBtn:(UIButton *)sender;
//刷新数据
-(void)reloadDeleteDataWith:(GSCarModel *)model;

@end
