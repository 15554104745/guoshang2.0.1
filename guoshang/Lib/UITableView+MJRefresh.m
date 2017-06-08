//
//  UITableView+MJRefresh.m
//  UITableViewRefreshTest
//
//  Created by Rechied on 16/9/7.
//  Copyright © 2016年 Rechied. All rights reserved.
//

#import "UITableView+MJRefresh.h"
@implementation UITableView (MJRefresh)

static void * kRequestDictionaryKey = (void *)@"requestDictionary";
static void * kRequestKey = (void *)@"requestKey";

- (NSMutableDictionary *)requestDictionary
{
    
    return objc_getAssociatedObject(self, kRequestDictionaryKey);
}

- (NSString *)requestKey {
    return objc_getAssociatedObject(self, kRequestKey);
}

- (void (^)(id , NSError *, MJRefreshType))resultBlock {
    return objc_getAssociatedObject(self, (void *)@"resultBlcok");
}

- (BOOL)footerReady {
    return objc_getAssociatedObject(self, (void *)@"footerReady");
}

- (void)setRequestDictionary:(NSMutableDictionary *)requestDictionary {
    objc_setAssociatedObject(self, kRequestDictionaryKey, requestDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRequestKey:(NSString *)requestKey {
    objc_setAssociatedObject(self, kRequestKey, requestKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setResultBlock:(void (^)(id, NSError *, MJRefreshType))resultBlock {
    objc_setAssociatedObject(self, (void *)@"resultBlcok", resultBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setFooterReady:(BOOL)footerReady {
    objc_setAssociatedObject(self, (void *)@"footerReady", @(footerReady), OBJC_ASSOCIATION_ASSIGN);
}


- (void)createRefreshHeader {
    
    __weak typeof(self) weakSelf = self;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.requestKey) {
            //NSLog(@"%@",weakSelf.requestDictionary);
            
            MJRefreshRequestModel *requestModel = [weakSelf.requestDictionary objectForKey:weakSelf.requestKey];
            [self.mj_footer resetNoMoreData];
                [[RequestManager manager] requestWithMode:RequestModePost URL:requestModel.requestURL parameters:[requestModel.params addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.resultBlock) {
                            weakSelf.resultBlock(responseObject,error,MJRefreshTypeClear);
                        }
                        if (!weakSelf.footerReady) {
                            [weakSelf createRefreshFooter];
                        } else {
                            if (requestModel.dataArray.count < requestModel.listRows) {
                                [weakSelf.mj_footer endRefreshingWithNoMoreData];
                            }
                        }
                        [weakSelf.mj_header endRefreshing];
                    });
                }];
        }
    }];
}

- (void)createRefreshFooter {
    MJRefreshRequestModel *requestModel = [self.requestDictionary objectForKey:self.requestKey];
    if (requestModel) {
        __weak typeof(self) weakSelf = self;
        self.footerReady = YES;
        self.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            
            NSInteger currentPage = requestModel.dataArray.count / requestModel.listRows + requestModel.startPageNumber;
            
            NSMutableDictionary *mDic = [requestModel.params mutableCopy];
            [mDic setObject:[NSString stringWithFormat:@"%zi",currentPage] forKey:requestModel.pagePropertyName];
            
            //NSLog(@"%@",mDic);
            //NSLog(@"%@",requestModel.params);
            
            [[RequestManager manager] requestWithMode:RequestModePost URL:requestModel.requestURL parameters:[mDic addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
                [weakSelf.mj_footer endRefreshing];
                if (weakSelf.resultBlock) {
                    weakSelf.resultBlock(responseObject,error,MJRefreshTypeAdd);
                }
                if (requestModel.dataArray.count < currentPage * requestModel.listRows) {
                    [weakSelf.mj_footer endRefreshingWithNoMoreData];
                }
            }];
        }];
        
        //NSLog(@"%zi",requestModel.dataArray.count);
        if (requestModel.listRows > requestModel.dataArray.count) {
            
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void)headerBeginRefreshWithRequestKey:(NSString *)requestKey result:(void (^) (id responseObject, NSError *error, MJRefreshType refreshType))result {
    self.requestKey = requestKey;
    if (result) {
        self.resultBlock = result;
    }
    [self.mj_header beginRefreshing];
}

- (void)headerBeginRefreshWithRequestKey:(NSString *)requestKey willChangeParams:(NSDictionary *)params result:(void (^) (id responseObject, NSError *error, MJRefreshType refreshType))result {
    MJRefreshRequestModel *requestModel = [self.requestDictionary objectForKey:requestKey];
    requestModel.params = [params mutableCopy];
    [self.requestDictionary setObject:requestModel forKey:requestKey];
    [self headerBeginRefreshWithRequestKey:requestKey result:result];
}

//- (void)footerBeginRefreshWithRequestKey:(NSString *)requestKey  result:(void (^)(id, NSError *))result {
//    if (result) {
//        self.resultBlock = result;
//    }
//    [self.mj_footer beginRefreshing];
//}

- (void)addRefreshWithRequestModel:(MJRefreshRequestModel *)requestModel requestKey:(NSString *)requestKey {
    if (!self.requestDictionary) {
        self.requestDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        [self createRefreshHeader];
    }
    
    [self.requestDictionary setObject:requestModel forKey:requestKey];
    //NSLog(@"%@",self.requestDictionary);
}




@end


@implementation MJRefreshRequestModel
+ (instancetype)refreshModelWithURL:(NSString *)URL dataArray:(NSMutableArray *)dataArray listRows:(NSInteger)listRows params:(NSDictionary *)params pagePropertyName:(NSString *)pagePropertyName startPageNumber:(NSInteger)startPageNumber {
    
    MJRefreshRequestModel *refreshModel = [[MJRefreshRequestModel alloc] init];
    refreshModel.requestURL = URL;
    refreshModel.dataArray = dataArray;
    refreshModel.listRows = listRows;
    refreshModel.params = params;
    refreshModel.pagePropertyName = pagePropertyName;
    refreshModel.startPageNumber = startPageNumber;
    
    return refreshModel;
}
@end