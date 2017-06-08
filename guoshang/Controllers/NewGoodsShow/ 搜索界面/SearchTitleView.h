//
//  SearchTitleView.h
//  guoshang
//
//  Created by JinLian on 16/9/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^passValueBlock)(NSDictionary *paramsDic);

@interface SearchTitleView : UIView

@property (nonatomic, copy)passValueBlock block;
@property (nonatomic, strong)NSMutableDictionary *params;
@end
