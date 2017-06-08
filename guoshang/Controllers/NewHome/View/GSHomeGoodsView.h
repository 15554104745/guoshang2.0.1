//
//  GSHomeGoodsView.h
//  guoshang
//
//  Created by Rechied on 16/8/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSHomeCellGoodsModel.h"
@interface GSHomeGoodsView : UIView

@property (copy, nonatomic) void(^pushClick)(UIViewController *viewController);

- (instancetype)initWithGoodsModel:(GSHomeCellGoodsModel *)goodsModel labStr:(NSString *)labStr labColor:(NSString *)labColor;

@end
