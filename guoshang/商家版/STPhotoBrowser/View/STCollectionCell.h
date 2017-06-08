//
//  STCollectionCell.h
//  STPhotoBrowserDemo
//
//  Created by 孙涛 on 16/10/4.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;

@end
