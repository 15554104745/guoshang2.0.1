//
//  takePhoto.h
//  TakePicture
//
//  Created by yitonghou on 15/8/5.
//  Copyright (c) 2015年 移动事业部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//使用block 返回值
typedef void (^sendPictureBlock)(UIImage *image);
typedef void (^finishSelectBlock)(UIImage *image, UIImagePickerController *picker);

@interface GSTakePhotoManager : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic,copy)sendPictureBlock sPictureBlock;
@property (nonatomic,copy)finishSelectBlock finishBlock;

+ (GSTakePhotoManager *)sharedModel;

+(void)sharePicture:(sendPictureBlock)block;
+(void)sharePictureNotAutoBack:(finishSelectBlock)finishBlock;

@end


