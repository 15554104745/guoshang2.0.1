//
//  PhotosViewController.h
//  PhotoView
//
//  Created by 赵彦飞 on 16/3/8.
//  Copyright © 2016年 WXG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotosDelegate <NSObject>

- (void)photoViewController:(NSArray *)selectList with:(NSArray *)indexList;

@end


@interface PhotosViewController : UIViewController

@property (nonatomic, strong) id<PhotosDelegate> delegate;

@property (nonatomic, copy)NSMutableArray *photoList;
@property (nonatomic, copy)NSMutableArray *indexList;//选中图片的位置数组
@property (nonatomic, copy)NSMutableArray *selectList;// 选中的图片数组
@end
