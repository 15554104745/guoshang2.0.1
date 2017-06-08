//
//  STPhotoBrowser.h
//  STPhotoBrowserDemo
//
//  Created by 孙涛 on 16/10/4.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STSelectPhotoModel;

@interface STPhotoBrowser : UITableViewController

//最大选择数
@property (nonatomic, assign) NSInteger maxSelectCount;
//是否选择了原图
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
//当前已经选择的图片
@property (nonatomic, strong) NSMutableArray<STSelectPhotoModel *> *arraySelectPhotos;

//选则完成后回调
@property (nonatomic, copy) void (^DoneBlock)(NSArray<STSelectPhotoModel *> *selPhotoModels, BOOL isSelectOriginalPhoto);
//取消选择后回调
@property (nonatomic, copy) void (^CancelBlock)();



@end
