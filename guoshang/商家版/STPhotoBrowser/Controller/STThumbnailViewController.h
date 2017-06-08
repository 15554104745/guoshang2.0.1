//
//  STThumbnailViewController.h
//  STPhotoBrowserDemo
//
//  Created by 孙涛 on 16/10/4.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAssetCollection;
@class STSelectPhotoModel;
@class STPhotoBrowser;

@interface STThumbnailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//相册属性
@property (nonatomic, strong) PHAssetCollection *assetCollection;

//当前已经选择的图片
@property (nonatomic, strong) NSMutableArray<STSelectPhotoModel *> *arraySelectPhotos;

//最大选择数
@property (nonatomic, assign) NSInteger maxSelectCount;
//是否选择了原图
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

@property (weak, nonatomic) IBOutlet UIButton *btnPreView;
@property (weak, nonatomic) IBOutlet UIButton *btnOriginalPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labPhotosBytes;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

//用于回调上级列表，把已选择的图片传回去
@property (nonatomic, weak) STPhotoBrowser *sender;

//选则完成后回调
@property (nonatomic, copy) void (^DoneBlock)(NSArray<STSelectPhotoModel *> *selPhotoModels, BOOL isSelectOriginalPhoto);
//取消选择后回调
@property (nonatomic, copy) void (^CancelBlock)();


@end
