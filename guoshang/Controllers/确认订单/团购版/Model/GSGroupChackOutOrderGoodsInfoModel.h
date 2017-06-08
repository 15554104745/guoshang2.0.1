//
//  GSGroupChackOutOrderGoodsInfoModel.h
//  guoshang
//
//  Created by Rechied on 16/9/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSGoodsGalleryModel.h"

@interface GSGroupChackOutOrderGoodsInfoModel : NSObject

@property (copy, nonatomic) NSString *goods_thumb;
@property (copy, nonatomic) NSString *goods_img;
@property (copy, nonatomic) NSArray *goods_gallery;
@property (copy, nonatomic) NSString *original_img;
@property (copy, nonatomic) NSString *goods_brief;
@property (copy, nonatomic) NSString *goods_name;
@property (copy, nonatomic) NSString *goods_id;

@end
