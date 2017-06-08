//
//  GSRefundCell.h
//  guoshang
//
//  Created by 金联科技 on 16/10/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSRefundInfoModel.h"
@interface GSRefundCell : UITableViewCell

+(instancetype)refundCellWithTableView:(UITableView*)tableView;
@property (nonatomic,strong) GSConsultModel *consultModel;
@property (nonatomic,copy) NSString *return_Money;
@end
