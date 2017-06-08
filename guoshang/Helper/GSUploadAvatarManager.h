//
//  GSUploadAvatarManager.h
//  guoshang
//
//  Created by Rechied on 16/9/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSUploadAvatarManager : NSObject
+ (void)uploadAvatar:(void(^)(UIImage *))completed;

@end
