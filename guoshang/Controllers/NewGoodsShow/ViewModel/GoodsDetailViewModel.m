//
//  GoodsDetailViewModel.m
//  guoshang
//
//  Created by JinLian on 16/9/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsDetailViewModel.h"
#import "MBProgressHUD.h"
#import "AttributeModel.h"
#import "HotGoodsModel.h"
#import "GoodsDetailShopInfoModel.h"
#import "GoodsDetailGoodsInfoModel.h"



#define STWeak(type) __weak typeof(type) weak##type = type

@interface GoodsDetailViewModel () {
    
    NSMutableDictionary *goodsDataList;
    NSInteger backViewHight;
    NSMutableString * type;


}

@end

@implementation GoodsDetailViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        
    }
    return self;
}

- (void)passValueWithBlock:(passValueBlock)block {

    STWeak(self);
    
    goodsDataList = [NSMutableDictionary dictionary];
    NSMutableArray *picArray = [NSMutableArray array];
    NSMutableArray *attrArray = [NSMutableArray array];
    NSMutableArray *bestArray = [NSMutableArray array];
//    NSMutableArray *hotArray = [NSMutableArray array];
    
    
    if (_goodId) {
        [MBProgressHUD showHUDWithCustomAnimationAddedTo:[[UIApplication sharedApplication].delegate window]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_group_t getDataGroup = dispatch_group_create();
            
            //NSLog(@"%@",_goodId);
            
            NSDictionary *dic;
            if (UserId) {
                dic = @{@"user_id":UserId,
                        @"goods_id":_goodId
                        };
            }else {
                dic = @{@"goods_id":_goodId};
            }
            dispatch_group_enter(getDataGroup);
            [HttpTool POST:URLDependByBaseURL(@"/Api/Goods/view") parameters:dic success:^(id responseObject) {
                
                if ([responseObject[@"status"] integerValue]==2) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakself.goodsDetailVC.navigationController popViewControllerAnimated:YES];
                    });
                }else if([responseObject[@"status"] integerValue]==1){
                    
                    //等于1 接口返回数据成功
                    if (responseObject[@"result"][@"goodsinfo"]==false) {
                        [weakself.goodsDetailVC.navigationController popViewControllerAnimated:YES];
                    }
                    //地址
                    if ([responseObject[@"result"][@"address"] isKindOfClass:[NSDictionary class]]) {
                        [goodsDataList setObject:[responseObject[@"result"][@"address"] objectForKey:@"address_str"] forKey:@"address_str"];
                        [goodsDataList setObject:[responseObject[@"result"][@"address"] objectForKey:@"province_id"] forKey:@"province_id"];
                    }
                    

                    
                    //货物信息
                    NSDictionary *dic = responseObject[@"result"][@"goodsinfo"];
                    
                    NSError *error;
                    GoodsDetailGoodsInfoModel * goodsInfoModel = [[GoodsDetailGoodsInfoModel alloc]initWithDictionary:dic error:&error];
//                    NSLog(@"%@",error);
                    if (!IsNilOrNull(goodsInfoModel)) {
                        [goodsDataList setObject:goodsInfoModel forKey:@"goodsInfo"];
                    }
                    

                    //商家信息
                    NSDictionary *shopDic = responseObject[@"result"][@"shop_info"];
                    GoodsDetailShopInfoModel *shopInfoModel = [[GoodsDetailShopInfoModel alloc]initWithDictionary:shopDic error:nil];
                    [goodsDataList setObject:shopInfoModel forKey:@"shop_info"];
                    
                    //轮播图图片
                    for (NSDictionary * dic1 in responseObject[@"result"][@"pictures"]) {
                        NSString *pictureStr = dic1[@"img_url"];
                        if (pictureStr) {
                            if ([pictureStr rangeOfString:@"http"].location == NSNotFound) {
                                pictureStr = [NSString stringWithFormat:@"%@%@",ImageBaseURL,pictureStr];
                            }
                            [picArray addObject:pictureStr];
                        }
                    }
                    [goodsDataList setObject:picArray forKey:@"pictures"];
                    
                    //商品属性
                    if (responseObject[@"result"][@"attribute"] != nil) {

                        for (NSDictionary * dic in responseObject[@"result"][@"attribute"]) {
                            AttributeModel * attributeModel = [[AttributeModel alloc]init];
                            [attributeModel setValuesForKeysWithDictionary:dic];
                            [attrArray addObject:attributeModel];
                        }
                        [goodsDataList setObject:attrArray forKey:@"attribute"];
                        
                        if (attrArray.count != 0) {
                            backViewHight = 250;
                            type = [NSMutableString stringWithString:[attrArray[0] attr_names]];
                        }else{
                            backViewHight = 180;
                        }
                    }
                    dispatch_group_leave(getDataGroup);
                }
                
            } failure:^(NSError *error) {
                dispatch_group_leave(getDataGroup);
                
            }];
            
            //精选推荐
            dispatch_group_enter(getDataGroup);
            [HttpTool POST:URLDependByBaseURL(@"/Api/Index/get_recommend_goods") parameters:@{@"type":@"best",@"amount":@"6"} success:^(id responseObject) {

                for (NSDictionary * dic in responseObject[@"result"]) {
                    HotGoodsModel * model = [[HotGoodsModel alloc]initWithDictionary:dic error:nil];
                    [bestArray addObject:model];
                }
                [goodsDataList setObject:bestArray forKey:@"best"];
                
                dispatch_group_leave(getDataGroup);
            } failure:^(NSError *error) {
                dispatch_group_leave(getDataGroup);
            }];
            
            if (UserId) {
                //上传浏览记录
                NSDictionary *AddUserBrowseGoods = @{@"user_id":UserId,
                                                     @"goods_id":_goodId
                                                     };
                dispatch_group_enter(getDataGroup);
                [HttpTool POST:URLDependByBaseURL(@"/Api/User/AddUserBrowseGoods") parameters:@{@"token":[AddUserBrowseGoods paramsDictionaryAddSaltString]} success:^(id responseObject) {
                    
                    dispatch_group_leave(getDataGroup);
                } failure:^(NSError *error) {
                    dispatch_group_leave(getDataGroup);
                }];
                
            }

