//
//  GSUploadAvatarManager.m
//  guoshang
//
//  Created by Rechied on 16/9/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSUploadAvatarManager.h"
#import "GSTakePhotoManager.h"
#import "RequestManager.h"
#import "MBProgressHUD.h"

@implementation GSUploadAvatarManager

+ (void)uploadAvatar:(void(^)(UIImage *))completed {
    __weak typeof(self) weakSelf = self;
    [GSTakePhotoManager sharePicture:^(UIImage *image) {
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
        [[RequestManager manager] uploadImageWithImage:image completed:^(id responseObject, NSError *error) {
            
            if (responseObject && [responseObject[@"status"] isEqualToString:@"0"]) {
                [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/User/avatar") parameters:[@{@"user_id":UserId,@"avatar":responseObject[@"result"][@"image_url"]} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
                    
                    [MBProgressHUD hideHUDForView:nil animated:YES];
                    if (responseObject && [responseObject[@"status"] isEqualToString:@"0"]) {
                        
                        [weakSelf alertWithMessage:@"上传头像成功!"];
                        if (completed) {
                            completed(image);
                        }
                    }
                }];
            } else {
                [MBProgressHUD hideHUDForView:nil animated:YES];
                [weakSelf alertWithMessage:@"上传头像失败,请稍后再试!"];
            }
        }];
    }];
}

+ (void)alertWithMessage:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
}

@end
