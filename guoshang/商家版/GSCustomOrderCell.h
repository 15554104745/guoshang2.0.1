//
//  GSCustomOrderCell.h
//  guoshang
//
//  Created by 金联科技 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSGroupOrderModel.h"
@interface GSCustomOrderCell : UITableViewCell

@property (nonatomic,strong)GSGroupOrderModel *orderModel;
+(GSCustomOrderCell*)createCellWithTableView:(UITableView*)tableView;
@end
