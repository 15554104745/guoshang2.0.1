//
//  GroupInfoTableViewCell.h
//  guoshang
//
//  Created by JinLian on 16/9/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupInfoModel.h"

typedef void(^passValueBlock)(NSDictionary *dataList);

@interface GroupInfoTableViewCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, strong)GroupInfoModel *model;
@property (nonatomic,copy)passValueBlock block;
//取消textfiled
- (void)textFieldResignFirstResponder ;
//传值
- (void)passValueAction;
@end
