//
//  PhotoView.h
//  PhotoView
//
//  Created by 赵彦飞 on 16/3/8.
//  Copyright © 2016年 WXG. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PhotosViewController.h"
//#import "ELCImagePickerDemoViewController.h"

typedef void (^passValueBlock)(NSArray *arr);

@interface PhotoView : UIView

@property (nonatomic, copy)NSMutableArray *photoList;//保存传入的图片数据
@property (nonatomic, copy)NSMutableArray *indexList;//保存传入的图片的位置数据

@property (nonatomic, copy)NSMutableArray *itemList;// 添加的所有的item

@property (nonatomic, copy)passValueBlock block;

- (void)returnValueWithBlock:(passValueBlock)block;


@end





@interface UIView (UIViewController)

- (UIViewController *)viewController;

@end