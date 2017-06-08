//
//  GSMineCollectionViewCell.h
//  guoshang
//
//  Created by Rechied on 2016/10/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSMineToolsModel.h"

@interface GSMineCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) GSMineToolsModel *toolsModel;
@end
