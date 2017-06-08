//
//  STBigImageCell.h
//  STPhotoBrowserDemo
//
//  Created by 孙涛 on 16/10/4.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;

@interface STBigImageCell : UICollectionViewCell
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy)   void (^singleTapCallBack)();

@end
