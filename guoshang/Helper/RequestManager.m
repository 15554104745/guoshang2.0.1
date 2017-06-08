//
//  RequestManager.m
//  SlideTest
//
//  Created by Rechied on 16/2/24.
//  Copyright © 2016年 sdjjny. All rights reserved.
//

#import "RequestManager.h"
#import <sys/utsname.h>

static RequestManager *_manager = nil;
static AFHTTPSessionManager *_requestManager = nil;



@implementation RequestManager


+ (instancetype)manager
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL] init];
        _requestManager = [AFHTTPSessionManager manager];
    });
    
    return _manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [RequestManager manager];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [RequestManager manager];
}


- (NSURLSessionDataTask *)requestWithMode:(RequestMode)requestMode URL:(NSString *)URL parameters:(id)parameters completed:(completed)completed {
    
    switch (requestMode) {
        case RequestModeGet:
        {
            return [_requestManager GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completed(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completed(nil,error);
            }];
        }
            break;
            
        case RequestModePost:
        {
            
            return [_requestManager POST:URL parameters:parameters constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                completed(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completed(nil,error);
            }];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)uploadImageWithImage:(UIImage *)image completed:(completed)completed {
    
     NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    //@{@"token":[self paramsDictionary:@{@"user_id":UserId} addSaltWithSaltKey:KEY]}
    [_requestManager POST:URLDependByBaseURL(@"/Api/Upload/Image") parameters:@{@"token":[@{@"user_id":UserId} paramsDictionaryAddSaltString]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //[formData appendPartWithFormData:imageData name:@"file"];
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completed(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completed(nil,error);
    }];
    
}

- (NSString *)paramsDictionary:(NSDictionary *)params addSaltWithSaltKey:(NSString *)saltKey {
    __block NSMutableString *tempStr = [[NSMutableString alloc] initWithCapacity:0];
    [[params allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            [tempStr appendString:@","];
        }
        [tempStr appendString:[NSString stringWithFormat:@"%@=%@",obj,params[obj]]];
    }];
    
    return [tempStr encryptStringWithKey:saltKey];
}


+ (NSDictionary *)device_info {
    if (!_manager) {
        _manager = [RequestManager manager];
    }
    return [_manager device_info];
}

- (NSDictionary *)device_info {
    if (!_device_info) {
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        UIDevice *device = [UIDevice currentDevice];
        [mDic setObject:device.systemName forKey:@"systemName"];
        [mDic setObject:device.systemVersion forKey:@"systemVersion"];
        [mDic setObject:[_manager iphoneType] forKey:@"phoneType"];
        NSString *versionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [mDic setObject:versionCode forKey:@"appVersion"];
        _device_info = [[NSDictionary alloc] initWithDictionary:mDic];
    }
    return _device_info;
}

- (NSString *)iphoneType {
    
    
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    
    
    
    
    return platform;
    
}





@end
