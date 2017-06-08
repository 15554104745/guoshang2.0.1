//
//  CateGoryView.h
//  guoshang
//
//  Created by JinLian on 16/8/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , cateType) {
    cateTypeOfshopCate,  //店铺分类
    cateTypeOfdefault,   //平台分类

};

typedef  void (^passValueB)(NSString *shopID);
typedef void(^dismissBlock)(void);

@interface CateGoryView : UIView

@property (nonatomic, copy)passValueB block;

@property (nonatomic, copy)dismissBlock dismissBlock;

- (void)returnValue:(passValueB)block;

@property (nonatomic, assign)cateType catetype;

- (instancetype)initWithFrame:(CGRect)frame withCateType:(cateType) type ;

@end
