//
//  STPhotoActionSheet.h
//  STPhotoBrowserDemo
//
//  Created by 孙涛 on 16/10/4.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class STSelectPhotoModel;

@interface STPhotoActionSheet : UIView


@property (nonatomic, weak) UIViewController *sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


/** 最大选择数 default is 10 */
@property (nonatomic, assign) NSInteger maxSelectCount;

/** 预览图最大显示数 default is 20 */
@property (nonatomic, assign) NSInteger maxPreviewCount;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)showWithSender:(UIViewController *)sender
               animate:(BOOL)animate
 lastSelectPhotoModels:(NSArray<STSelectPhotoModel *> * _Nullable)lastSelectPhotoModels
            completion:(void (^)(NSArray<UIImage *> *selectPhotos, NSArray<STSelectPhotoModel *> *selectPhotoModels))completion NS_DEPRECATED(2.0, 2.0, 2.0, 8.0, "Use - showPreviewPhotoWithSender:animate:lastSelectPhotoModels:completion:");

/**
 * @brief 显示多选照片视图，带预览效果
 * @param sender
 *              调用该控件的视图控制器
 * @param animate
 *              是否显示动画效果
 * @param lastSelectPhotoModels
 *              已选择的PHAsset，再次调用"showWithSender:animate:lastSelectPhotoModels:completion:"方法之前，可以把上次回调中selectPhotoModels赋值给该属性，便可实现记录上次选择照片的功能，若不需要记录上次选择照片的功能，则该值传nil即可
 * @param completion
 *              完成回调
 */
- (void)showPreviewPhotoWithSender:(UIViewController *)sender
                           animate:(BOOL)animate
             lastSelectPhotoModels:(NSArray<STSelectPhotoModel *> * _Nullable)lastSelectPhotoModels
                        completion:(void (^)(NSArray<UIImage *> *selectPhotos, NSArray<STSelectPhotoModel *> *selectPhotoModels))completion;

/**
 * @brief 显示多选照片视图，直接进入相册选择界面
 * @param sender
 *              调用该控件的视图控制器
 * @param lastSelectPhotoModels
 *              已选择的PHAsset，再次调用"showWithSender:animate:lastSelectPhotoModels:completion:"方法之前，可以把上次回调中selectPhotoModels赋值给该属性，便可实现记录上次选择照片的功能，若不需要记录上次选择照片的功能，则该值传nil即可
 * @param completion
 *              完成回调
 */
- (void)showPhotoLibraryWithSender:(UIViewController *)sender
             lastSelectPhotoModels:(NSArray<STSelectPhotoModel *> * _Nullable)lastSelectPhotoModels
                        completion:(void (^)(NSArray<UIImage *> *selectPhotos, NSArray<STSelectPhotoModel *> *selectPhotoModels))completion;

NS_ASSUME_NONNULL_END

@end



@interface CustomerNavgationController : UINavigationController

@property (nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;

@end
