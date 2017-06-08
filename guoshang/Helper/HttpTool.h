//
//  HttpTool.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/11.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"
#import "APAuthV2Info.h"
@class HttpTool;
@protocol HttpToolDelegate <NSObject>
-(void)toPopToOrder;

@end
@interface HttpTool : NSObject
@property(nonatomic,strong)NSDictionary *orderDic;
@property(nonatomic,copy)NSString * statusStr;


/**
 *  POST请求
 *
 *  @param URLString  用来创建请求URL的URL string(基本URL)
 *  @param parameters 请求参数
 *  @param success    请求成功时回调
 *  @param failure    请求失败时回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;
/**
 *  GET请求
 *
 *  @param URLString  用来创建请求URL的URL string(基本URL)
 *  @param parameters 请求参数
 *  @param success    请求成功时回调
 *  @param failure    请求失败时回调
 */


+(void)GET:(NSString *)URLString parameters:(id)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;



+(void)toPayWithAliSDKWith:(NSDictionary *)rootDic AndViewController:(UIViewController *)controller Isproperty:(BOOL)isProperty IsToPayForProperty:(BOOL) isToPayForProperty;


+(void)clearAllCaches;
@end
