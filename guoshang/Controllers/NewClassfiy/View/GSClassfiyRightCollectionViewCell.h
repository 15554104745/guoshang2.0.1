//
//  GSClassfiyRightCollectionViewCell.h
//  guoshang
//
//  Created by Rechied on 2016/11/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSClassfiyItemModel.h"

@interface GSClassfiyRightCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) GSClassfiyItemModel *itemModel;
@end
