//
//  JTRYTableViewCell.h
//  guoshang
//
//  Created by hi on 16/2/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTRYTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *leftBigIconView;//左侧最大的图片
@property (nonatomic,strong)UIImageView *leftSmallIconView;//左侧小的图片
@property (nonatomic,strong)UIImageView *leftSmallTwoIconView;//左侧第二个的图片
@property (nonatomic,strong)UIImageView *rightSmallIconView;//右侧最小的图片
@property (nonatomic,strong)UIImageView *rightSmallTwoIconView;
@property (nonatomic,strong)UIImageView *rightBigIconView;//右侧最大的图片
@end
