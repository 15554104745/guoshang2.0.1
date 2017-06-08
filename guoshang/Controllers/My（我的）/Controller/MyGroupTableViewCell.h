//
//  MyGroupTableViewCell.h
//  guoshang
//
//  Created by JinLian on 16/8/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGroupModel.h"
#import "HeadModel.h"

typedef void(^buttonActionVlock)(NSString *tuanid);

@interface MyGroupTableViewCell : UITableViewCell

@property (nonatomic, copy)buttonActionVlock block;

@property (weak, nonatomic) IBOutlet UIImageView *goods_image;

@property (weak, nonatomic) IBOutlet UILabel *goods_name;

@property (weak, nonatomic) IBOutlet UILabel *goods_price;

@property (weak, nonatomic) IBOutlet UILabel *goods_oldPrice;

@property (weak, nonatomic) IBOutlet UILabel *goods_butCount;

@property (weak, nonatomic) IBOutlet UILabel *goods_buyTime;

@property (weak, nonatomic) IBOutlet UIButton *goods_goBuy;

@property (nonatomic, retain)MyGroupModel *model;

@property (nonatomic, copy)NSString *tuan_id;

@property (nonatomic, retain)HeadModel *headModel;

@end
