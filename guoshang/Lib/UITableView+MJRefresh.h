//
//  UITableView+MJRefresh.h
//  UITableViewRefreshTest
//
//  Created by Rechied on 16/9/7.
//  Copyright © 2016年 Rechied. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "RequestManager.h"

@class MJRefreshRequestModel;


@interface UITableView (MJRefresh)

@property (strong, nonatomic) NSMutableDictionary <__kindof NSString *, MJRefreshRequestModel *> * requestDictionary;
@property (copy, nonatomic) NSString *requestKey;
@property (copy, nonatomic) void (^resultBlock) (id responseObject, NSError *error, MJRefreshType refreshType);
@property (assign, nonatomic) BOOL footerReady;

- (void)addRefreshWithRequestModel:(MJRefreshRequestModel *)requestModel requestKey:(NSString *)requestKey;

- (void)headerBeginRefreshWithRequestKey:(NSString *)requestKey result:(void (^) (id responseObject, NSError *error, MJRefreshType refreshType))result;

//- (void)footerBeginRefreshWithRequestKey:(NSString *)requestKey requestParams:(NSDictionary *)params result:(void (^) (id responseObject, NSError *error))result;

@end

@interface MJRefreshRequestModel : NSObject

@property (copy, nonatomic) NSString *requestURL;
@property (weak, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger listRows;
@property (copy, nonatomic) NSDictionary *params;

@property (copy, nonatomic) NSString *pagePropertyName; //填要传页码的字断名
@property (assign, nonatomic) NSInteger startPageNumber; //页码起始值 默认为0

+(instancetype)refreshModelWithURL:(nonnull NSString *)URL dataArray:(nonnull NSMutableArray *)dataArray listRows:(NSInteger)listRows params:(nonnull NSDictionary *)params pagePropertyName:(nonnull NSString *)pagePropertyName startPageNumber:(NSInteger)startPageNumber;
@end
