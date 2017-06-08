//
//  GSCarCell.h
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSCarModel.h"
/**
 cell是否被选中的回调
 @param select 是否被选中
 */

typedef void(^GSCartBlock)(BOOL select);
/**
 *  数量改变的回调
 */
typedef void(^NumChange)();
@interface GSCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic,assign)BOOL isSelected;//选中
@property (weak, nonatomic) IBOutlet UIImageView *GoodsImage;//商品图片
@property (weak, nonatomic) IBOutlet UILabel *numLable;//商品个数
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;//商品运费
@property (weak, nonatomic) IBOutlet UILabel *titleLable;//商品名称
//@property (weak, nonatomic) IBOutlet UIView *GBView;//赠送金币数量
@property (weak, nonatomic) IBOutlet UILabel *rankLable;//商品规格
//@property (weak, nonatomic) IBOutlet UILabel *coinLabel;//赠送金币合数
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//商品价格
@property (weak, nonatomic) IBOutlet UILabel *SizeLabel;//商品大小
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UILabel *numberLable;//加减个数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWith;

@property (weak, nonatomic) IBOutlet UILabel *shopUser;

@property(nonatomic,copy)GSCartBlock gsCarBlock;//回调
@property(nonatomic,copy)NumChange numAddBlock;//加
@property(nonatomic,copy)NumChange numCutBlock;//减
@property(nonatomic,copy)NSString * GBCount;
@property(nonatomic,strong)GSCarModel * model;
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
-(void)reloadDataWith:(GSCarModel *)model;
@end
