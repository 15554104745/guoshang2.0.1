//
//  CarEditCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/2/27.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "carModel.h"
/**
 cell是否被选中的回调
 @param select 是否被选中
 */

typedef void(^CartBlock)(BOOL select);
typedef void(^DelectBlock)();
@interface CarEditCell : UITableViewCell
@property(nonatomic)BOOL isSelect;
@property (weak, nonatomic) IBOutlet UIButton *selection;//选中button
@property (weak, nonatomic) IBOutlet UIImageView *iconView;//图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *rankLable;//规格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//单品个数
@property (weak, nonatomic) IBOutlet UILabel *frieghtLable;//运费
@property (weak, nonatomic) IBOutlet UILabel *GBLable;//送金币个数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankWith;
@property (weak, nonatomic) IBOutlet UIButton *delectBtn;
@property (weak, nonatomic) IBOutlet UILabel *shopUser;
@property(nonatomic,copy)CartBlock carBlock;//回调
@property(nonatomic,copy)DelectBlock deleteBlock;//删除回调
@property(nonatomic,strong)carModel * model;
@property(nonatomic,copy) void(^selectBlock)(void);

- (IBAction)deleteBtn:(UIButton *)sender;
//刷新数据
-(void)reloadDeleteDataWith:(carModel *)model;
@end