//            //门店热销
//            dispatch_group_enter(getDataGroup);
//            [HttpTool POST:URLDependByBaseURL(@"/Api/Index/get_recommend_goods") parameters:@{@"type":@"hot",@"amount":@"6"} success:^(id responseObject) {
//                
//                for (NSDictionary * dic in responseObject[@"result"]) {
//            HotGoodsModel * model = [[HotGoodsModel alloc]initWithDictionary:dic error:nil];
//                    [hotArray addObject:model];
//                }
//                [goodsDataList setObject:hotArray forKey:@"hot"];
//                
//                dispatch_group_leave(getDataGroup);
//            } failure:^(NSError *error) {
//                dispatch_group_leave(getDataGroup);
//            }];
            
            //获取正在展示的商品的购物车数量
//            if (UserId) {
//                dispatch_group_enter(getDataGroup);
//                [HttpTool POST:URLDependByBaseURL(@"/Api/User/myaddress") parameters:@{@"token":[ @{@"user_id":UserId} paramsDictionaryAddSaltString]} success:^(id responseObject) {
//                    if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
//                        NSArray *dataList = [responseObject objectForKey:@"result"];
//                        for (NSDictionary *dic in dataList) {
//                            
//                            if ([[dic objectForKey:@"is_default"] integerValue] == 1) {
//                                
//                                [goodsDataList setObject:[dic objectForKey:@"address_str"] forKey:@"address_str"];
//                            }
//                        }
//                    }
//                    
//                    dispatch_group_leave(getDataGroup);
//                } failure:^(NSError *error) {
//                    dispatch_group_leave(getDataGroup);
//                }];
//                
//            }
            
            dispatch_group_wait(getDataGroup, DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
                block(goodsDataList);
            });
        });
        
    }else {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        [self.goodsDetailVC.navigationController popViewControllerAnimated:YES];
    }
}















@end
