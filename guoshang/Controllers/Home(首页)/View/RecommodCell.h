//
//  RecommodCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/2/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BestModel.h"
@interface RecommodCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *IconView;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@property(nonatomic,strong)BestModel * model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWith;
@end
