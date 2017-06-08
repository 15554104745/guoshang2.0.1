//
//  BatchTableViewCell.h
//  guoshang
//
//  Created by JinLian on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BatchManageModel.h"

@interface BatchTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *gooods_addtime;
@property (weak, nonatomic) IBOutlet UIImageView *goods_image;
@property (weak, nonatomic) IBOutlet UIImageView *goods_selectImage;
@property (weak, nonatomic) IBOutlet UILabel *goods_information;
@property (weak, nonatomic) IBOutlet UILabel *goods_sendNumber;
@property (weak, nonatomic) IBOutlet UILabel *goods_save;
@property (weak, nonatomic) IBOutlet UILabel *goods_Price;
@property (weak, nonatomic) IBOutlet UILabel *goods_oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *goods_status;
@property (weak, nonatomic) IBOutlet UILabel *goods_inventory;

@property(assign,nonatomic)BOOL selectState;//选中状态

@property (nonatomic, strong)BatchManageModel *dateModel;
@end
