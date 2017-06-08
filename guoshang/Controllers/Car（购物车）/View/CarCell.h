//
//  CarCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/2/23.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "carModel.h"
/**
 cell是否被选中的回调
 @param select 是否被选中
 */

typedef void(^CartBlock)(BOOL select);
/**
 *  数量改变的回调
 */
typedef void(^NumChange)();



@interface CarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic,assign)BOOL isSelected;//选中
@property (weak, nonatomic) IBOutlet UIImageView *GoodsImage;//商品图片
@property (weak, nonatomic) IBOutlet UILabel *numLable;//商品个数
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;//商品运费
@property (weak, nonatomic) IBOutlet UILabel *titleLable;//商品名称
@property (weak, nonatomic) IBOutlet UIView *GBView;//赠送金币数量
@property (weak, nonatomic) IBOutlet UILabel *rankLable;//商品规格
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;//赠送金币合数
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//商品价格
@property (weak, nonatomic) IBOutlet UILabel *SizeLabel;//商品大小
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UILabel *numberLable;//加减个数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWith;

@property (weak, nonatomic) IBOutlet UILabel *shopUser;

@property(nonatomic,copy)CartBlock carBlock;//回调
@property(nonatomic,copy)NumChange numAddBlock;//加
@property(nonatomic,copy)NumChange numCutBlock;//减

@property(nonatomic,copy) void(^selectBlock)(void);

@property(nonatomic,copy)NSString * GBCount;
@property(nonatomic,strong)carModel * model;
- (IBAction)selectBtn:(id)sender;
- (IBAction)reduceBtn:(UIButton *)sender;
- (IBAction)backGrondBtn:(UIButton *)sender;
- (IBAction)addBtn:(UIButton *)sender;

@property(nonatomic,weak)NSMutableArray * orderArray;
/**
 *  @author LQQ, 16-02-18 11:02:39
 *
 *  刷新cell
 *
 *  @param model cell数据模型
 */
-(void)reloadDataWith:(carModel *)model;

@end
