//
//  GSGoodsDetailModel.m
//  guoshang
//
//  Created by Rechied on 2016/11/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGoodsDetailModel.h"

@implementation GSGoodsDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"pictures":@"GSGoodsDetialPicturesModel"};
}

- (NSArray *)getAllImageURL {
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.pictures enumerateObjectsUsingBlock:^(GSGoodsDetialPicturesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArray addObject:obj.img_url];
    }];
    return [[NSArray alloc] initWithArray:tempArray];
}
@end
