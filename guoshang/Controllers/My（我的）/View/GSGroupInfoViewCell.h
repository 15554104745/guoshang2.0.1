//
//  GSGroupInfoViewCell.h
//  guoshang
//
//  Created by 金联科技 on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSGroupUserModel.h"
@interface GSGroupInfoViewCell : UICollectionViewCell
// 是否为团长
@property (nonatomic,assign) BOOL grouper;
@property (nonatomic,strong) GSGroupUserModel *model;
@end
