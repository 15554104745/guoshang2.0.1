//
//  RequestManager.h
//  SlideTest
//
//  Created by Rechied on 16/2/24.
//  Copyright © 2016年 sdjjny. All rights reserved.
//

#import <Foundation/Foundation.h>



#import "AFNetworking.h"

typedef void(^completed)(id responseObject,NSError *error);

typedef enum {
    RequestModeGet,
    RequestModePost,
}RequestMode;

@interface RequestManager : NSObject
@property (copy, nonatomic) NSDictionary *device_info;
+ (instancetype)manager;
+ (NSDictionary *)device_info;
- (NSURLSessionDataTask *)requestWithMode:(RequestMode)requestMode URL:(NSString *)URL parameters:(id)parameters completed:(completed)completed;
- (void)uploadImageWithImage:(UIImage *)image completed:(completed)completed;


@end
