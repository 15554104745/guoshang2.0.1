//
//  GSReimburseCell.h
//  guoshang
//
//  Created by 金联科技 on 16/9/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSReimburseModel.h"
@class GSReimburseCell;
typedef void(^btnStatusBlock)(NSString*,NSString*);


@interface GSReimburseCell : UITableViewCell

@property (nonatomic,strong)GSReimburseModel *model;
@property (nonatomic,copy) btnStatusBlock btnStatus;
+(instancetype)cellWithTabelView:(UITableView*)tableView;

@end
