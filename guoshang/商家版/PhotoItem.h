//
//  PhotoItem.h
//  PhotoView
//
//  Created by 孙涛 on 16/7/21.
//  Copyright © 2016年 WXG. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kItemW 80
#define kItemH 100
#define kSpace 20

@interface PhotoItem : UIImageView

@property (nonatomic, strong)UIButton *deleteButton;

@property (nonatomic, assign)NSInteger index;


@end
