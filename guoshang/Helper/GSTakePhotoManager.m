//
//  takePhoto.m
//  TakePicture
//
//  Created by yitonghou on 15/8/5.
//  Copyright (c) 2015年 移动事业部. All rights reserved.
//

#define AppRootView  ([[[[[UIApplication sharedApplication] delegate] window] rootViewController] view])

#define AppRootViewController  ([[[[UIApplication sharedApplication] delegate] window] rootViewController])

#import "GSTakePhotoManager.h"

@implementation GSTakePhotoManager
{
    NSUInteger sourceType;
}

+ (GSTakePhotoManager *)sharedModel{
    static GSTakePhotoManager *sharedModel = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

+(void)sharePictureNotAutoBack:(finishSelectBlock)finishBlock {
    GSTakePhotoManager *tP = [GSTakePhotoManager sharedModel];
    tP.finishBlock = finishBlock;
    [self showSheet];
}

+ (void)sharePicture:(sendPictureBlock)block{
    GSTakePhotoManager *tP = [GSTakePhotoManager sharedModel];
    tP.sPictureBlock =block;
    [self showSheet];
}

+ (void)showSheet {
    GSTakePhotoManager *tP = [GSTakePhotoManager sharedModel];
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:tP cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"相册中获取", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"设置图像" delegate:tP cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"相册中获取", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:AppRootView];
}


#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        // 跳转到相机或相册页面
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"icon_nav_background"] forBarMetrics:UIBarMetricsDefault];
        
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [AppRootViewController presentViewController:imagePickerController animated:YES completion:NULL];
        
    }
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    GSTakePhotoManager *TPhoto = [GSTakePhotoManager sharedModel];

    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (TPhoto.sPictureBlock) {
        [picker dismissViewControllerAnimated:YES completion:^{}];
        [TPhoto sPictureBlock](image);
        
    }
    if (TPhoto.finishBlock) {
        [TPhoto finishBlock](image,picker);
    }
    
}


@end
