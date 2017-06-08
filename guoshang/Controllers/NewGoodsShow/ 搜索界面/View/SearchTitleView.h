//
//  SearchTitleView.h
//  guoshang
//
//  Created by JinLian on 16/9/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^passValueBlock)(NSDictionary *paramsDic);
typedef void(^exchangeColumnBlock)(BOOL is_showTwoColumns);
typedef void (^SearchTypeBlock)(NSString * type);
@interface SearchTitleView : UIView
@property(nonatomic,strong)NSString * type;
@property (nonatomic, copy)passValueBlock block;
@property (nonatomic, strong)NSMutableDictionary *params;
@property (nonatomic, copy)exchangeColumnBlock exchangeBlock;
@property(nonatomic,copy)SearchTypeBlock SearchTypeBlock;
@end
